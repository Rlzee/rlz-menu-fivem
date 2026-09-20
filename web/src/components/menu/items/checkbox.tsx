import { useRainbowColor } from "../../../hooks/useRainbowColor";
import type { Color } from "../../../utils/color";
import { Item } from "../../item";
import { Checkbox } from "../../ui/checkbox";
import { Lock } from "lucide-react";
import { cn } from "cn";

type MenuCheckboxProps = {
  label: string;
  isChecked?: boolean;
  selected?: boolean;
  disabled?: boolean;
  itemColor?: Color;
  menuColor?: Color;
  hoverColor?: Color;
};

export function MenuCheckbox({
  label,
  isChecked = false,
  selected,
  disabled,
  itemColor,
  menuColor,
  hoverColor,
}: MenuCheckboxProps) {
  const color = useRainbowColor(itemColor, menuColor);

  return (
    <Item
      selected={selected}
      disabled={disabled}
      color={color}
      alwaysColor={Boolean(itemColor)}
      hoverColor={hoverColor}
    >
      <span>{label}</span>
      {disabled ? (
        <Lock className="h-4 w-4" />
      ) : (
        <Checkbox
          checked={isChecked}
          aria-label={label}
          className={cn(selected && !isChecked && "bg-checkbox-selected")}
        />
      )}
    </Item>
  );
}
