import { Item } from "../../item";
import { ChevronLeftIcon, ChevronRightIcon } from "@radix-ui/react-icons";
import { LockIcon } from "../../ui/lock";

type MenuListProps = {
  label: string;
  values: string[];
  index: number;
  value: string;
  selected?: boolean;
  disabled?: boolean;
};

export function MenuList({ label, value, selected, disabled }: MenuListProps) {
  return (
    <Item
      selected={selected}
      disabled={disabled}
    >
      <span>{label}</span>
      {!disabled ? (
        <div className="flex items-center gap-2 text-value">
          <ChevronLeftIcon className="h-4 w-4" />
          <span>{value}</span>
          <ChevronRightIcon className="h-4 w-4" />
        </div>
      ) : (
        <LockIcon className="h-4 w-4" />
      )}
    </Item>
  );
}
