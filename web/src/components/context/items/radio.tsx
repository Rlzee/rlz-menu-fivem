import { useState } from "react";
import { RadioGroup, Radio } from "../../ui/radio";
import { ContextMenuItem } from "../../ui/context-menu";
import { fetchNui } from "../../../utils/fetchNui";

type ContextMenuRadioProps = {
  id: string;
  isChecked: string;
  items: {
    id: string;
    label: string;
    disabled?: boolean;
  }[];
};

export function ContextMenuRadio({
  id,
  isChecked,
  items,
}: ContextMenuRadioProps) {
  const [value, setValue] = useState(isChecked);

  const selectItem = (itemId: string) => {
    setValue(itemId);
    fetchNui("rlz_menu:context:selectRadio", {
      groupId: id,
      itemId,
    });
  };

  return (
    <RadioGroup
      id={id}
      className="gap-0"
      value={value}
      onValueChange={selectItem}
    >
      {items?.map((item) => (
        <ContextMenuItem
          key={item.id}
          id={item.id}
          disabled={item.disabled}
          className="flex items-center justify-between"
          onSelect={(event) => {
            event.preventDefault();
            selectItem(item.id);
          }}
          onPointerEnter={() =>
            fetchNui("rlz_menu:context:hoverItem", { itemId: item.id })
          }
          onPointerLeave={() =>
            fetchNui("rlz_menu:context:leaveItem", { itemId: item.id })
          }
        >
          <span>{item.label}</span>
          <Radio
            value={item.id}
            disabled={item.disabled}
            className="group-hover/context-menu-item:bg-checkbox-selected"
          />
        </ContextMenuItem>
      ))}
    </RadioGroup>
  );
}
