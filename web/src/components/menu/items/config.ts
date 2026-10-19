import type { MenuItem } from "./type";

/** Every item type the renderer knows how to display. */
export type ItemType = MenuItem["type"];

type ItemBehavior = {
  /** Participates in keyboard navigation and counts toward the position indicator. */
  selectable: boolean;
  /** Left/Right arrows change the item's value. */
  adjustable: boolean;
};

/**
 * Per-type behavior flags, used to derive selectable items, the adjustable
 * hint in the control bar and the footer description. Keeping them here means
 * adding a new item type is a one-entry change instead of touching several
 * scattered conditionals.
 */
export const ITEM_BEHAVIOR: Record<ItemType, ItemBehavior> = {
  button: { selectable: true, adjustable: false },
  checkbox: { selectable: true, adjustable: false },
  switch: { selectable: true, adjustable: false },
  radio: { selectable: true, adjustable: false },
  list: { selectable: true, adjustable: true },
  slider: { selectable: true, adjustable: true },
  level: { selectable: true, adjustable: true },
  label: { selectable: false, adjustable: false },
  separator: { selectable: false, adjustable: false },
};

/** Whether an item can be focused/selected during navigation. */
export function isSelectableItem(item: MenuItem): boolean {
  if (!ITEM_BEHAVIOR[item.type].selectable) {
    return false;
  }

  return "disabled" in item ? item.disabled !== true : true;
}

/** Whether any of the given items reacts to the Left/Right arrows. */
export function hasAdjustableItem(items: MenuItem[]): boolean {
  return items.some((item) => ITEM_BEHAVIOR[item.type].adjustable);
}
