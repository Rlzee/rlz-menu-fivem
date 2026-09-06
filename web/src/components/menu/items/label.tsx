type MenuLabelProps = {
  label: string;
};

export function MenuLabel({ label }: MenuLabelProps) {
  return (
    <div data-slot="menu-label" className="h-8 px-1 text-white">
      {label}
    </div>
  );
};