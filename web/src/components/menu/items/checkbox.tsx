import { Item } from "../../item";
import { Check, Lock } from "lucide-react";
import { cn } from "cn";

type MenuCheckboxProps = {
  label: string;
  isChecked?: boolean;
  selected?: boolean;
  disabled?: boolean;
};

export function MenuCheckbox({
  label,
  isChecked = false,
  selected,
  disabled,
}: MenuCheckboxProps) {
  return (
    <Item selected={selected} disabled={disabled}>
      <span>{label}</span>
      {isChecked && !disabled ? (
        <div className="h-4 w-4 rounded-checkbox bg-white">
          <Check className="h-4 w-4 text-black" />
        </div>
      ) : !isChecked && !disabled ? (
        <div
          className={cn(
            "h-4 w-4 rounded-checkbox",
            selected ? "bg-checkbox-selected" : "bg-checkbox",
          )}
        />
      ) : (
        <Lock className="h-4 w-4" />
      )}
    </Item>
  );
}
