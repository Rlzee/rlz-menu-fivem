import * as React from "react";
import { ContextMenu as ContextMenuPrimitive } from "radix-ui";
import { Separator } from "./separator";

import { ChevronRight } from "lucide-react";
import { cn } from "cn";

export const ContextMenu: typeof ContextMenuPrimitive.Root =
  ContextMenuPrimitive.Root;

export const ContextMenuPortal: typeof ContextMenuPrimitive.Portal =
  ContextMenuPrimitive.Portal;

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
          "z-50 max-h-(--radix-context-menu-content-available-height) min-w-36 origin-(--radix-context-menu-content-transform-origin) overflow-x-hidden overflow-y-auto rounded-menu text-white duration-100",
          "data-[state=open]:animate-in data-[state=open]:fade-in-0 data-[state=open]:zoom-in-95 data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=closed]:zoom-out-95",
          "data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2 ",
          className,
        )}
        {...props}
      />
    </ContextMenuPrimitive.Portal>
  );
}

export function ContextMenuGroup({
  className,
  children,
  ...props
}: React.ComponentProps<typeof ContextMenuPrimitive.Group>) {
  return (
    <ContextMenuPrimitive.Group
      data-slot="context-menu-group"
      className={cn(
        "bg-background-menu w-full h-auto rounded-b-menu",
        className,
      )}
      {...props}
    >
      <div className="flex flex-col gap-(--item-menu-padding)">{children}</div>
    </ContextMenuPrimitive.Group>
  );
}

export function ContextMenuItem({
  className,
  inset,
  ...props
}: React.ComponentProps<typeof ContextMenuPrimitive.Item> & {
  inset?: boolean;
}) {
  return (
    <ContextMenuPrimitive.Item
      data-slot="context-menu-item"
      data-inset={inset}
      className={cn(
        "group/context-menu-item last:rounded-b-menu relative flex cursor-default items-center gap-1.5 px-1.5 py-1 text-sm outline-hidden select-none focus:bg-item-menu-background-hover data-inset:pl-7 data-disabled:pointer-events-none data-disabled:opacity-50 [&_svg]:pointer-events-none [&_svg]:shrink-0",
        className,
      )}
      {...props}
    />
  );
}

export function ContextMenuSeparator({
  className,
  ...props
}: React.ComponentProps<typeof ContextMenuPrimitive.Separator>) {
  return (
    <ContextMenuPrimitive.Separator
      data-slot="context-menu-separator"
      className={cn("px-1 w-full", className)}
      {...props}
    >
      <Separator />
    </ContextMenuPrimitive.Separator>
  );
}

export const ContextMenuSub: typeof ContextMenuPrimitive.Sub =
  ContextMenuPrimitive.Sub;

export function ContextMenuSubTrigger({
  className,
  inset,
  children,
  ...props
}: React.ComponentProps<typeof ContextMenuPrimitive.SubTrigger> & {
  inset?: boolean;
}) {
  return (
    <ContextMenuPrimitive.SubTrigger
      data-slot="context-menu-sub-trigger"
      data-inset={inset}
      className={cn(
        "flex cursor-default items-center gap-1.5 px-1.5 py-1 text-sm outline-hidden select-none focus:bg-item-menu-background-hover data-inset:pl-7 data-[state=open]:bg-item-menu-background-hover [&_svg]:pointer-events-none [&_svg]:shrink-0 [&_svg:not([class*='size-'])]:size-4",
        className,
      )}
      {...props}
    >
      {children}
      <ChevronRight className="ml-auto" />
    </ContextMenuPrimitive.SubTrigger>
  );
}

export function ContextMenuSubContent({
  className,
  ...props
}: React.ComponentProps<typeof ContextMenuPrimitive.SubContent>) {
  return (
    <ContextMenuPrimitive.SubContent
      data-slot="context-menu-sub-content"
      className={cn(
        "z-50 min-w-32 origin-(--radix-context-menu-content-transform-origin) overflow-hidden rounded-menu bg-background-menu text-white duration-100 mx-0.5",
        "data-[state=open]:animate-in data-[state=open]:fade-in-0 data-[state=open]:zoom-in-95 data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=closed]:zoom-out-95",
        "data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2",
        className,
      )}
      {...props}
    />
  );
}
