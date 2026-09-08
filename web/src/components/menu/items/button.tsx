import { Item } from "../../item";
import { ChevronRight, Lock } from "lucide-react";

type MenuButtonProps = {
  label: string;
  anchor?: string;
  selected?: boolean;
  submenu?: boolean;
  disabled?: boolean;
};

export function MenuButton({
  label,
  anchor,
  selected,
  submenu,
  disabled,
}: MenuButtonProps) {
  return (
    <Item selected={selected} disabled={disabled}>
      <span>{label}</span>
      <span>
        {anchor ||
          (submenu && <ChevronRight className="h-4 w-4" />) ||
          (disabled && <Lock className="h-4 w-4" />)}
      </span>
    </Item>
  );
}
