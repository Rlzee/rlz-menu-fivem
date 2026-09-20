import * as React from "react";
import { Slot as SlotPrimitive } from "radix-ui";

export function Slot({
  className,
  asChild,
  ...props
}: React.ComponentProps<"button"> & { asChild?: boolean }) {
  const Comp = asChild ? SlotPrimitive.Root : "button";
  return <Comp data-slot="slot" className={className} {...props} />;
}
