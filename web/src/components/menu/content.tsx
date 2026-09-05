type MenuContentProps = {
  children: React.ReactNode;
};

export function MenuContent({ children }: MenuContentProps) {
  return (
    <div data-slot="menu-content" className="mt-0.5 bg-black/60">
      <div className="flex flex-col gap-1 p-2">
        {children}
      </div>
    </div>
  );
};