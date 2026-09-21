import type * as React from "react";
import { Switch as SwitchPrimitive } from "radix-ui";

import { cn } from "cn";

export function Switch({
  className,
  ...props
}: React.ComponentProps<typeof SwitchPrimitive.Root>) {
  return (
    <SwitchPrimitive.Root
      data-slot="switch"
      className={cn(
        "bg-checkbox data-[state=checked]:bg-white",
        "peer group/switch relative inline-flex h-4 w-6 shrink-0 items-center rounded-full outline-none",
        className,
      )}
      {...props}
    >
      <SwitchPrimitive.Thumb
        data-slot="switch-thumb"
        className="pointer-events-none block rounded-full bg-white ring-0 transition-transform size-3 group-data-[state=checked]/switch:translate-x-[calc(100%-2px)] data-[state=checked]:bg-black data-[state=unchecked]/switch:translate-x-0"
      />
    </SwitchPrimitive.Root>
  );
}