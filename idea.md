# Ideas

Feature ideas and notes for rlzMenu, so nothing gets forgotten.
Each idea has its own section with the current thinking and open questions.

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

### ✅ Implemented

- `options.banner` on `rlzMenu.Create` / `CreateSubMenu`, also settable via `SetMenuProperty(menuId, "banner", ...)`
- `banner` is registered in `MENU_PROPERTY_TYPES` and shipped in the NUI payload (`utils/buildMenuData.lua`)
- Submenus now accept `options.inheritBanner` (mirrors `inheritColor`):
  - `inheritBanner = true` → submenu keeps following the parent banner when it
    changes later (recursively, via `setMenuProperty` propagation)
  - `inheritBanner = false` → submenu keeps its own banner and ignores the parent
  - Default: `inheritBanner = (options.banner == nil)` — inherit the parent's banner
    unless an own `banner` is explicitly given
- `SetMenuProperty(menuId, "banner", ...)` propagates recursively to descendant
  submenus whose `inheritBanner` is true (same rule as `color`)
- Web (`web/src/components/menu/header.tsx`) uses the image as `background-image` with
  `bg-cover bg-center bg-no-repeat` inside the existing `h-16` banner slot
- When a banner is set AND `title` is non-empty, the title is overlaid on the image with a
  subtle drop-shadow for readability; if `title` is empty, the image is shown alone
- Setting `banner` to `""` (empty string) clears it and falls back to the colored banner
  (`bg-menu-banner`) — unchanged legacy behavior
- Local files: drop them into `web/dist/**` (already listed in fxmanifest `files`), then reference
  by relative path (e.g. `banner = "nui://rlz-menu/web/dist/admin.png"` or simply
  `"admin.png"` if the file sits next to `index.html`).
- Live demo in `test.lua` → Options → **Banner image** (Custom banner / No banner), using a
  data-URI SVG so no external asset is required.
