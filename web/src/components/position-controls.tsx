type PositionControl = {
  keys: string[];
  label: string;
};

const controls: PositionControl[] = [
  { keys: ["←", "↑", "↓", "→"], label: "Move" },
  { keys: ["Enter"], label: "Save" },
  { keys: ["Backspace"], label: "Cancel" },
];

export function PositionControls() {
  return (
    <div
      data-slot="position-controls"
      className="mt-(--menu-gap) flex items-center justify-center gap-3 rounded-b-menu bg-background-menu px-2 py-1 text-xs text-white"
    >
      {controls.map(({ keys, label }) => (
        <span key={label} className="flex items-center gap-1">
          {keys.map((key) => (
            <kbd
              key={key}
              className="inline-flex items-center justify-center rounded-[2px] bg-white/10 px-1 py-0.5 font-mono text-[10px] leading-none"
            >
              {key}
            </kbd>
          ))}

          <span className="text-white/70">{label}</span>
        </span>
      ))}
    </div>
  );
}
