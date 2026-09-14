export type ContextMenuData = {
  contextId?: string;
  x: number;
  y: number;
  items: [];
};

type ContextViewProps = {
  context: ContextMenuData;
};

export const ContextMenuView = ({ context }: ContextViewProps) => {
  return (
    <div
      id={context.contextId}
      className="w-20 h-auto bg-item-menu-background"
    ></div>
  );
};
