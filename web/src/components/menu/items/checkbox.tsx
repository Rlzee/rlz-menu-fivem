import { Item } from "../../item";
import { Checkbox } from "../../ui/checkbox";
import { LockIcon } from "../../ui/lock";
import { cn } from "../../../utils/cn";

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
    <Item
      selected={selected}
      disabled={disabled}
    >
      <span>{label}</span>
      {disabled ? (
        <LockIcon className="h-4 w-4" />
      ) : (
        <Checkbox
          checked={isChecked}
          aria-label={label}
          className={cn(selected && !isChecked && "bg-control-selected")}
        />
      )}
    </Item>
  );
}
