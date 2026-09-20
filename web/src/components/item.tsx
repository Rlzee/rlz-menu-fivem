import type * as React from "react";
import { Slot } from "./ui/slot";
import { cn } from "cn";
import { toColorValue, type Color } from "../utils/color";

type itemProps = {
  children: React.ReactNode;
  className?: string;
  selected?: boolean;
  disabled?: boolean;
  color?: Color;
  hoverColor?: Color;
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
}: itemProps & Omit<React.ComponentProps<typeof Slot>, keyof itemProps>) {
  const hasCustomColor = color && color !== "default";
  const customColorStyle = hasCustomColor
    ? { background: toColorValue(color, 0.55) }
    : undefined;
  const hoverColorStyle = hoverColor
    ? { background: toColorValue(hoverColor, 0.55) }
    : undefined;

  return (
    <Slot
      data-slot="menu-item"
      data-selected={selected ? "true" : undefined}
      className={cn(
        "flex h-8 items-center justify-between rounded-item px-2 text-white text-[0.900rem] transition-colors duration-200",
        selected
          ? hasCustomColor && !alwaysColor
            ? "bg-transparent"
            : "bg-item-menu-background-hover"
          : "bg-item-menu-background",
        disabled && "opacity-50 cursor-not-allowed",
        className,
      )}
      style={
        alwaysColor
          ? selected
            ? hoverColorStyle
            : customColorStyle
          : selected
            ? (hoverColorStyle ?? customColorStyle)
            : undefined
      }
    >
      {children}
    </Slot>
  );
}
