import { useState } from "react";
import { ContextItem } from "./context-item";
import { Checkbox } from "../../ui/checkbox";
import { fetchNui } from "../../../utils/fetchNui";
import type { Color } from "../../../utils/color";

type CheckboxProps = {
  id: string;
  label: string;
  isChecked: boolean;
  disabled?: boolean;
  hoverColor?: Color;
};

export function ContextMenuCheckbox({
  id,
  label,
  isChecked,
  disabled,
  hoverColor,
}: CheckboxProps) {
  const [checked, setChecked] = useState(isChecked);

  return (
    <ContextItem
      id={id}
      className="flex items-center justify-between"
      data-checked={checked}
      disabled={disabled}
      hoverColor={hoverColor}
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
    </ContextItem>
  );
}
