import { ChevronRight } from "lucide-react";

type MenuItemProps = {
  label: string;
  anchor?: string;
};

export function MenuButton({ label, anchor }: MenuItemProps) {
  return (
    <div data-slot="menu-item" className="flex h-8 items-center justify-between rounded-xs bg-black/40 px-2 text-white">
      <span>{label}</span>
      <span>{anchor || <ChevronRight className="h-4 w-4" />}</span>
    </div>
  );
};