import { Item } from "../../item";
import { ChevronLeft, ChevronRight, Lock } from "lucide-react";

type MenuListProps = {
  label: string;
  values: string[];
  index: number;
  value: string;
  selected?: boolean;
  disabled?: boolean;
  color?: string;
};

export function MenuList({ label, value, selected, disabled, color }: MenuListProps) {
  return (
    <Item selected={selected} disabled={disabled} color={color}>
      <span>{label}</span>
      {!disabled ? (
        <div className="flex items-center gap-2">
          <ChevronLeft className="h-4 w-4" />
          <span>{value}</span>
          <ChevronRight className="h-4 w-4" />
        </div>
      ) : (
        <Lock className="h-4 w-4" />
      )}
    </Item>
  );
}
