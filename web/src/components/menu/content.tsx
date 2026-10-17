type MenuContentProps = {
  children: React.ReactNode;
};

export function MenuContent({ children }: MenuContentProps) {
  return (
    <div
      data-slot="menu-content"
      className="bg-surface max-h-(--menu-height) overflow-x-auto menu-scrollbar-hidden"
    >
      <div className="flex flex-col gap-(--item-gap) p-(--menu-padding)">
        {children}
      </div>
    </div>
  );
}
