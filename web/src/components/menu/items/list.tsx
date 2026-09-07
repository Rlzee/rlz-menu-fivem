import { ChevronLeft, ChevronRight } from "lucide-react";
import { cn } from "cn";

type MenuListProps = {
  label: string;
  values: string[];
  index: number;
  value: string;
  selected?: boolean;
};

export function MenuList({
  label,
  value,
  selected,
}: MenuListProps) {
  return (
    <div
      data-slot="menu-item"
      className={cn(
        "flex h-8 items-center justify-between rounded-xs px-2 text-white",
        selected ? "bg-[rgb(16_185_129_/_40%)]" : "bg-black/40",
      )}
    >
      <span>{label}</span>
      <div className="flex items-center gap-2">
        <ChevronLeft className="h-4 w-4" />
        <span>{value}</span>
        <ChevronRight className="h-4 w-4" />
      </div>
    </div>
  );
}
