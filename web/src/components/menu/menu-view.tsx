import { Menu } from "./exports";

export type MenuItem = {
  type: "button" | "separator" | "checkbox" | "label";
  label?: string;
  anchor?: string;
  description?: string;
  isChecked?: boolean;
};

export type MenuData = {
  menuId?: string;
  title: string;
  subtitle: string;
  items: MenuItem[];
};

type MenuViewProps = {
  menu: MenuData;
};

export const MenuView = ({ menu }: MenuViewProps) => {
  return (
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
            return (
              <Menu.Item.Button
                key={index}
                label={item.label ?? ""}
              />
            );
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
            return (
              <Menu.Item.Label
                key={index}
                label={item.label ?? ""}
              />
            );
          }

          return null;
        })}
      </Menu.Content>

      <Menu.Footer description="Footer" />
    </div>
  );
};