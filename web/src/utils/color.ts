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

/**
 * Builds the set of accent CSS variables that recolor a whole menu from a
 * single base color, matching the token names declared in the `@theme` block.
 * Returns undefined when no/invalid color is given so the default slate theme
 * is kept.
 */
export function buildMenuColorVars(
  color?: string,
): Record<string, string> | undefined {
  if (!color) {
    return undefined;
  }

  const rgb = parseColor(color);

  if (!rgb) {
    return undefined;
  }

  const { r, g, b } = rgb;
  const deep = mix(rgb, 0, 0.35);
  const anchor = mix(rgb, 255, 0.35);

  return {
    "--color-accent": `rgb(${r} ${g} ${b})`,
    "--color-accent-deep": `rgb(${deep.r} ${deep.g} ${deep.b})`,
    "--color-item-selected": `rgb(${r} ${g} ${b} / 22%)`,
    "--color-control-selected": `rgb(${r} ${g} ${b} / 30%)`,
    "--color-anchor": `rgb(${anchor.r} ${anchor.g} ${anchor.b})`,
  };
}

/** Accent CSS variables managed per menu, used to apply and clear them. */
export const ACCENT_COLOR_VARS = [
  "--color-accent",
  "--color-accent-deep",
  "--color-item-selected",
  "--color-control-selected",
  "--color-anchor",
] as const;

/** Whether the reserved `"rainbow"` color was requested for a menu. */
export function isRainbowColor(color?: string): boolean {
  return color?.trim().toLowerCase() === "rainbow";
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