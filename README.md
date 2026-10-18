# rlz-menu

> A modern, themeable menu system for FiveM — clean NUI, keyboard-driven, zero framework dependencies.

`rlz-menu` is a drop-in client resource for FiveM roleplay servers. It ships a
React + Tailwind UI, an expressive Lua API, per-menu theming (solid, gradient or
animated rainbow), custom banner images, and rich interactive item types.

- **Repo**: https://github.com/Rlzee/rlz-menu-fivem
- **Current version**: see `fxmanifest.lua` (`version '…'`)
- **Release notes**: [`RELEASE.md`](RELEASE.md)
- **License**: [`LICENSE.md`](LICENSE.md)

---

## Table of contents

- [Features](#features)
- [Installation](#installation)
- [Quick start](#quick-start)
- [API overview](#api-overview)
- [Item types](#item-types)
- [Theming](#theming)
- [Positioning & persistence](#positioning--persistence)
- [Development](#development)
- [Project layout](#project-layout)
- [Tech stack](#tech-stack)

---

## Features

- **Interactive items**: button, checkbox, switch, radio group, list, slider,
  level bar, label, separator.
- **Per-menu theming**: solid color, multi-stop gradient, animated `"rainbow"`
  cycle, or custom banner image. Submenus opt in or out of inheriting parent
  color / banner with `inheritColor` / `inheritBanner`.
- **Keyboard navigation** (`↑ ↓ ← → Enter Backspace`), drag-and-drop positioning,
  or an in-menu keyboard edit mode with `apply to all` for whole-tree moves.
- **Native GTA V frontend sounds** for navigate / select / back.
- **Per-player position persistence** through KVP — no config file needed.
- **Search bar** via `rlzMenu.OpenSearchBar(label, onSubmit, onCancel)`.
- **Dynamic items** — pass a builder function to `rlzMenu.SetItems` and it is
  re-run every time the menu opens (perfect for live money, inventory, jobs…).
- **Live mutation** — `rlzMenu.SetItemProperty(itemId, "prop", value)` for
  updating labels, anchors, values, disabled state, etc. without a rebuild.
- **Cross-resource friendly** — the whole API is exported via
  `exports("getObject", function() return rlzMenu end)`.
- **Well-typed Lua** — full LuaLS annotations (`---@param`, `---@field`, …) on
  every public function, so IntelliSense guides you from the first line.

---

## Installation

### For server owners

1. Drop the resource folder into your server's `resources/` directory (e.g.
   `resources/rlz-menu`).
2. Add `ensure rlz-menu` to your `server.cfg`.
3. Restart the server.

The React bundle is already built and shipped inside `web/dist/`, so **no Node
tooling is required at install time**.

### For developers using it in another resource

Add to your own `fxmanifest.lua`:

```lua
shared_script '@rlz-menu/common.lua'    -- provides the global `rlzMenu`
-- or, if you prefer not to depend on the global:
--   local rlzMenu = exports["rlz-menu"]:getObject()
```

---

## Quick start

```lua
-- Create a themed root menu with a key binding
local adminMenu = rlzMenu.Create({
    title    = "Admin",
    subtitle = "Staff only",
    command  = "admin",
    key      = "F6",
    color    = "red",
    controls = true,
})

-- Populate it lazily so items reflect live state
rlzMenu.SetItems(adminMenu, function()
    rlzMenu.Checkbox({
        label     = "God Mode",
        isChecked = GetPlayerInvincible(PlayerId()),
        onChange  = function(v) SetPlayerInvincible(PlayerId(), v) end,
    })

    rlzMenu.Slider({
        label = "Volume",
        min   = 0, max = 100, value = 60, step = 5,
        onChange = function(v) SetVolume(v) end,
    })

    rlzMenu.Button({
        label       = "Open player list",
        description = "Full admin panel",
        submenu     = playersMenu,   -- jump to another menu on Enter
    })
end)
```

An exhaustive, in-game playground for every option is bundled in [`test.lua`](test.lua).

---

## API overview

Everything lives under the `rlzMenu` table.

### Menu lifecycle

| Function | Purpose |
|---|---|
| `rlzMenu.Create(options)` | Root menu. Returns `menuId`. |
| `rlzMenu.CreateSubMenu(parentId, options)` | Submenu linked to `parentId`. |
| `rlzMenu.SetItems(menuId, builder)` | Assign the lazy item-builder function. |
| `rlzMenu.SetVisible(menuId, state)` | Show / hide a menu. |
| `rlzMenu.GoTo(menuId)` / `rlzMenu.GoBack()` | Programmatic navigation. |
| `rlzMenu.Refresh(menuId)` | Push current state to NUI. |
| `rlzMenu.DestroySubMenu(menuId, destroyChildren?)` | Remove a submenu from memory. |
| `rlzMenu.Exists(id)` / `rlzMenu.GetParent(id)` / `rlzMenu.IsVisible(id)` | Introspection. |

### Menu properties

`GetMenuProperty(id, key)` / `SetMenuProperty(id, key, value, applyToSubmenus?)`
support: `title`, `subtitle`, `position`, `color`, `banner`, `enabled`,
`controls`. Position also accepts a `{ x, y }` table for free placement.

### Item properties

`GetItemProperty(itemId, key)` / `SetItemProperty(itemId, key, value)` — keys
depend on the item type (see `menu/items.lua` `ITEM_PROPERTY_TYPES`).

### Position helpers

| Function | Purpose |
|---|---|
| `rlzMenu.EditPosition(menuId, applyToAll?)` | Keyboard edit mode (arrows / Enter / Backspace). |
| `rlzMenu.ResetPosition(menuId, applyToAll?)` | Restore default alignment. |
| `rlzMenu.GetPosition(menuId)` → `alignment, x, y` | Read current placement. |

### Extras

`rlzMenu.OpenSearchBar(label, onSubmit, onCancel)` — focusable text prompt.

---

## Item types

| Constructor | Interactive | Anchor | Value | Extra |
|---|---|---|---|---|
| `rlzMenu.Button({ label, anchor?, submenu?, onSelect?, … })` | ✓ | text / spinner | — | optional submenu target |
| `rlzMenu.Checkbox({ label, isChecked, onChange?, … })` | ✓ | — | boolean | — |
| `rlzMenu.Switch({ label, isChecked, onChange?, … })` | ✓ | — | boolean | iOS-style |
| `rlzMenu.RadioGroup({ label?, options, index?, onChange?, … })` | ✓ | — | 1-of-N | group state lives in Lua |
| `rlzMenu.List({ label, values, index?, onChange?, … })` | ✓ | — | 1-of-N | cycle with `← →` |
| `rlzMenu.Slider({ label, min?, max?, value?, step?, onChange?, … })` | ✓ | — | number | `onChange(v, percent)` |
| `rlzMenu.Level({ label, max?, value?, onChange?, … })` | ✓ | — | 0-N | pips UI |
| `rlzMenu.Label(text)` | — | — | — | section header |
| `rlzMenu.Separator({ visible? })` | — | — | — | horizontal rule |

Every interactive item supports `disabled = true` (renders a lock icon), plus
optional `onHover` and `onLeave` callbacks for buttons / checkboxes / switches /
lists / sliders / levels.

---

## Theming

### Accent color

```lua
color = "red"                              -- named preset
color = "#8b5cf6"                          -- hex
color = "rgb(14 165 233)"                  -- rgb()
color = { "#06b6d4", "#8b5cf6" }           -- gradient (applies to every accent surface)
color = "rainbow"                          -- animated hue cycle (6 s full sweep)
```

The accent recolors the **banner**, the **selected row**, checked **controls**,
the **slider fill** and the **level dots**. Button anchors and list values stay
neutral gray (`--color-value`) so they remain readable on every accent.

### Custom banner image

```lua
banner = "nui://rlz-menu/web/dist/admin.png"   -- shipped asset
banner = "https://example.com/banner.png"      -- remote (needs online players)
banner = "data:image/svg+xml,…"                -- inline data URI
```

Setting `banner = ""` clears it and falls back to the colored accent banner.

### Inheritance

Submenus accept two boolean flags:

- `inheritColor` — follow the parent's `color` when it changes.
- `inheritBanner` — follow the parent's `banner`.

Both default to `true` when the submenu does **not** declare its own value,
and `false` otherwise — so a submenu with `color = "orange"` stays orange
even if the parent is recolored at runtime.

---

## Positioning & persistence

- Two presets: `position = "left"` or `"right"`.
- Free placement: `SetMenuProperty(id, "position", { x = 0.4, y = 0.35 })`
  using screen ratios (0–1).
- **Drag-and-drop** the header to move the menu; **double-click** the header to
  reset it.
- `rlzMenu.EditPosition(menuId, applyToAll?)` opens a keyboard edit mode with
  the arrows. `applyToAll = true` saves the position across the whole menu tree.
- Positions are stored **per-player** via KVP, keyed on the menu ID. Nothing
  to configure.

---

## Development

The NUI is a Vite + React app. If you only want to use the resource, you don't
need any of this — `web/dist/` is committed and served as-is.

### Prerequisites

- Node 20+
- pnpm

### Commands

```bash
cd web
pnpm install         # once
pnpm dev             # Vite dev server with HMR (open http://localhost:5173)
pnpm build           # tsc -b && vite build → regenerates web/dist
pnpm lint            # eslint
```

After `pnpm build`, restart the resource in FiveM (`restart rlz-menu`) to pick
up the new bundle.

### Recommended workflow

Run the Vite dev server in a browser for pure UI iteration — the frontend
stubs NUI fetches in `web/src/utils/fetchNui.ts` and `useNuiEvent.ts` so you
can preview without the game running. Once happy, `pnpm build` and reload the
resource.

---

## Project layout

```
rlz-menu/
├── fxmanifest.lua          # resource manifest (version, files, scripts)
├── common.lua              # rlzMenu global + exports("getObject")
├── test.lua                # in-game playground / reference
├── menu/
│   ├── main.lua            # Create / CreateSubMenu / SetVisible / property get-set
│   ├── items.lua           # ITEM_PROPERTY_TYPES + every item constructor
│   ├── functions.lua       # Refresh, EditPosition, GoTo, GoBack, GetPosition, …
│   └── callbacks.lua       # NUI callbacks (select, toggle, change, save-position, …)
├── utils/
│   ├── buildMenuData.lua   # NUI payload builder
│   ├── prepareNuiItems.lua # strips functions from items before shipping
│   ├── menuPosition.lua    # KVP save / load / delete
│   ├── registerMenuKey.lua # RegisterCommand + RegisterKeyMapping
│   ├── playSound.lua       # native GTA V frontend sounds
│   ├── generateId.lua      # stable menu/item ids
│   └── triggerNuiEvent.lua # SendNUIMessage wrapper
└── web/                    # React + Vite + Tailwind v4 NUI
    ├── src/
    │   ├── app.tsx
    │   ├── components/     # menu/, ui/, item.tsx, search-bar.tsx, …
    │   ├── hooks/          # useMenuNavigation, useMenuSelection, useMenuColorVars, …
    │   ├── utils/          # color, cn, fetchNui, useNuiEvent, debugData, misc
    │   └── index.css       # @theme design tokens (single source of truth for styling)
    └── dist/               # committed build output — served as the NUI
```

---

## Tech stack

- **Client Lua** — FiveM native (no wrapper framework)
- **NUI** — React 19 · TypeScript · Vite 8 · Tailwind CSS v4 · Radix UI
  primitives · `tw-animate-css`
- **Design tokens** — centralized in the `@theme` block of
  [`web/src/index.css`](web/src/index.css).

---

## Related docs

- [`RELEASE.md`](RELEASE.md) — feature-focused description for the download page.
- [`LICENSE.md`](LICENSE.md) — license terms.
- [`test.lua`](test.lua) — live playground of every option.
