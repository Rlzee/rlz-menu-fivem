import type { MenuItem } from "./type";

export function isSelectableItem(item: MenuItem) {
  return (
    (item.type === "button" ||
      item.type === "checkbox" ||
      item.type === "list") &&
    !item.disabled
  );
}