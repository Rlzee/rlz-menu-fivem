import { cn } from "cn";

type itemProps = {
  children: React.ReactNode;
  className?: string;
  selected?: boolean;
  disabled?: boolean;
};

export function Item({ children, className, selected, disabled }: itemProps) {
  return (
    <div
      data-slot="menu-item"
      className={cn(
        "flex h-8 items-center justify-between rounded-item px-2 text-white",
        selected ? "bg-item-menu-background-hover" : "bg-item-menu-background",
        disabled && "opacity-50 cursor-not-allowed",
        className,
      )}
    >
      {children}
    </div>
  );
}
