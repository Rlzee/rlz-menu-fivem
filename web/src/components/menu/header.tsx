import { cn } from "cn";
import { withOpacity } from "../../utils/color";

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
          "flex h-16 items-center justify-center rounded-t-menu",
          !color || color === "default" ? "bg-menu" : "bg-transparent",
        )}
        style={
          color && color !== "default"
            ? { backgroundColor: withOpacity(color, 0.8) }
            : undefined
        }
      >
        <h1 className="text-3xl font-bold text-white">{title}</h1>
      </div>

      <div className="flex h-8 items-center justify-between bg-background-menu px-2 text-white">
        <span>{subtitle}</span>
        <span>
          {current}/{total}
        </span>
      </div>
    </div>
  );
}
