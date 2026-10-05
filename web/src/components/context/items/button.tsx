import { ContextItem } from "./context-item";
import { fetchNui } from "../../../utils/fetchNui";
import type { Color } from "../../../utils/color";

type ButtonProps = {
  id: string;
  label: string;
  disabled?: boolean;
  hoverColor?: Color;
};

export function ContextMenuButton({ id, label, disabled, hoverColor }: ButtonProps) {
  return (
    <ContextItem
      id={id}
      disabled={disabled}
      hoverColor={hoverColor}
      onSelect={() => fetchNui("rlz_menu:context:selectButton", { itemId: id })}
      onPointerEnter={() =>
        fetchNui("rlz_menu:context:hoverItem", { itemId: id })
      }
      onPointerLeave={() =>
        fetchNui("rlz_menu:context:leaveItem", { itemId: id })
      }
    >
      {label}
    </ContextItem>
  );
}
