import type { ContextMenuItem } from "./items/type";
import { ContextMenuItems } from "./items/export";
import type { Color } from "../../utils/color";

export function ContextMenuRenderItems({
  items,
  hoverColor,
}: {
  items: ContextMenuItem[];
  hoverColor?: Color;
}) {
  return (
    <>
      {items.map((item) => {
        if (item.type === "button") {
          return (
            <ContextMenuItems.item.Button
              key={item.id}
              id={item.id}
              label={item.label}
              disabled={item.disabled}
              hoverColor={hoverColor}
            />
          );
        }

        if (item.type === "checkbox") {
          return (
            <ContextMenuItems.item.Checkbox
              key={item.id}
              id={item.id}
              label={item.label}
              isChecked={item.isChecked}
              disabled={item.disabled}
              hoverColor={hoverColor}
            />
          );
        }

        if (item.type === "switch") {
          return (
            <ContextMenuItems.item.Switch
              key={item.id}
              id={item.id}
              label={item.label}
              isChecked={item.isChecked}
              disabled={item.disabled}
              hoverColor={hoverColor}
            />
          );
        }

        if (item.type === "separator") {
          return <ContextMenuItems.item.Separator key={item.id} id={item.id} />;
        }

        if (item.type === "submenu") {
          return (
            <ContextMenuItems.item.SubMenu
              key={item.id}
              id={item.id}
              label={item.label}
              disabled={item.disabled}
              items={item.items}
              hoverColor={hoverColor}
            />
          );
        }

        if (item.type === "radio") {
          return (
            <ContextMenuItems.item.Radio
              key={item.id}
              id={item.id}
              isChecked={item.isChecked}
              items={item.items}
              hoverColor={hoverColor}
            />
          );
        }
      })}
    </>
  );
}
