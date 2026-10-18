export type Color = string | string[];

export function linearGradient(colors: string[]): string {
  return `linear-gradient(to right, ${colors.join(", ")})`;
}

type Rgb = { r: number; g: number; b: number };

/**
 * Named colors accepted by the Lua `color` option. Values are kept in the
 * project's palette range so any preset stays readable on the dark surface.
 */
const NAMED_COLORS: Record<string, string> = {
  red: "#ef4444",
  rose: "#f43f5e",
  orange: "#f97316",
  amber: "#f59e0b",
  yellow: "#eab308",
  lime: "#84cc16",
  green: "#22c55e",
  emerald: "#10b981",
  teal: "#14b8a6",
  cyan: "#06b6d4",
  sky: "#0ea5e9",
  blue: "#3b82f6",
  indigo: "#6366f1",
  violet: "#8b5cf6",
  purple: "#a855f7",
  fuchsia: "#d946ef",
  pink: "#ec4899",
  white: "#e5e7eb",
  gray: "#64748b",
  grey: "#64748b",
  slate: "#64748b",
};

function hexToRgb(hex: string): Rgb | null {
  let value = hex.trim().replace("#", "");

  if (value.length === 3) {
    value = value
      .split("")
      .map((channel) => channel + channel)
      .join("");
  }

  if (value.length !== 6) {
    return null;
  }

  const parsed = Number.parseInt(value, 16);

  if (Number.isNaN(parsed)) {
    return null;
  }

  return {
    r: (parsed >> 16) & 255,
    g: (parsed >> 8) & 255,
    b: parsed & 255,
  };
}

