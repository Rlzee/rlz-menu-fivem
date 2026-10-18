import { Item } from "../../item";
import { Radio } from "../../ui/radio";
import { LockIcon } from "../../ui/lock";
import { cn } from "../../../utils/cn";

type MenuRadioProps = {
  label: string;
  isChecked?: boolean;
  selected?: boolean;
  disabled?: boolean;
};

export function MenuRadio({
  label,
  isChecked = false,
  selected,
  disabled,
}: MenuRadioProps) {
  return (
    <Item
      selected={selected}
      disabled={disabled}
    >
      <span>{label}</span>
      {disabled ? (
        <LockIcon className="h-4 w-4" />
      ) : (
        <Radio
          checked={isChecked}
          aria-label={label}
          className={cn(selected && !isChecked && "bg-control-selected")}
        />
      )}
    </Item>
  );
}
