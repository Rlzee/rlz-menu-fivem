import { ContextMenu, ContextMenuContent } from "../ui/context-menu";
import { ContextMenuHeader } from "./header";
import { ContextMenuItemContent } from "./items-content";

import type { ContextMenuItem } from "./items/type";
import { ContextMenuItems } from "./items/export";

export type ContextMenuData = {
  type: "player" | "ped" | "vehicle" | "object" | "world" | "sky";
  title: string;
  items: ContextMenuItem[];
  x: number;
  y: number;
};

type ContextViewProps = {
  context: ContextMenuData;
};

export function ContextView({ context }: ContextViewProps) {
  return (
    <ContextMenu open>
      <ContextMenuContent
        style={{ position: "fixed", left: context.x, top: context.y }}
      >
        <ContextMenuHeader title={context.title} />
        <ContextMenuItemContent>
          {context.items.map((item) => {
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
          })}
        </ContextMenuItemContent>
      </ContextMenuContent>
    </ContextMenu>
  );
}
