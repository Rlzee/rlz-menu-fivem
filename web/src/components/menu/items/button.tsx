import { ChevronRight } from "lucide-react";
import { cn } from "cn";

type MenuItemProps = {
  label: string;
  anchor?: string;
  selected?: boolean;
};

export function MenuButton({ label, anchor, selected }: MenuItemProps) {
  return (
    <div
      data-slot="menu-item"
      className={cn(
        "flex h-8 items-center justify-between rounded-xs px-2 text-white",
        selected ? "bg-[rgb(16_185_129_/_40%)]" : "bg-black/40",
      )}
    >
      <span>{label}</span>
      <span>{anchor || <ChevronRight className="h-4 w-4" />}</span>
    </div>
  );
}
