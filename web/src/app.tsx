import { useState } from "react";

import { useVisibility } from "./components/visibility";
import { useMenuDrag } from "./hooks/useMenuDrag";
import { useNuiEvent } from "./hooks/useNuiEvent";
import { MenuView, type MenuData } from "./components/menu/menu-view";
import { PositionControls } from "./components/position-controls";
import { SearchBar } from "./components/search-bar";

import { cn } from "cn";

const App = () => {
  const { visible } = useVisibility();
  const [searchLabel, setSearchLabel] = useState<string | null>(null);

  const [menu, setMenu] = useState<MenuData>({
    title: "",
    subtitle: "",
    color: "default",
    position: "left",
    items: [],
  });

  useNuiEvent<MenuData>("rlz_menu:setData", setMenu);
  useNuiEvent<{ label: string }>("rlz_menu:openSearch", ({ label }) => {
    setSearchLabel(label);
  });
  useNuiEvent("rlz_menu:closeSearch", () => setSearchLabel(null));

  const {
    containerRef,
    containerStyle,
    isDragging,
    isMoveMode,
    startMoveMode,
    onHeaderPointerDown,
    onHeaderDoubleClick,
  } = useMenuDrag({
    menuId: menu.menuId,
    savedX: menu.x,
    savedY: menu.y,
    active: visible,
  });

  useNuiEvent<{ applyToAll?: boolean }>(
    "rlz_menu:editPosition",
    ({ applyToAll }) => startMoveMode(applyToAll === true),
  );

  if (!visible) {
    return null;
  }

  return (
    <div
      className={cn(
        "flex min-h-screen flex-col p-4",
        menu.position === "right" ? "items-end" : "items-start",
      )}
    >
      <div ref={containerRef} style={containerStyle}>
        <MenuView
          key={`${menu.menuId ?? ""}:${menu.selectedItemId ?? ""}`}
          menu={menu}
          dragging={isDragging || isMoveMode}
          onHeaderPointerDown={onHeaderPointerDown}
          onHeaderDoubleClick={onHeaderDoubleClick}
        />
        {isMoveMode && <PositionControls />}
      </div>
      {searchLabel && <SearchBar label={searchLabel} />}
    </div>
  );
};

export default App;
