import type { MenuItem } from "./type";

export function isSelectableItem(item: MenuItem) {
  return (
    (item.type === "button" ||
      item.type === "checkbox" ||
    item.type === "switch" ||
      item.type === "list" ||
      item.type === "slider" ||
      item.type === "radio" ||
      item.type === "level") &&
    !item.disabled
  );
}