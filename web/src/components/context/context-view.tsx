import { ContextMenu, ContextMenuContent } from "../ui/context-menu";
import { ContextHeader } from "./header";

export type ContextMenuData = {
  type: "player" | "ped" | "vehicle" | "object" | "world" | "sky";
  title: string;
  items: [];
  x: number;
  y: number;
};

type ContextViewProps = {
  context: ContextMenuData;
};

export function ContextView({ context }: ContextViewProps) {
  return (
    <ContextMenu>
      <ContextMenuContent
        style={{ position: "fixed", left: context.x, top: context.y }}
      >
        <ContextHeader title={context.title} />
      </ContextMenuContent>
    </ContextMenu>
  );
}
