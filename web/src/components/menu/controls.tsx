import { cn } from "../../utils/cn";

export type ControlItem = {
  keys: string[];
  label: string;
};

type ControlsProps = {
  items: ControlItem[];
};

/** A keycap bar displayed under the menu to describe the available controls. */
export function Controls({ items }: ControlsProps) {
  return (
    <div
      data-slot="controls"
      className={cn(
        "flex flex-wrap items-center justify-center gap-x-3 gap-y-1",
        "rounded-b-menu bg-surface px-2 py-1 text-caption text-white",
      )}
    >
      {items.map(({ keys, label }) => (
        <span key={label} className="flex items-center gap-1">
          {keys.map((key) => (
            <kbd
              key={key}
              className="inline-flex items-center justify-center rounded-[2px] bg-key px-1 py-0.5 font-mono text-micro leading-none"
            >
              {key}
            </kbd>
          ))}

          <span className="text-text-muted">{label}</span>
        </span>
      ))}
    </div>
  );
}
