import type * as React from "react";
import { Slot } from "./ui/slot";
import { cn } from "../utils/cn";

type itemProps = {
  children: React.ReactNode;
  className?: string;
  selected?: boolean;
  disabled?: boolean;
};

export function Item({
  children,
  className,
  selected,
  disabled,
}: itemProps & Omit<React.ComponentProps<typeof Slot>, keyof itemProps>) {
  return (
    <Slot
      data-slot="menu-item"
      data-selected={selected ? "true" : undefined}
      className={cn(
        "flex h-8 items-center justify-between rounded-item bg-item px-2 text-body font-body text-white",
        disabled && "opacity-50 cursor-not-allowed",
        className,
      )}
    >
      {children}
    </Slot>
  );
}
