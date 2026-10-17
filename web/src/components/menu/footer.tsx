import { cn } from "../../utils/cn";

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
        "flex h-auto items-center justify-start bg-surface py-2 px-2 text-white text-caption",
        roundedBottom && "rounded-b-menu",
      )}
    >
      {description}
    </div>
  );
}
