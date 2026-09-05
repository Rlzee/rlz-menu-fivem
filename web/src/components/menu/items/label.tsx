type MenuLabelProps = {
  label: string;
};

export function MenuLabel({ label }: MenuLabelProps) {
  return (
    <div data-slot="menu-label" className="h-8 px-0.5 font-medium text-white">
      {label}
    </div>
  );
};