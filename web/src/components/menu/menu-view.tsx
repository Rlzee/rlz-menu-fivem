import { useEffect, useMemo, useRef, useState } from "react";
import { useMenuNavigation } from "../../hooks/useMenuNavigation";
import { useMenuSelection } from "../../hooks/useMenuSelection";
import { useRainbowColor } from "../../hooks/useRainbowColor";
import type { Color } from "../../utils/color";

import { isSelectableItem } from "./items/isSelectableItem";
import { Menu } from "./exports";
import type { MenuItem } from "./items/type";

export type MenuData = {
  menuId?: string;
  title: string;
  subtitle: string;
  color?: Color;
  hoverColor?: Color;
  position: "left" | "right";
  items: MenuItem[];
};

type MenuViewProps = {
  menu: MenuData;
};

export const MenuView = ({ menu }: MenuViewProps) => {
  const [selectedIndex, setSelectedIndex] = useState(0);
  const menuRef = useRef<HTMLDivElement>(null);

  const menuColor = useRainbowColor(menu.color);
  const hoverColor = useRainbowColor(menu.hoverColor);

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

  useEffect(() => {
    const selectedItem = menuRef.current?.querySelector<HTMLElement>(
      '[data-slot="menu-item"][data-selected="true"]',
    );

    selectedItem?.scrollIntoView({ block: "nearest" });
  }, [selectedIndex]);

  const selectedItem = menu.items[selectedIndex];

  const footerDescription =
    selectedItem?.type === "button" ||
    selectedItem?.type === "checkbox" ||
    selectedItem?.type === "list"
      ? (selectedItem.description ?? "")
      : "";

  const currentPosition = selectableIndexes.indexOf(selectedIndex);

  return (
    <div
      ref={menuRef}
      id={menu.menuId}
      className="w-(--menu-width) grid gap-(--menu-gap)"
    >
      <Menu.Header
        title={menu.title}
        subtitle={menu.subtitle}
        current={currentPosition >= 0 ? currentPosition + 1 : 0}
        total={selectableIndexes.length}
        color={menuColor}
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
                anchorColor={item.anchorColor}
                selected={isSelected}
                submenu={item.submenu}
                disabled={item.disabled}
                buttonColor={item.color}
                menuColor={menuColor}
                hoverColor={hoverColor}
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
                itemColor={item.color}
                menuColor={menuColor}
                hoverColor={hoverColor}
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
                itemColor={item.color}
                menuColor={menuColor}
                hoverColor={hoverColor}
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
