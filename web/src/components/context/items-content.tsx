export function ContextMenuItemContent({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <div className="bg-background-menu w-full h-auto rounded-b-menu">
      <div className="flex flex-col gap-(--item-menu-padding)">{children}</div>
    </div>
  );
}
