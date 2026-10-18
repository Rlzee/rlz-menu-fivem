import { useLayoutEffect, type RefObject } from "react";
import {
  ACCENT_COLOR_VARS,
  buildMenuColorVars,
  getRainbowColor,
  isRainbowColor,
} from "../utils/color";

/** Duration of a full hue cycle, in milliseconds. */
const RAINBOW_CYCLE_MS = 6000;

/**
 * Applies the accent CSS variables of a menu directly on its root element.
 *
 * Static colors are written once. The reserved `"rainbow"` color animates the
 * hue over time with `requestAnimationFrame`, mutating the element's inline
 * style instead of React state so the whole menu is not re-rendered per frame.
 * When a color is cleared the managed variables are removed to fall back to the
 * default slate theme.
 */
export function useMenuColorVars(
  ref: RefObject<HTMLElement | null>,
  color?: string,
) {
  useLayoutEffect(() => {
    const element = ref.current;

    if (!element) {
      return;
    }

    const applyVars = (vars?: Record<string, string>) => {
      for (const key of ACCENT_COLOR_VARS) {
        const value = vars?.[key];

        if (value) {
          element.style.setProperty(key, value);
        } else {
          element.style.removeProperty(key);
        }
      }
    };

    if (!isRainbowColor(color)) {
      applyVars(buildMenuColorVars(color));
      return;
    }

    let frame = 0;
    const start = performance.now();

    const tick = (now: number) => {
      const hue = (((now - start) / RAINBOW_CYCLE_MS) * 360) % 360;

      applyVars(buildMenuColorVars(getRainbowColor(hue)));
      frame = requestAnimationFrame(tick);
    };

    frame = requestAnimationFrame(tick);

    return () => cancelAnimationFrame(frame);
  }, [ref, color]);
}
