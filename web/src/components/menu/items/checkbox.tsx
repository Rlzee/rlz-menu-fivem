import { Check } from "lucide-react";
import { cn } from "cn";

type MenuCheckboxProps = {
  label: string;
  isChecked?: boolean;
  selected?: boolean;
};

export function MenuCheckbox({
  label,
  isChecked = false,
  selected,
}: MenuCheckboxProps) {
  return (
    <div
      data-slot="menu-checkbox"
      className={cn(
        "flex h-8 items-center justify-between rounded-xs px-2 text-white",
        selected ? "bg-[rgb(16_185_129_/_40%)]" : "bg-black/40",
      )}
    >
      <span>{label}</span>
      {isChecked ? (
        <div className="h-4 w-4 rounded-xs bg-white">
          <Check className="h-4 w-4 text-black" />
        </div>
      ) : (
        <div
          className={cn(
            "h-4 w-4 rounded-xs",
            selected ? "bg-zinc-800/60" : "bg-white/10",
          )}
        />
      )}
    </div>
  );
}
