import { useEffect } from "react";
import { fetchNui } from "../utils/fetchNui";
import { NUI_EVENT } from "../utils/nuiEvents";
import { isSelectableItem } from "../components/menu/items/config";
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
        fetchNui(NUI_EVENT.leaveItem, {
          itemId: previousItem.id,
        });
      }

      setSelectedIndex(nextIndex);

      if (nextItem && isSelectableItem(nextItem)) {
        fetchNui(NUI_EVENT.hoverItem, {
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

          fetchNui(NUI_EVENT.navigate);

          break;
        }

        case "ArrowUp": {
          event.preventDefault();

          const previousPosition =
            currentPosition <= 0
              ? selectableIndexes.length - 1
              : currentPosition - 1;

          changeSelection(selectableIndexes[previousPosition]);

          fetchNui(NUI_EVENT.navigate);

          break;
        }

        case "ArrowLeft":
        case "ArrowRight": {
          event.preventDefault();

          const direction =
            event.key === "ArrowLeft" ? "left" : "right";

          const selectedItem = items[selectedIndex];

          if (selectedItem?.type === "list") {
            fetchNui(NUI_EVENT.changeList, {
              itemId: selectedItem.id,
              direction,
            });
          }

          if (selectedItem?.type === "slider") {
            fetchNui(NUI_EVENT.changeSlider, {
              itemId: selectedItem.id,
              direction,
            });
          }

          if (selectedItem?.type === "level") {
            fetchNui(NUI_EVENT.changeLevel, {
              itemId: selectedItem.id,
              direction,
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
            fetchNui(NUI_EVENT.selectButton, {
              itemId: selectedItem.id,
            });
          }

          if (
            selectedItem.type === "checkbox" ||
            selectedItem.type === "switch"
          ) {
            fetchNui(NUI_EVENT.toggleCheckbox, {
              itemId: selectedItem.id,
            });
          }

          if (selectedItem.type === "radio") {
            fetchNui(NUI_EVENT.selectRadio, {
              itemId: selectedItem.id,
            });
          }

          break;
        }

        case "Backspace": {
          event.preventDefault();

          fetchNui(NUI_EVENT.goBack);

          break;
        }
      }
    };

    window.addEventListener("keydown", handleKeyDown);

    return () => {
      window.removeEventListener("keydown", handleKeyDown);
    };
  }, [items, selectedIndex, selectableIndexes, setSelectedIndex]);
}
