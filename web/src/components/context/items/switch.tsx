import { useState } from "react";
import { ContextMenuItem } from "../../ui/context-menu";
import { Switch } from "../../ui/switch";
import { fetchNui } from "../../../utils/fetchNui";

type SwitchProps = {
  id: string;
  label: string;
  isChecked: boolean;
  disabled?: boolean;
};

export function ContextMenuSwitch({
  id,
  label,
  isChecked,
  disabled,
}: SwitchProps) {
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
      <Switch checked={checked} disabled={disabled} size="sm" />
    </ContextMenuItem>
  );
}
