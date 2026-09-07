import { useEffect } from "react";

type UseMenuSelectionProps = {
  menuId?: string;
  selectableIndexes: number[];
  selectedIndex: number;
  setSelectedIndex: React.Dispatch<React.SetStateAction<number>>;
};

export function useMenuSelection({
  menuId,
  selectableIndexes,
  selectedIndex,
  setSelectedIndex,
}: UseMenuSelectionProps) {
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
  }, [menuId, selectableIndexes, setSelectedIndex]);

  useEffect(() => {
    if (
      selectableIndexes.length > 0 &&
      !selectableIndexes.includes(selectedIndex)
    ) {
      setSelectedIndex(selectableIndexes[0]);
    }
  }, [selectableIndexes, selectedIndex, setSelectedIndex]);
}