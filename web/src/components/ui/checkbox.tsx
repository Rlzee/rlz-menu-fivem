import * as React from "react";
import { Checkbox as CheckboxPrimitive } from "radix-ui";

import { cn } from "cn";
import { Check } from "lucide-react";

export function Checkbox({
  className,
  size = "md",
  ...props
}: React.ComponentProps<typeof CheckboxPrimitive.Root> & {
  size?: "sm" | "md" | "lg";
}) {
  return (
    <CheckboxPrimitive.Root
      data-slot="checkbox"
      data-size={size}
      className={cn(
        "bg-checkbox data-[state=checked]:bg-white",
        "peer relative flex shrink-0 items-center justify-center rounded-checkbox outline-none data-[size=sm]:size-3.5 data-[size=md]:size-4 data-[size=lg]:size-5",
        className,
      )}
      {...props}
    >
      <CheckboxPrimitive.Indicator
        data-slot="checkbox-indicator"
        className="grid place-content-center text-current transition-none [&>svg]:size-3.5"
      >
        <Check className="h-4 w-4 text-black" />
      </CheckboxPrimitive.Indicator>
    </CheckboxPrimitive.Root>
  );
}
