import { MenuButton } from "./items/button";
import { MenuCheckbox } from "./items/checkbox";
import { MenuSwitch } from "./items/switch";
import { MenuLabel } from "./items/label";
import { MenuSeparator } from "./items/separator";
import { MenuList } from "./items/list";
import { MenuSlider } from "./items/slider";
import { MenuRadio } from "./items/radio";
import { MenuLevel } from "./items/level";
import type { MenuItem } from "./items/type";

type MenuItemViewProps = {
  item: MenuItem;
  selected: boolean;
};

/**
 * Maps a single menu item to its presentation component. Kept isolated from
 * `MenuView` so the item-type dispatch lives in one place and the menu layout
 * stays readable.
 */
export function MenuItemView({ item, selected }: MenuItemViewProps) {
  switch (item.type) {
    case "button":
      return (
        <MenuButton
          label={item.label}
          anchor={item.anchor}
          selected={selected}
          submenu={item.submenu}
          disabled={item.disabled}
        />
      );

    case "checkbox":
      return (
        <MenuCheckbox
          label={item.label}
          isChecked={item.isChecked}
          selected={selected}
          disabled={item.disabled}
        />
      );

    case "switch":
      return (
        <MenuSwitch
          label={item.label}
          isChecked={item.isChecked}
          selected={selected}
          disabled={item.disabled}
        />
      );

    case "list":
      return (
        <MenuList
          label={item.label}
          values={item.values}
          index={item.index}
          value={item.value}
          selected={selected}
          disabled={item.disabled}
        />
      );

    case "slider":
      return (
        <MenuSlider
          label={item.label}
          percent={item.percent}
          min={item.min}
          max={item.max}
          value={item.value}
          selected={selected}
          disabled={item.disabled}
        />
      );

    case "radio":
      return (
        <MenuRadio
          label={item.label}
          isChecked={item.isChecked}
          selected={selected}
          disabled={item.disabled}
        />
      );

    case "level":
      return (
        <MenuLevel
          label={item.label}
          value={item.value}
          max={item.max}
          selected={selected}
          disabled={item.disabled}
        />
      );

    case "label":
      return <MenuLabel label={item.label} />;

    case "separator":
      return <MenuSeparator visible={item.visible} />;
  }
}
