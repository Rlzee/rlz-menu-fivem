import { Label } from "../../ui/label";

type MenuLabelProps = {
  label: string;
};

export function MenuLabel({ label }: MenuLabelProps) {
  return (
    <Label data-slot="menu-label" className="pt-2 text-white">
      {label}
    </Label>
  );
};