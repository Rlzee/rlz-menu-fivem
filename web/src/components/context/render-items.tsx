import type { ContextMenuItem } from "./items/type";
import { ContextMenuItems } from "./items/export";

export function ContextMenuRenderItems({
  items,
}: {
  items: ContextMenuItem[];
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
            />
          );
        }
      })}
    </>
  );
}
