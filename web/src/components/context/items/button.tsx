import { ContextMenuItem } from "../../ui/context-menu";

type ButtonProps = {
  label: string;
  selected?: boolean;
  disabled?: boolean;
};

export function ContextMenuButton({ label, selected, disabled }: ButtonProps) {
  return (
    <ContextMenuItem disabled={disabled} data-selected={selected}>
      {label}
    </ContextMenuItem>
  );
}
