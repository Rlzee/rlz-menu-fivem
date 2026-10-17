import { Label } from "../../ui/label";

type MenuLabelProps = {
  label: string;
};

export function MenuLabel({ label }: MenuLabelProps) {
  return (
    <Label data-slot="menu-label" className="pt-2 pb-1 last:pb-0 first:pt-0 pl-(--label-indent) text-white font-label text-body uppercase">
      {label}
    </Label>
  );
};