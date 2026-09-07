import { useEffect, useMemo, useState } from "react";
import { fetchNui } from "../../utils/fetchNui";

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
  /**
   * Index of the currently selected item.
   * Selection is managed by React.
   */
  const [selectedIndex, setSelectedIndex] = useState(0);

  /**
   * Only buttons and checkboxes can be selected.
   */
  const selectableIndexes = useMemo(() => {
    return menu.items.reduce<number[]>((indexes, item, index) => {
      if (
        (item.type === "button" && !item.disabled) ||
        (item.type === "checkbox" && !item.disabled) ||
        (item.type === "list" && !item.disabled)
      ) {
        indexes.push(index);
      }

      return indexes;
    }, []);
  }, [menu.items]);

  /**
   * Initialize the selection when a new menu is opened.
   *
   * If the currently selected item still exists,
   * keep the current selection.
   */
  useEffect(() => {
    if (selectableIndexes.length === 0) {
      setSelectedIndex(0);
      return;
    }

    setSelectedIndex((currentIndex) => {
      if (selectableIndexes.includes(currentIndex)) {
        return currentIndex;
      }

      return selectableIndexes[0];
    });
  }, [menu.menuId, menu.title, menu.subtitle, selectableIndexes]);

  /**
   * Ensure that the selected item remains valid.
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

      switch (event.key) {
        case "ArrowDown": {
          event.preventDefault();

          const nextPosition =
            currentPosition >= selectableIndexes.length - 1
              ? 0
              : currentPosition + 1;

          setSelectedIndex(selectableIndexes[nextPosition]);
          fetchNui("rlz_menu:navigate");
          break;
        }

        case "ArrowUp": {
          event.preventDefault();

          const previousPosition =
            currentPosition <= 0
              ? selectableIndexes.length - 1
              : currentPosition - 1;

          setSelectedIndex(selectableIndexes[previousPosition]);
          fetchNui("rlz_menu:navigate");
          break;
        }

        case "ArrowLeft": {
          event.preventDefault();

          const selectedItem = menu.items[selectedIndex];

          if (selectedItem?.type === "list") {
            fetchNui("rlz_menu:changeList", {
              itemId: selectedItem.id,
              direction: "left",
            });
          }

          break;
        }

        case "ArrowRight": {
          event.preventDefault();

          const selectedItem = menu.items[selectedIndex];

          if (selectedItem?.type === "list") {
            fetchNui("rlz_menu:changeList", {
              itemId: selectedItem.id,
              direction: "right",
            });
          }

          break;
        }

        case "Enter": {
          event.preventDefault();

          const selectedItem = menu.items[selectedIndex];

          if (selectedItem?.type === "button") {
            fetchNui("rlz_menu:selectButton", {
              itemId: selectedItem.id,
            });
          }

          if (selectedItem?.type === "checkbox") {
            fetchNui("rlz_menu:toggleCheckbox", {
              itemId: selectedItem.id,
            });
          }

          if (selectedItem?.type === "list") {
            fetchNui("rlz_menu:selectList", {
              itemId: selectedItem.id,
            });
          }

          break;
        }

        case "Backspace": {
          event.preventDefault();

          fetchNui("rlz_menu:goBack");

          break;
        }
      }
    };

    window.addEventListener("keydown", handleKeyDown);

    return () => {
      window.removeEventListener("keydown", handleKeyDown);
    };
  }, [menu.items, selectedIndex, selectableIndexes]);

  /**
   * Currently selected item.
   */
  const selectedItem = menu.items[selectedIndex];

  /**
   * Description displayed only in the footer.
   */
  const footerDescription =
    selectedItem?.type === "button" ||
    selectedItem?.type === "checkbox" ||
    selectedItem?.type === "list"
      ? (selectedItem.description ?? "")
      : "";

  /**
   * Position of the selected item among the selectable items.
   */
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
