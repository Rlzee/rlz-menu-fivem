export type Color = string | string[];

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

export function withOpacity(color: string, opacity: number): string {
  const hex = color.replace("#", "");
  const normalizedHex = hex.length === 3
    ? hex.split("").map((value) => value + value).join("")
    : hex;

  if (!/^[0-9a-fA-F]{6}$/.test(normalizedHex)) {
    return color;
  }

  const red = Number.parseInt(normalizedHex.slice(0, 2), 16);
  const green = Number.parseInt(normalizedHex.slice(2, 4), 16);
  const blue = Number.parseInt(normalizedHex.slice(4, 6), 16);

  return `rgba(${red}, ${green}, ${blue}, ${opacity})`;
}

export function linearGradient(colors: string[], opacity?: number): string {
  const colorStops = opacity === undefined
    ? colors
    : colors.map((color) => withOpacity(color, opacity));

  return `linear-gradient(to right, ${colorStops.join(", ")})`;
}

export function toColorValue(color: Color, opacity: number): string {
  return Array.isArray(color)
    ? linearGradient(color, opacity)
    : withOpacity(color, opacity);
}