import { useState } from "react";

import { useNuiEvent } from "../../hooks/useNuiEvent";

import { MenuView, type MenuData } from "./menu-view";
import { cn } from "cn";
import { useVisibility } from "../visibility";

export function Menu() {
  const { menuVisible, setMenuVisible } = useVisibility();
  const [menu, setMenu] = useState<MenuData>({
    title: "",
    subtitle: "",
    color: "default",
    position: "left",
    items: [],
  });

  useNuiEvent<MenuData>("rlz_menu:setData", setMenu);
  useNuiEvent<{ state: boolean }>("rlz_menu:setVisible", ({ state }) => {
    setMenuVisible(state);
  });
  if (!menuVisible) {
    return null;
  }

  return (
    <div
      className={cn(
        "flex flex-col p-4 h-full w-full",
        menu.position === "right" ? "items-end" : "items-start",
      )}
    >
      <MenuView
        key={`${menu.menuId ?? ""}:${menu.selectedItemId ?? ""}`}
        menu={menu}
      />
    </div>
  );
}
