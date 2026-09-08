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
        "flex h-8 items-center justify-between rounded-xs px-2 text-white",
        selected ? "bg-[rgb(16_185_129_/_40%)]" : "bg-black/40",
        disabled && "opacity-50 cursor-not-allowed",
        className,
      )}
    >
      {children}
    </div>
  );
}
