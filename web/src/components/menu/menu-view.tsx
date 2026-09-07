import { useMemo, useState } from "react";
import { useMenuNavigation } from "../../hooks/useMenuNavigation";
import { useMenuSelection } from "../../hooks/useMenuSelection";

import { isSelectableItem } from "./items/isSelectableItem";
import { Menu } from "./exports";
import type { MenuItem } from "./items/type";

export type MenuData = {
  menuId?: string;
  title: string;
  subtitle: string;
  position: "left" | "right";
  items: MenuItem[];
};

type MenuViewProps = {
  menu: MenuData;
};

export const MenuView = ({ menu }: MenuViewProps) => {
  const [selectedIndex, setSelectedIndex] = useState(0);

  const selectableIndexes = useMemo(() => {
    return menu.items.reduce<number[]>((indexes, item, index) => {
      if (isSelectableItem(item)) {
        indexes.push(index);
      }

      return indexes;
    }, []);
  }, [menu.items]);

  useMenuSelection({
    menuId: menu.menuId,
    selectableIndexes,
    selectedIndex,
    setSelectedIndex,
  });

  useMenuNavigation({
    items: menu.items,
    selectedIndex,
    setSelectedIndex,
    selectableIndexes,
  });

  const selectedItem = menu.items[selectedIndex];

  const footerDescription =
    selectedItem?.type === "button" ||
    selectedItem?.type === "checkbox" ||
    selectedItem?.type === "list"
      ? (selectedItem.description ?? "")
      : "";

  const currentPosition = selectableIndexes.indexOf(selectedIndex);

  return (
    <div id={menu.menuId} className="w-[20vw]">
      <Menu.Header
        title={menu.title}
        subtitle={menu.subtitle}
        current={currentPosition >= 0 ? currentPosition + 1 : 0}
        total={selectableIndexes.length}
      />

      <Menu.Content>
        {menu.items.map((item, index) => {
          const isSelected = selectedIndex === index;

          if (item.type === "button") {
            return (
              <Menu.Item.Button
                key={item.id}
                label={item.label}
                anchor={item.anchor}
                selected={isSelected}
                submenu={item.submenu}
                disabled={item.disabled}
              />
            );
          }

          if (item.type === "checkbox") {
            return (
              <Menu.Item.Checkbox
                key={item.id}
                label={item.label}
                isChecked={item.isChecked}
                selected={isSelected}
                disabled={item.disabled}
              />
            );
          }

          if (item.type === "label") {
            return <Menu.Item.Label key={item.id} label={item.label} />;
          }

          if (item.type === "separator") {
            return <Menu.Item.Separator key={item.id} />;
          }

          if (item.type === "list") {
            return (
              <Menu.Item.List
                key={item.id}
                label={item.label}
                values={item.values}
                index={item.index}
                value={item.value}
                selected={isSelected}
                disabled={item.disabled}
              />
            );
          }

          return null;
        })}
      </Menu.Content>

      {footerDescription && <Menu.Footer description={footerDescription} />}
    </div>
  );
};
