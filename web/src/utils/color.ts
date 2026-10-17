export type Color = string | string[];

function isWhiteColorValue(color: string): boolean {
  const normalizedColor = color.trim().toLowerCase();
  return normalizedColor === "white"
    || normalizedColor === "#fff"
    || normalizedColor === "#ffffff"
    || normalizedColor === "rgb(255, 255, 255)";
}

export function isWhiteColor(color?: Color): boolean {
  if (!color) return false;

  const colors = Array.isArray(color) ? color : [color];
  return colors.length > 0 && colors.every(isWhiteColorValue);
}

export function getRainbowColor(hue: number): string {
  const saturation = 1;
  const lightness = 0.5;
  const chroma = (1 - Math.abs(2 * lightness - 1)) * saturation;
  const section = hue / 60;
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
    .map((value) => Math.round((value + match) * 255).toString(16).padStart(2, "0"))
    .join("")}`;
}

export function linearGradient(colors: string[]): string {
  return `linear-gradient(to right, ${colors.join(", ")})`;
}