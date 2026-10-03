import { useState } from "react";
import { ContextMenuItem } from "../../ui/context-menu";
import { Checkbox } from "../../ui/checkbox";
import { fetchNui } from "../../../utils/fetchNui";

type CheckboxProps = {
  id: string;
  label: string;
  isChecked: boolean;
  disabled?: boolean;
};

export function ContextMenuCheckbox({
  id,
  label,
  isChecked,
  disabled,
}: CheckboxProps) {
  const [checked, setChecked] = useState(isChecked);

  return (
    <ContextMenuItem
      id={id}
      className="flex items-center justify-between"
      data-checked={checked}
      disabled={disabled}
      onSelect={(event) => {
        event.preventDefault();
        setChecked((current) => !current);
        fetchNui("rlz_menu:context:selectCheckbox", { itemId: id });
      }}
      onPointerEnter={() =>
        fetchNui("rlz_menu:context:hoverItem", { itemId: id })
      }
      onPointerLeave={() =>
        fetchNui("rlz_menu:context:leaveItem", { itemId: id })
      }
    >
      <span>{label}</span>
      <Checkbox className="group-hover/context-menu-item:bg-checkbox-selected" checked={checked} disabled={disabled} size="sm" />
    </ContextMenuItem>
  );
}
