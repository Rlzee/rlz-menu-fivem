import { useState } from "react";

import { useVisibility } from "./components/visibility";
import { useNuiEvent } from "./hooks/useNuiEvent";
import { MenuView, type MenuData } from "./components/menu/menu-view";

const App = () => {
  const { visible } = useVisibility();

  const [menu, setMenu] = useState<MenuData>({
    title: "",
    subtitle: "",
    items: [],
  });

  useNuiEvent<MenuData>("rlz_menu:setData", setMenu);

  if (!visible) {
    return null;
  }

  return (
    <div className="flex min-h-screen flex-col items-start p-4">
      <MenuView menu={menu} />
    </div>
  );
};

export default App;
