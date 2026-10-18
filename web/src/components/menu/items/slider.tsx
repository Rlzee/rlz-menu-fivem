import { Item } from "../../item";
import { Slider } from "../../ui/slider";
import { LockIcon } from "../../ui/lock";

type MenuSliderProps = {
  label: string;
  percent: number;
  min: number;
  max: number;
  value: number;
  selected?: boolean;
  disabled?: boolean;
};

export function MenuSlider({
  label,
  percent,
  selected,
  disabled,
}: MenuSliderProps) {
  const clamped = Math.max(0, Math.min(100, percent));

  return (
    <Item
      selected={selected}
      disabled={disabled}
    >
      <span>{label}</span>
      {disabled ? (
        <LockIcon className="h-4 w-4" />
      ) : (
        <div className="flex items-center gap-2">
          <Slider
            value={[clamped]}
            aria-label={label}
            tabIndex={-1}
            className="w-28"
            rangeClassName={selected ? "bg-white" : undefined}
            thumbClassName={selected ? "bg-white" : undefined}
          />
          <span className="w-9 text-right text-value tabular-nums">
            {Math.round(clamped)}%
          </span>
        </div>
      )}
    </Item>
  );
}
