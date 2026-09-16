import { cn } from "cn";
import { withOpacity } from "../utils/color";

type itemProps = {
  children: React.ReactNode;
  className?: string;
  selected?: boolean;
  disabled?: boolean;
  color?: string;
  hoverColor?: string;
  alwaysColor?: boolean;
};

export function Item({
  children,
  className,
  selected,
  disabled,
  color,
  hoverColor,
  alwaysColor,
}: itemProps) {
  const hasCustomColor = color && color !== "default";
  const customColorStyle = hasCustomColor
    ? { backgroundColor: withOpacity(color, 0.4) }
    : undefined;
  const hoverColorStyle = hoverColor
    ? { backgroundColor: withOpacity(hoverColor, 0.4) }
    : undefined;

  return (
    <div
      data-slot="menu-item"
      data-selected={selected ? "true" : undefined}
      className={cn(
        "flex h-8 items-center justify-between rounded-item px-2 text-white",
        selected
          ? hasCustomColor && !alwaysColor
            ? "bg-transparent"
            : "bg-item-menu-background-hover"
          : "bg-item-menu-background",
        disabled && "opacity-50 cursor-not-allowed",
        className,
      )}
      style={alwaysColor
        ? (selected ? hoverColorStyle : customColorStyle)
        : (selected ? hoverColorStyle ?? customColorStyle : undefined)}
    >
      {children}
    </div>
  );
}
