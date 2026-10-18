import { Item } from "../../item";
import { Spinner } from "../../ui/spinner";
import { ChevronRightIcon } from "@radix-ui/react-icons";
import { LockIcon } from "../../ui/lock";

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
    <Item
      selected={selected}
      disabled={disabled}
    >
      <span>{label}</span>
      <span className="text-value">
        {disabled ? (
          <LockIcon className="h-4 w-4" />
        ) : anchor === "loading" ? (
          <Spinner />
        ) : (
          anchor || (submenu && <ChevronRightIcon className="h-4 w-4" />)
        )}
      </span>
    </Item>
  );
}
