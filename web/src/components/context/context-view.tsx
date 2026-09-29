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
  Context: ContextMenuData;
};

export function ContextView({ Context }: ContextViewProps) {
  return (
    <ContextMenu>
      <ContextMenuContent
        style={{ position: "fixed", left: Context.x, top: Context.y }}
      >
        <ContextHeader title={Context.title} />
      </ContextMenuContent>
    </ContextMenu>
  );
}
