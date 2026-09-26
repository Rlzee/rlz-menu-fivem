import * as React from "react";
import { ContextMenu as ContextMenuPrimitive } from "radix-ui";

import { cn } from "cn";

export const ContextMenu: typeof ContextMenuPrimitive.Root =
  ContextMenuPrimitive.Root;
export const ContextMenuPortal: typeof ContextMenuPrimitive.Portal =
  ContextMenuPrimitive.Portal;
export const ContextMenuGroup: typeof ContextMenuPrimitive.Group =
  ContextMenuPrimitive.Group;
export const ContextMenuSub: typeof ContextMenuPrimitive.Sub =
  ContextMenuPrimitive.Sub;
export const ContextMenuRadioGroup: typeof ContextMenuPrimitive.RadioGroup =
  ContextMenuPrimitive.RadioGroup;

export function ContextMenuTrigger({
  className,
  ...props
}: React.ComponentProps<typeof ContextMenuPrimitive.Trigger>) {
  return (
    <ContextMenuPrimitive.Trigger
      data-slot="context-menu-trigger"
      className={cn("select-none", className)}
      {...props}
    />
  );
}

export function ContextMenuContent({
  className,
  ...props
}: React.ComponentProps<typeof ContextMenuPrimitive.Content> & {
  side?: "top" | "right" | "bottom" | "left";
}) {
  return (
    <ContextMenuPrimitive.Portal>
      <ContextMenuPrimitive.Content
        data-slot="context-menu-content"
        className={cn(
          "z-50 max-h-(--radix-context-menu-content-available-height) min-w-36 origin-(--radix-context-menu-content-transform-origin) overflow-x-hidden overflow-y-auto rounded-menu bg-background-menu text-white duration-100",
          "data-[state=open]:animate-in data-[state=open]:fade-in-0 data-[state=open]:zoom-in-95 data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=closed]:zoom-out-95",
          "data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2 ",
          className,
        )}
        {...props}
      />
    </ContextMenuPrimitive.Portal>
  );
}