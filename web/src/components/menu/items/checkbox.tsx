import { Check } from "lucide-react";

type MenuItemProps = {
  label: string;
  isChecked?: boolean;
};

export function MenuCheckbox({ label, isChecked = false }: MenuItemProps) {
  return (
    <div
      data-slot="menu-checkbox"
      className="flex h-8 items-center justify-between rounded-xs bg-black/40 px-2 text-white"
    >
      <span>{label}</span>
      {isChecked ? (
        <div className="h-4 w-4 rounded-xs bg-white">
          <Check className="h-4 w-4 text-black" />
        </div>
      ) : (
        <div className="h-4 w-4 rounded-xs bg-white/10" />
      )}
    </div>
  );
}
