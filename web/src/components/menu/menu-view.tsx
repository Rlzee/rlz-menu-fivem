import {
  useEffect,
  useMemo,
  useRef,
  useState,
  type MouseEventHandler,
  type PointerEventHandler,
} from "react";
import { useMenuNavigation } from "../../hooks/useMenuNavigation";
import { useMenuSelection } from "../../hooks/useMenuSelection";

import { hasAdjustableItem, isSelectableItem } from "./items/config";
import { Menu } from "./exports";
import { MenuItemView } from "./menu-item";
import { Controls, type ControlItem } from "./controls";
import { useMenuColorVars } from "../../hooks/useMenuColorVars";
import type { MenuItem } from "./items/type";

export type MenuData = {
  menuId?: string;
  selectedItemId?: string;
  title: string;
  subtitle: string;
  position: "left" | "right";
  /** Whether the menu navigation controls are displayed. */
  controls?: boolean;
  /** Base accent color for the whole menu: a CSS color, "rainbow", or an array of colors for a gradient banner. */
  color?: string | string[];
  /** Custom banner image path/URL, replaces the colored banner when set. */
  banner?: string;
  /** Saved custom position, as ratios between 0 and 1. */
  x?: number;
  y?: number;
  items: MenuItem[];
};

/** Controls displayed while the keyboard position edit mode is active. */
const POSITION_CONTROLS: ControlItem[] = [
  { keys: ["←", "↑", "↓", "→"], label: "Move" },
  { keys: ["Enter"], label: "Save" },
  { keys: ["Backspace"], label: "Cancel" },
];

type MenuViewProps = {
  menu: MenuData;
  dragging?: boolean;
  moveMode?: boolean;
  onHeaderPointerDown?: PointerEventHandler<HTMLDivElement>;
  onHeaderDoubleClick?: MouseEventHandler<HTMLDivElement>;
};

export const MenuView = ({
  menu,
  dragging,
  moveMode,
  onHeaderPointerDown,
  onHeaderDoubleClick,
}: MenuViewProps) => {
  const selectableIndexes = useMemo(() => {
    return menu.items.reduce<number[]>((indexes, item, index) => {
      if (isSelectableItem(item)) {
        indexes.push(index);
      }

      return indexes;
    }, []);
  }, [menu.items]);

  const [selectedIndex, setSelectedIndex] = useState(() => {
    const restoredIndex = menu.items.findIndex(
      (item) => item.id === menu.selectedItemId,
    );

    return selectableIndexes.includes(restoredIndex)
      ? restoredIndex
      : selectableIndexes[0] ?? 0;
  });
  const menuRef = useRef<HTMLDivElement>(null);

  const navControls = useMemo<ControlItem[]>(() => {
    const items: ControlItem[] = [{ keys: ["↑", "↓"], label: "Navigate" }];

    if (hasAdjustableItem(menu.items)) {
      items.push({ keys: ["←", "→"], label: "Change" });
    }

    items.push({ keys: ["Enter"], label: "Select" });
    items.push({ keys: ["Backspace"], label: "Back" });

    return items;
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
    selectedItem && "description" in selectedItem
      ? (selectedItem.description ?? "")
      : "";

  const currentPosition = selectableIndexes.indexOf(selectedIndex);

  const showControls = Boolean(moveMode) || Boolean(menu.controls);

  useMenuColorVars(menuRef, menu.color);

  return (
    <div
      ref={menuRef}
      id={menu.menuId}
      className="w-(--menu-width) grid grid-cols-[minmax(0,1fr)] gap-(--menu-gap)"
    >
      <Menu.Header
        title={menu.title}
        subtitle={menu.subtitle}
        banner={menu.banner}
        current={currentPosition >= 0 ? currentPosition + 1 : 0}
        total={selectableIndexes.length}
        dragging={dragging || moveMode}
        onPointerDown={onHeaderPointerDown}
        onDoubleClick={onHeaderDoubleClick}
      />

      <Menu.Content>
        {menu.items.map((item, index) => (
          <MenuItemView
            key={item.id}
            item={item}
            selected={selectedIndex === index}
          />
        ))}
      </Menu.Content>

      {footerDescription && (
        <Menu.Footer
          description={footerDescription}
          roundedBottom={!showControls}
        />
      )}

      {moveMode ? (
        <Controls items={POSITION_CONTROLS} />
      ) : (
        menu.controls && <Controls items={navControls} />
      )}
    </div>
  );
};
