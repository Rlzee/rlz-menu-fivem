import { useRainbowColor } from "../../../hooks/useRainbowColor";
import type { Color } from "../../../utils/color";
import { Item } from "../../item";
import { ChevronRight, Lock } from "lucide-react";

type MenuButtonProps = {
  label: string;
  anchor?: string;
  anchorColor?: string;
  selected?: boolean;
  submenu?: boolean;
  disabled?: boolean;
  buttonColor?: Color;
  menuColor?: Color;
  hoverColor?: Color;
};

export function MenuButton({
  label,
  anchor,
  anchorColor,
  selected,
  submenu,
  disabled,
  buttonColor,
  menuColor,
  hoverColor,
}: MenuButtonProps) {
  const effectiveColor = useRainbowColor(buttonColor, menuColor);
  const effectiveAnchorColor = useRainbowColor(anchorColor);

  return (
    <Item
      selected={selected}
      disabled={disabled}
      color={effectiveColor}
      alwaysColor={Boolean(buttonColor)}
      hoverColor={hoverColor}
    >
      <span>{label}</span>
      <span style={effectiveAnchorColor ? { color: effectiveAnchorColor } : undefined}>
        {anchor ||
          (submenu && <ChevronRight className="h-4 w-4" />) ||
          (disabled && <Lock className="h-4 w-4" />)}
      </span>
    </Item>
  );
}
