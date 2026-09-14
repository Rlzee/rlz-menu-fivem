type MenuLabelProps = {
  label: string;
};

export function MenuLabel({ label }: MenuLabelProps) {
  return (
    <div data-slot="menu-label" className="pt-2 text-white">
      {label}
    </div>
  );
};