/** Parses a hex, `rgb()/rgba()` or named CSS color into RGB channels. */
function parseColor(color: string): Rgb | null {
  const value = color.trim();

  if (value.startsWith("#")) {
    return hexToRgb(value);
  }

  const rgbMatch = value.match(
    /^rgba?\(\s*([\d.]+)[\s,]+([\d.]+)[\s,]+([\d.]+)/i,
  );

  if (rgbMatch) {
    return {
      r: clampChannel(Number(rgbMatch[1])),
      g: clampChannel(Number(rgbMatch[2])),
      b: clampChannel(Number(rgbMatch[3])),
    };
  }

  const named = NAMED_COLORS[value.toLowerCase()];

  return named ? hexToRgb(named) : null;
}

function clampChannel(channel: number): number {
  if (Number.isNaN(channel)) return 0;
  return Math.max(0, Math.min(255, Math.round(channel)));
}

function mix(rgb: Rgb, target: number, amount: number): Rgb {
  return {
    r: clampChannel(rgb.r + (target - rgb.r) * amount),
    g: clampChannel(rgb.g + (target - rgb.g) * amount),
    b: clampChannel(rgb.b + (target - rgb.b) * amount),
  };
}

function toRgbString(rgb: Rgb): string {
  return `rgb(${rgb.r} ${rgb.g} ${rgb.b})`;
}

function toAlphaString(rgb: Rgb, alpha: number): string {
  return `rgb(${rgb.r} ${rgb.g} ${rgb.b} / ${alpha}%)`;
}

/**
 * Builds the set of accent CSS variables that recolor a whole menu from one or
 * more base colors, matching the token names declared in the `@theme` block.
 * A single color tints the accent and derives a two-stop banner gradient; an
 * array of colors spreads them across the banner as a multi-stop gradient while
 * the accent tokens follow the first color. Returns undefined when no/invalid
 * color is given so the default slate theme is kept.
 */
export function buildMenuColorVars(
  color?: Color,
): Record<string, string> | undefined {
  if (!color) {
    return undefined;
  }

  const list = (Array.isArray(color) ? color : [color]).filter(
    (value): value is string => typeof value === "string" && value.trim() !== "",
  );

  const rgbList: Rgb[] = [];

  for (const value of list) {
    const rgb = parseColor(value);

    if (rgb) {
      rgbList.push(rgb);
    }
  }

  if (rgbList.length === 0) {
    return undefined;
  }

  const base = rgbList[0];
  const deep = rgbList.length > 1 ? rgbList[rgbList.length - 1] : mix(base, 0, 0.35);
  const anchor = mix(base, 255, 0.35);

  const vars: Record<string, string> = {
    "--color-accent": toRgbString(base),
    "--color-accent-deep": toRgbString(deep),
    "--color-item-selected": toAlphaString(base, 22),
    "--color-control-selected": toAlphaString(base, 30),
    "--color-anchor": toRgbString(anchor),
    "--menu-accent": toRgbString(base),
    "--menu-item-selected": toAlphaString(base, 22),
    "--menu-control-selected": toAlphaString(base, 30),
    "--menu-anchor": toRgbString(anchor),
    "--menu-banner": `linear-gradient(135deg, ${toRgbString(base)}, ${toRgbString(deep)})`,
  };

  // With several colors, spread the gradient across every accent surface. These
  // tokens must always be written inline: the `:root` defaults resolve their
  // nested `var(--color-*)` at `:root`, so an override on the menu element
  // would otherwise be ignored.
  if (rgbList.length > 1) {
    const full = rgbList.map(toRgbString).join(", ");
    const soft = rgbList.map((rgb) => toAlphaString(rgb, 22)).join(", ");
    const control = rgbList.map((rgb) => toAlphaString(rgb, 30)).join(", ");
    const anchorStops = rgbList
      .map((rgb) => toRgbString(mix(rgb, 255, 0.35)))
      .join(", ");

    vars["--menu-banner"] = `linear-gradient(135deg, ${full})`;
    vars["--menu-accent"] = `linear-gradient(135deg, ${full})`;
    vars["--menu-item-selected"] = `linear-gradient(90deg, ${soft})`;
    vars["--menu-control-selected"] = `linear-gradient(90deg, ${control})`;
    vars["--menu-anchor"] = `linear-gradient(90deg, ${anchorStops})`;
  }

  return vars;
}

/**
 * Accent CSS variables managed per menu, used to apply and clear them. Includes
 * both the flat color tokens and the gradient-capable surfaces so switching a
 * menu from a gradient back to a solid color (or none) removes the leftovers.
 */
export const ACCENT_COLOR_VARS = [
  "--color-accent",
  "--color-accent-deep",
  "--color-item-selected",
  "--color-control-selected",
  "--color-anchor",
  "--menu-banner",
  "--menu-accent",
  "--menu-item-selected",
  "--menu-control-selected",
  "--menu-anchor",
] as const;

/** Whether the reserved `"rainbow"` color was requested for a menu. */
export function isRainbowColor(color?: Color): boolean {
  return typeof color === "string" && color.trim().toLowerCase() === "rainbow";
}

/**
 * Converts a hue (0-360) into a fully saturated hex color, used to drive the
 * animated `"rainbow"` menu accent.
 */
export function getRainbowColor(hue: number): string {
  const saturation = 1;
  const lightness = 0.5;
  const chroma = (1 - Math.abs(2 * lightness - 1)) * saturation;
  const section = (((hue % 360) + 360) % 360) / 60;
  const secondary = chroma * (1 - Math.abs((section % 2) - 1));
  const match = lightness - chroma / 2;
  const [red, green, blue] =
    section < 1
      ? [chroma, secondary, 0]
      : section < 2
        ? [secondary, chroma, 0]
        : section < 3
          ? [0, chroma, secondary]
          : section < 4
            ? [0, secondary, chroma]
            : section < 5
              ? [secondary, 0, chroma]
              : [chroma, 0, secondary];

  return `#${[red, green, blue]
    .map((value) =>
      Math.round((value + match) * 255)
        .toString(16)
        .padStart(2, "0"),
    )
    .join("")}`;
}