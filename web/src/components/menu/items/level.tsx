import { Item } from "../../item";
import { LockIcon } from "../../ui/lock";
import { cn } from "../../../utils/cn";

type MenuLevelProps = {
  label: string;
  value: number;
  max: number;
  selected?: boolean;
  disabled?: boolean;
};

export function MenuLevel({
  label,
  value,
  max,
  selected,
  disabled,
}: MenuLevelProps) {
  const filled = Math.max(0, Math.min(max, value));

  return (
    <Item
      selected={selected}
      disabled={disabled}
    >
      <span>{label}</span>
      {disabled ? (
        <LockIcon className="h-4 w-4" />
      ) : (
        <div className="flex items-center gap-1">
          {Array.from({ length: max }, (_, index) => index < filled).map(
            (on, index) => (
              <span
                key={index}
                className={cn(
                  "size-2 rounded-full transition-colors",
                  on
                    ? selected
                      ? "bg-white"
                      : "bg-anchor"
                    : "bg-control",
                )}
              />
            ),
          )}
        </div>
      )}
    </Item>
  );
}
