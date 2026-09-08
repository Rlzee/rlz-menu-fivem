import { cn } from "cn";
import { withOpacity } from "../utils/color";

type itemProps = {
  children: React.ReactNode;
  className?: string;
  selected?: boolean;
  disabled?: boolean;
  color?: string;
};

export function Item({
  children,
  className,
  selected,
  disabled,
  color,
}: itemProps) {
  const hasCustomColor = color && color !== "default";
  const selectedStyle = hasCustomColor
    ? { backgroundColor: withOpacity(color, 0.4) }
    : undefined;

  return (
    <div
      data-slot="menu-item"
      className={cn(
        "flex h-8 items-center justify-between rounded-item px-2 text-white",
        selected
          ? hasCustomColor
            ? "bg-transparent"
            : "bg-item-menu-background-hover"
          : "bg-item-menu-background",
        disabled && "opacity-50 cursor-not-allowed",
        className,
      )}
      style={selected ? selectedStyle : undefined}
    >
      {children}
    </div>
  );
}
