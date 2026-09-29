import { ContextMenuItem } from "../../ui/context-menu";

type ButtonProps = {
  label: string;
  disabled?: boolean;
};

export function ContextMenuButton({ label, disabled }: ButtonProps) {
  return (
    <ContextMenuItem disabled={disabled}>
      {label}
    </ContextMenuItem>
  );
}
