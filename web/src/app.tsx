import { useState } from "react";

import { useVisibility } from "./components/visibility";
import { useNuiEvent } from "./hooks/useNuiEvent";
import { MenuView, type MenuData } from "./components/menu/menu-view";
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
      {searchLabel && <SearchBar label={searchLabel} />}
    </div>
  );
};

export default App;
