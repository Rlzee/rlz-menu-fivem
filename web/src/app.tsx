import { useState } from "react";

import { useVisibility } from "./components/visibility";
import { useNuiEvent } from "./hooks/useNuiEvent";
import { MenuView, type MenuData } from "./components/menu/menu-view";

import { cn } from "cn";

const App = () => {
  const { visible } = useVisibility();

  const [menu, setMenu] = useState<MenuData>({
    title: "",
    subtitle: "",
    position: "left",
    items: [],
  });

  useNuiEvent<MenuData>("rlz_menu:setData", setMenu);

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
      <MenuView menu={menu} />
    </div>
  );
};

export default App;
