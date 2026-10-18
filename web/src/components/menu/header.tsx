import { cn } from "../../utils/cn";
import type { CSSProperties, MouseEventHandler, PointerEventHandler } from "react";

type MenuHeaderProps = {
  title: string;
  subtitle?: string;
  /** Custom banner image path/URL; when set it replaces the colored banner. */
  banner?: string;
  current: number;
  total: number;
  dragging?: boolean;
  onPointerDown?: PointerEventHandler<HTMLDivElement>;
  onDoubleClick?: MouseEventHandler<HTMLDivElement>;
};

export function MenuHeader({
  title,
  subtitle,
  banner,
  current,
  total,
  dragging,
  onPointerDown,
  onDoubleClick,
}: MenuHeaderProps) {
  const hasBanner = Boolean(banner);
  const bannerStyle: CSSProperties | undefined = hasBanner
    ? {
        backgroundImage: `url(${JSON.stringify(banner)})`,
      }
    : undefined;

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
        style={bannerStyle}
        className={cn(
          "relative flex h-16 items-center justify-center rounded-t-menu",
          hasBanner && "bg-cover bg-center bg-no-repeat",
          !hasBanner && "bg-menu-banner",
        )}
      >
        {title ? (
          <h1 className="text-title font-title text-white tracking-wide drop-shadow-[0_1px_2px_rgba(0,0,0,0.6)]">
            {title}
          </h1>
        ) : null}
        <div className="pointer-events-none absolute inset-x-0 bottom-0 h-[2px] bg-[linear-gradient(90deg,transparent,var(--color-anchor),transparent)]" />
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
