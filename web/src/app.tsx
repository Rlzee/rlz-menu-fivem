import { useState } from "react";

import { useVisibility } from "./components/visibility";
import { useNuiEvent } from "./hooks/useNuiEvent";
import { Menu } from "./components/menu/exports";

type MenuItem = {
  type: "button" | "separator" | "checkbox" | "label";
  label?: string;
  anchor?: string;
  description?: string;
  isChecked?: boolean;
};

type MenuData = {
  title: string;
  subtitle: string;
  items: MenuItem[];
};

const App = () => {
  const { visible } = useVisibility();

  const [menu, setMenu] = useState<MenuData>({
    title: "",
    subtitle: "",
    items: [],
  });

  useNuiEvent<MenuData>("rlz_menu:setData", setMenu);

  if (!visible) return null;

  return (
    <div className="flex flex-col min-h-screen p-4">
      <div id="menu" className="w-[20vw]">
        <Menu.Header
          title={menu.title}
          subtitle={menu.subtitle}
          current={1}
          total={menu.items.length}
        />
        <Menu.Content>
          {menu.items.map((item, index) => {
            if (item.type === "button") {
              return <Menu.Item.Button key={index} label={item.label ?? ""} />;
            }

            if (item.type === "separator") {
              return <Menu.Item.Separator key={index} />;
            }

            if (item.type === "checkbox") {
              return (
                <Menu.Item.Checkbox
                  key={index}
                  label={item.label ?? ""}
                  isChecked={item.isChecked ?? false}
                />
              );
            }

            if (item.type === "label") {
              return <Menu.Item.Label key={index} label={item.label ?? ""} />;
            }

            return null;
          })}
        </Menu.Content>

        <Menu.Footer description="Footer" />
      </div>
    </div>
  );
};

export default App;
