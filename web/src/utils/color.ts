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