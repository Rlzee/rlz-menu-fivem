import { ContextMenuItem } from "../../ui/context-menu";
import { fetchNui } from "../../../utils/fetchNui";

type ButtonProps = {
  id: string;
  label: string;
  disabled?: boolean;
};

export function ContextMenuButton({ id, label, disabled }: ButtonProps) {
  return (
    <ContextMenuItem
      disabled={disabled}
      onSelect={() => fetchNui("rlz_menu:context:selectButton", { itemId: id })}
    >
      {label}
    </ContextMenuItem>
  );
}
