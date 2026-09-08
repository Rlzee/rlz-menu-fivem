import { Item } from "../../item";
import { ChevronRight, Lock } from "lucide-react";

type MenuButtonProps = {
  label: string;
  anchor?: string;
  selected?: boolean;
  submenu?: boolean;
  disabled?: boolean;
  color?: string;
};

export function MenuButton({
  label,
  anchor,
  selected,
  submenu,
  disabled,
  color,
}: MenuButtonProps) {
  return (
    <Item selected={selected} disabled={disabled} color={color}>
      <span>{label}</span>
      <span>
        {anchor ||
          (submenu && <ChevronRight className="h-4 w-4" />) ||
          (disabled && <Lock className="h-4 w-4" />)}
      </span>
    </Item>
  );
}
