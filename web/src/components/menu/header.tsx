import { cn } from "cn";

type MenuHeaderProps = {
  title: string;
  subtitle?: string;
  current: number;
  total: number;
  color?: string;
};

export function MenuHeader({
  title,
  subtitle,
  current,
  total,
  color,
}: MenuHeaderProps) {
  return (
    <div data-slot="menu-header">
      <div
        data-slot="banner"
        className={cn(
          "flex h-16 items-center justify-center rounded-t-xs",
          color ? `bg-[${color}]` : "bg-[rgb(16_185_129_/_80%)]",
        )}
      >
        <h1 className="text-3xl font-bold text-white">{title}</h1>
      </div>

      <div className="flex h-8 items-center justify-between bg-black/60 px-2 text-white">
        <span>{subtitle}</span>
        <span>
          {current}/{total}
        </span>
      </div>
    </div>
  );
}