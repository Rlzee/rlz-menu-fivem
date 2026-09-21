import { useRainbowColor } from "../../../hooks/useRainbowColor";
import type { Color } from "../../../utils/color";
import { Item } from "../../item";
import { Switch } from "../../ui/switch";
import { Lock } from "lucide-react";
import { cn } from "cn";

type MenuSwitchProps = {
  label: string;
  isChecked?: boolean;
  selected?: boolean;
  disabled?: boolean;
  itemColor?: Color;
  menuColor?: Color;
  hoverColor?: Color;
};

export function MenuSwitch({
  label,
  isChecked = false,
  selected,
  disabled,
  itemColor,
  menuColor,
  hoverColor,
}: MenuSwitchProps) {
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
        <Switch
          checked={isChecked}
          aria-label={label}
          className={cn(selected && !isChecked && "bg-checkbox-selected")}
        />
      )}
    </Item>
  );
}
