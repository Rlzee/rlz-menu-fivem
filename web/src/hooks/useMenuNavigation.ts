import { useEffect } from "react";
import { fetchNui } from "../utils/fetchNui";
import { isSelectableItem } from "../components/menu/items/isSelectableItem";
import type { MenuItem } from "../components/menu/items/type";

type UseMenuNavigationProps = {
  items: MenuItem[];
  selectedIndex: number;
  setSelectedIndex: React.Dispatch<React.SetStateAction<number>>;
  selectableIndexes: number[];
};

export function useMenuNavigation({
  items,
  selectedIndex,
  setSelectedIndex,
  selectableIndexes,
}: UseMenuNavigationProps) {
  useEffect(() => {
    const changeSelection = (nextIndex: number) => {
      if (nextIndex === selectedIndex) {
        return;
      }

      const previousItem = items[selectedIndex];
      const nextItem = items[nextIndex];

      if (previousItem && isSelectableItem(previousItem)) {
        fetchNui("rlz_menu:leaveItem", {
          itemId: previousItem.id,
        });
      }

      setSelectedIndex(nextIndex);

      if (nextItem && isSelectableItem(nextItem)) {
        fetchNui("rlz_menu:hoverItem", {
          itemId: nextItem.id,
        });
      }
    };

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

          changeSelection(selectableIndexes[nextPosition]);

          fetchNui("rlz_menu:navigate");

          break;
        }

        case "ArrowUp": {
          event.preventDefault();

          const previousPosition =
            currentPosition <= 0
              ? selectableIndexes.length - 1
              : currentPosition - 1;

          changeSelection(selectableIndexes[previousPosition]);

          fetchNui("rlz_menu:navigate");

          break;
        }

        case "ArrowLeft":
        case "ArrowRight": {
          event.preventDefault();

          const selectedItem = items[selectedIndex];

          if (selectedItem?.type === "list") {
            fetchNui("rlz_menu:changeList", {
              itemId: selectedItem.id,
              direction:
                event.key === "ArrowLeft"
                  ? "left"
                  : "right",
            });
          }

          break;
        }

        case "Enter": {
          event.preventDefault();

          const selectedItem = items[selectedIndex];

          if (!selectedItem) {
            break;
          }

          if (selectedItem.type === "button") {
            fetchNui("rlz_menu:selectButton", {
              itemId: selectedItem.id,
            });
          }

          if (selectedItem.type === "checkbox") {
            fetchNui("rlz_menu:toggleCheckbox", {
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
  }, [
    items,
    selectedIndex,
    selectableIndexes,
    setSelectedIndex,
  ]);
}