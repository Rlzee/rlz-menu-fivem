import { useEffect, useState } from "react";

import { getRainbowColor } from "../utils/color";
import type { Color } from "../utils/color";

type RainbowColorResult<T> = T extends string[] ? Color : string | undefined;

export function useRainbowColor<T extends Color | undefined>(
  color?: T,
  fallback?: T,
): RainbowColorResult<T> {
  const [rainbowHue, setRainbowHue] = useState(0);

  useEffect(() => {
    if (color !== "rainbow") return;

    const interval = window.setInterval(() => {
      setRainbowHue((hue) => (hue + 3) % 360);
    }, 30);

    return () => window.clearInterval(interval);
  }, [color]);

  return (color === "rainbow" ? getRainbowColor(rainbowHue) : color || fallback) as RainbowColorResult<T>;
}
