import { useEffect, useMemo, useState } from "react";

import { Menu } from "./exports";
import type { MenuItem } from "./items/type";

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
  const [selectedIndex, setSelectedIndex] = useState(0);

  /**
   * Only buttons and checkboxes are selectable.
   * Labels and separators are ignored.
   */
  const selectableIndexes = useMemo(() => {
    return menu.items.reduce<number[]>((indexes, item, index) => {
      if (item.type === "button" || item.type === "checkbox") {
        indexes.push(index);
      }

      return indexes;
    }, []);
  }, [menu.items]);

  /**
   * Resets the selection when the menu changes.
   */
  useEffect(() => {
    if (selectableIndexes.length > 0) {
      setSelectedIndex(selectableIndexes[0]);
    } else {
      setSelectedIndex(0);
    }
  }, [menu.menuId, menu.title, menu.items, selectableIndexes]);

  /**
   * Checks that the selected item is still selectable.
   */
  useEffect(() => {
    if (selectableIndexes.length === 0) {
      setSelectedIndex(0);
      return;
    }

    if (!selectableIndexes.includes(selectedIndex)) {
      setSelectedIndex(selectableIndexes[0]);
    }
  }, [selectableIndexes, selectedIndex]);

  /**
   * Keyboard navigation.
   */
  useEffect(() => {
    const handleKeyDown = (event: KeyboardEvent) => {
      if (selectableIndexes.length === 0) {
        return;
      }

      const currentPosition = selectableIndexes.indexOf(selectedIndex);

      if (event.key === "ArrowDown") {
        event.preventDefault();

        const nextPosition =
          currentPosition >= selectableIndexes.length - 1
            ? 0
            : currentPosition + 1;

        setSelectedIndex(selectableIndexes[nextPosition]);
      }

      if (event.key === "ArrowUp") {
        event.preventDefault();

        const previousPosition =
          currentPosition <= 0
            ? selectableIndexes.length - 1
            : currentPosition - 1;

        setSelectedIndex(selectableIndexes[previousPosition]);
      }
    };

    window.addEventListener("keydown", handleKeyDown);

    return () => {
      window.removeEventListener("keydown", handleKeyDown);
    };
  }, [selectedIndex, selectableIndexes]);

  /**
   * Retrieves the currently selected item.
   */
  const selectedItem = menu.items[selectedIndex];

  /**
   * The description displayed in the footer.
   */
  const footerDescription =
    selectedItem?.type === "button" || selectedItem?.type === "checkbox"
      ? (selectedItem.description ?? "")
      : "";

  /**
   * Position of the selected item in the selectable items.
   */
  const currentPosition = selectableIndexes.indexOf(selectedIndex);

  return (
    <div id="menu" className="w-[20vw]">
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
                key={index}
                label={item.label}
                anchor={item.anchor}
                selected={isSelected}
                onMouseEnter={() => {
                  setSelectedIndex(index);
                }}
              />
            );
          }

          if (item.type === "checkbox") {
            return (
              <Menu.Item.Checkbox
                key={index}
                label={item.label}
                isChecked={item.isChecked}
                selected={isSelected}
                onMouseEnter={() => {
                  setSelectedIndex(index);
                }}
              />
            );
          }

          if (item.type === "label") {
            return <Menu.Item.Label key={index} label={item.label} />;
          }

          if (item.type === "separator") {
            return <Menu.Item.Separator key={index} />;
          }

          return null;
        })}
      </Menu.Content>

      <Menu.Footer description={footerDescription} />
    </div>
  );
};
