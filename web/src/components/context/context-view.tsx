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
          {context.items.map((item, index) => {
            if (item.type === "button") {
              return (
                <ContextMenuItems.item.Button
                  key={item.id}
                  label={item.label}
                  selected={item.selected}
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
