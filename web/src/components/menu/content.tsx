type MenuContentProps = {
  children: React.ReactNode;
};

export function MenuContent({ children }: MenuContentProps) {
  return (
    <div
      data-slot="menu-content"
      className="bg-background-menu max-h-(--menu-height) overflow-x-auto menu-scrollbar-hidden"
    >
      <div className="flex flex-col gap-1 p-(--menu-padding)">{children}</div>
    </div>
  );
}
