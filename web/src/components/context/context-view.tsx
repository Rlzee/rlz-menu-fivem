import {
  ContextMenu,
  ContextMenuContent,
  ContextMenuGroup,
} from "../ui/context-menu";
import { ContextMenuHeader } from "./header";

import type { ContextMenuItem } from "./items/type";
import { ContextMenuRenderItems } from "./render-items";

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
        <ContextMenuGroup>
          <ContextMenuRenderItems items={context.items} />
        </ContextMenuGroup>
      </ContextMenuContent>
    </ContextMenu>
  );
}
