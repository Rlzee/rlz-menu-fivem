import { createCn } from "cn/config";

/**
 * tailwind-merge-compatible class merger, extended to know this project's
 * custom @theme type tokens. Without this, tokens like `text-caption`/`text-body`
 * are treated as text colors and clash with `text-white` (one gets dropped).
 * Declaring them as font-size / font-weight keeps them out of that group.
 */
export const cn = createCn({
  extend: {
    classGroups: {
      "font-size": [{ text: ["title", "body", "caption", "micro", "nano"] }],
      "font-weight": [{ font: ["title", "body", "label"] }],
    },
  },
});
