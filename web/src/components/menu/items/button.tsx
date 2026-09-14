import { useRainbowColor } from "../../../hooks/useRainbowColor";
import { Item } from "../../item";
import { ChevronRight, Lock } from "lucide-react";

type MenuButtonProps = {
  label: string;
  anchor?: string;
  selected?: boolean;
  submenu?: boolean;
  disabled?: boolean;
  buttonColor?: string;
  menuColor?: string;
};

export function MenuButton({
  label,
  anchor,
  selected,
  submenu,
  disabled,
  buttonColor,
  menuColor,
}: MenuButtonProps) {
  const effectiveColor = useRainbowColor(buttonColor, menuColor);

  return (
    <Item
      selected={selected}
      disabled={disabled}
      color={effectiveColor}
      alwaysColor={Boolean(buttonColor)}
    >
      <span>{label}</span>
      <span>
        {anchor ||
          (submenu && <ChevronRight className="h-4 w-4" />) ||
          (disabled && <Lock className="h-4 w-4" />)}
      </span>
    </Item>
  );
}
