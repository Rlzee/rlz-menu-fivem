import { Item } from "../../item";
import { Switch } from "../../ui/switch";
import { LockIcon } from "../../ui/lock";
import { cn } from "../../../utils/cn";

type MenuSwitchProps = {
  label: string;
  isChecked?: boolean;
  selected?: boolean;
  disabled?: boolean;
};

export function MenuSwitch({
  label,
  isChecked = false,
  selected,
  disabled,
}: MenuSwitchProps) {
  return (
    <Item
      selected={selected}
      disabled={disabled}
    >
      <span>{label}</span>
      {disabled ? (
        <LockIcon className="h-4 w-4" />
      ) : (
        <Switch
          checked={isChecked}
          aria-label={label}
          className={cn(selected && !isChecked && "bg-menu-control-selected")}
        />
      )}
    </Item>
  );
}
