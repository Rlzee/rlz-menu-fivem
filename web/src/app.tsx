import { useState } from "react";

import { useVisibility } from "./components/visibility-context";
import { useMenuDrag } from "./hooks/useMenuDrag";
import { useNuiEvent } from "./hooks/useNuiEvent";
import { MenuView, type MenuData } from "./components/menu/menu-view";
import { SearchBar } from "./components/search-bar";

import { NUI_EVENT } from "./utils/nuiEvents";
import { cn } from "./utils/cn";

const App = () => {
  const { visible } = useVisibility();
  const [searchLabel, setSearchLabel] = useState<string | null>(null);

  const [menu, setMenu] = useState<MenuData>({
    title: "",
    subtitle: "",
    position: "left",
    items: [],
  });

  useNuiEvent<MenuData>(NUI_EVENT.setData, setMenu);
  useNuiEvent<{ label: string }>(NUI_EVENT.openSearch, ({ label }) => {
    setSearchLabel(label);
  });
  useNuiEvent(NUI_EVENT.closeSearch, () => setSearchLabel(null));

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

  useNuiEvent<{ applyToAll?: boolean }>(NUI_EVENT.editPosition, ({ applyToAll }) =>
    startMoveMode(applyToAll === true),
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
      <div ref={containerRef} style={containerStyle} className="animate-menu-open relative">
        <MenuView
          key={`${menu.menuId ?? ""}:${menu.selectedItemId ?? ""}`}
          menu={menu}
          dragging={isDragging}
          moveMode={isMoveMode}
          onHeaderPointerDown={onHeaderPointerDown}
          onHeaderDoubleClick={onHeaderDoubleClick}
        />
      </div>
      {searchLabel && <SearchBar label={searchLabel} />}
    </div>
  );
};

export default App;
