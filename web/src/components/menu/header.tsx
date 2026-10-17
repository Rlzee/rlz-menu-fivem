import { cn } from "../../utils/cn";
import type { MouseEventHandler, PointerEventHandler } from "react";

type MenuHeaderProps = {
  title: string;
  subtitle?: string;
  current: number;
  total: number;
  dragging?: boolean;
  onPointerDown?: PointerEventHandler<HTMLDivElement>;
  onDoubleClick?: MouseEventHandler<HTMLDivElement>;
};

export function MenuHeader({
  title,
  subtitle,
  current,
  total,
  dragging,
  onPointerDown,
  onDoubleClick,
}: MenuHeaderProps) {
  return (
    <div
      data-slot="menu-header"
      className={cn(
        "select-none touch-none",
        dragging ? "cursor-grabbing" : "cursor-grab",
      )}
      onPointerDown={onPointerDown}
      onDoubleClick={onDoubleClick}
    >
      <div
        data-slot="banner"
        className="flex h-16 items-center justify-center rounded-t-menu bg-accent"
      >
        <h1 className="text-title font-title text-white">
          {title}
        </h1>
      </div>

      <div className="flex h-8 text-body items-center justify-between bg-surface px-2 font-body text-white">
        <span className="uppercase">{subtitle}</span>
        <span>
          {current}
          <span className="px-0.5">/</span>
          {total}
        </span>
      </div>
    </div>
  );
}
