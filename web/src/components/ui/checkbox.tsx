import * as React from "react";
import { Checkbox as CheckboxPrimitive } from "radix-ui";

import { cn } from "cn";
import { Check } from "lucide-react";

export function Checkbox({
  className,
  ...props
}: React.ComponentProps<typeof CheckboxPrimitive.Root>) {
  return (
    <CheckboxPrimitive.Root
      data-slot="checkbox"
      className={cn(
        "bg-checkbox data-[state=checked]:bg-white",
        "peer relative flex size-4 shrink-0 items-center justify-center rounded-menu outline-none after:absolute after:-inset-x-3 after:-inset-y-2",
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
