import { cn } from "cn";

type MenuFooterProps = {
  description?: string;
  /** Whether the footer keeps the bottom rounded corners. Disabled when the controls bar is displayed below it. */
  roundedBottom?: boolean;
};

export function MenuFooter({
  description,
  roundedBottom = true,
}: MenuFooterProps) {
  return (
    <div
      data-slot="menu-footer"
      className={cn(
        "flex h-auto items-center justify-start bg-background-menu py-1 px-2 text-white text-sm",
        roundedBottom && "rounded-b-menu",
      )}
    >
      {description}
    </div>
  );
}
