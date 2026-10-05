import {
  ContextMenu,
  ContextMenuContent,
  ContextMenuGroup,
} from "../ui/context-menu";
import { ContextMenuHeader } from "./header";

import type { ContextMenuItem } from "./items/type";
import { ContextMenuRenderItems } from "./render-items";
import { useRainbowColor } from "../../hooks/useRainbowColor";
import type { Color } from "../../utils/color";

export type ContextMenuData = {
  type: "player" | "ped" | "vehicle" | "object" | "world" | "sky";
  title: string;
  hoverColor?: Color;
  items: ContextMenuItem[];
  x: number;
  y: number;
};

type ContextViewProps = {
  context: ContextMenuData;
};

export function ContextView({ context }: ContextViewProps) {
  const hoverColor = useRainbowColor(context.hoverColor);

  return (
    <ContextMenu open>
      <ContextMenuContent
        style={{ position: "fixed", left: context.x, top: context.y }}
      >
        <ContextMenuHeader title={context.title} />
        <ContextMenuGroup>
          <ContextMenuRenderItems items={context.items} hoverColor={hoverColor} />
        </ContextMenuGroup>
      </ContextMenuContent>
    </ContextMenu>
  );
}
