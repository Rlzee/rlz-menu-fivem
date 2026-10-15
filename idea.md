# Ideas

Feature ideas and notes for rlzMenu, so nothing gets forgotten.
Each idea has its own section with the current thinking and open questions.

## Multi-select item

A new item type that enables **selecting several other items of the menu itself**, instead of
acting on one item at a time (currently each Enter immediately triggers the item's action).

- New item type placed in the menu like a button, e.g. `rlzMenu.MultiSelect({ ... })`
- While the mode is active, the player navigates the menu and **checks/unchecks other items**
  (buttons) without triggering them, then confirms to apply an action to **all checked items
  at once** — e.g. delete several entries, toggle several options in one pass
- Suggested API:
  - `targets` — which items can be checked (item ids, a label/section, or "all buttons")
  - `onChange(checkedIds)` — called each time the selection changes
  - `onConfirm(checkedIds)` — called when the player validates the selection
  - Confirming: pressing Enter on the multi-select item again, or a separate
    `rlzMenu.ConfirmSelection({ ... })` item placed after (to decide)
- Open questions:
  - How does the player check an item — a dedicated key while the mode is active, or does
    Enter toggle instead of trigger while selecting?
  - Visual state on checked items: checkmark, checkbox slot, highlight?
  - Should non-target items (checkbox, list) stay usable while the mode is active?
  - Does the selection span labels/sections and nested submenus?

## Global config — menu animations

A **global framework config** where the animations are configured **once** and applied to
**every menu created** — not an option repeated per menu.

- A shared config file at the resource root, e.g.:

```lua
Config = {
    animation = {
        open = "fade",      -- or "slide-up", "slide-down", "scale", ...
        close = "fade",
        duration = 150,     -- ms
    },
}
```

- Every `rlzMenu.Create` / `rlzMenu.CreateSubMenu` automatically uses this config,
  so all menus open/close the same way (a per-menu override could come later if ever needed)
- Web side: `tw-animate-css` is already a dependency, CSS transitions/keyframes should
  cover most cases
- Keep in mind:
  - The close animation must finish before (or while) the NUI focus is released
  - Sounds (`select` / `back`) should stay in sync with the animation
  - A "none" value to disable animations entirely

## Style presets

Why not also a **style system with several ready-made styles**, selectable from the same
global config — so the whole menu look can be changed without having to edit the Tailwind
classes or the CSS by hand.

- A `style = "..."` option in the global config, with several built-in presets
  (e.g. `default`, `minimal`, `rounded`, `classic`, ...)
- Each preset maps to a set of CSS variables / theme values (`--menu-gap`, `--radius-menu`,
  `bg-background-menu`, colors, borders, fonts...), switched via a `data-style` attribute
  or a class on the menu root
- Resource creators pick a style from the config instead of modifying the web source
- Open questions:
  - Which presets to ship, and how users can add their own without touching the core?
  - Strictly global, or allow per-menu overrides?
  - Keep the per-menu `color` / `hoverColor` options working within any style?

## Custom banner image

Allow the menu header to use a **custom banner image** instead of the colored banner.

- New option, e.g. `banner = "banner.png"` or `banner = "https://.../banner.png"`
- When a banner image is set, the **title becomes optional** — the image may already contain
  the menu title, so forcing text on top of it would look wrong
- Behavior:
  - `banner` + `title` → image only, or image with title overlay? (to decide)
  - `banner` without `title` → image only
  - no `banner` → current colored banner with title text (unchanged)
- Keep in mind:
  - Local images must be shipped in `web/dist` (or listed in the fxmanifest `files`)
  - Remote URLs work in NUI but require the player to be online
  - Sizing: fixed banner height (like the current `h-16`), `object-fit: cover` to avoid distortion
  - The subtitle row below the banner stays unchanged
