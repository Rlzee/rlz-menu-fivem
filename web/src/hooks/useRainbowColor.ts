import { useEffect, useState } from "react";

import { getRainbowColor } from "../utils/color";

export function useRainbowColor(color?: string, fallback?: string) {
  const [rainbowHue, setRainbowHue] = useState(0);

  useEffect(() => {
    if (color !== "rainbow") return;

    const interval = window.setInterval(() => {
      setRainbowHue((hue) => (hue + 3) % 360);
    }, 30);

    return () => window.clearInterval(interval);
  }, [color]);

  return color === "rainbow" ? getRainbowColor(rainbowHue) : color || fallback;
}
