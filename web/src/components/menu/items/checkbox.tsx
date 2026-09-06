import { Check } from "lucide-react";
import { cn } from "cn";

type MenuItemProps = {
  label: string;
  isChecked?: boolean;
  selected?: boolean;
  onMouseEnter?: () => void;
};

export function MenuCheckbox({
  label,
  isChecked = false,
  selected,
  onMouseEnter,
}: MenuItemProps) {
  return (
    <div
      data-slot="menu-checkbox"
      className={cn(
        "flex h-8 items-center justify-between rounded-xs px-2 text-white",
        selected ? "bg-[rgb(16_185_129_/_40%)]" : "bg-black/40",
      )}
      onMouseEnter={onMouseEnter}
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
