import type * as React from "react";

import { cn } from "../../utils/cn";

type RadioProps = {
  checked?: boolean;
} & Omit<React.ComponentProps<"span">, "onChange">;

export function Radio({ className, checked = false, ...props }: RadioProps) {
  return (
    <span
      data-slot="radio"
      className={cn(
        "bg-control data-[state=checked]:bg-accent transition-colors",
        "relative flex size-4 shrink-0 items-center justify-center rounded-full outline-none",
        className,
      )}
      data-state={checked ? "checked" : "unchecked"}
      {...props}
    >
      {checked && (
        <span className="size-2 animate-in zoom-in-50 rounded-full bg-white" />
      )}
    </span>
  );
}
