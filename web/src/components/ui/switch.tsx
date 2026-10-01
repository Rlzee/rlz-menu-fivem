import type * as React from "react";
import { Switch as SwitchPrimitive } from "radix-ui";

import { cn } from "cn";

const switchSizes = {
  sm: {
    root: "h-3.5 w-5",
    thumb: "size-2.5 group-data-[state=checked]/switch:translate-x-[calc(100%-3px)]",
  },
  md: {
    root: "h-4 w-6",
    thumb: "size-3 group-data-[state=checked]/switch:translate-x-[calc(100%-3.5px)]",
  },
  lg: {
    root: "h-5 w-7",
    thumb: "size-3.5 group-data-[state=checked]/switch:translate-x-[calc(100%-4px)]",
  },
} satisfies Record<"sm" | "md" | "lg", { root: string; thumb: string }>;

export function Switch({
  className,
  size = "md",
  ...props
}: React.ComponentProps<typeof SwitchPrimitive.Root> & {
  size?: keyof typeof switchSizes;
}) {
  const currentSize = switchSizes[size];

  return (
    <SwitchPrimitive.Root
      data-slot="switch"
      data-size={size}
      className={cn(
        "bg-checkbox data-[state=checked]:bg-white",
        "peer group/switch relative inline-flex shrink-0 items-center rounded-checkbox outline-none px-0.5",
        currentSize.root,
        className,
      )}
      {...props}
    >
      <SwitchPrimitive.Thumb
        data-slot="switch-thumb"
        className={cn(
          "pointer-events-none block rounded-checkbox bg-white ring-0 transition-transform",
          currentSize.thumb,
          "data-[state=checked]:bg-black data-[state=unchecked]/switch:translate-x-0",
        )}
      />
    </SwitchPrimitive.Root>
  );
}
