export type SearchBarData = {
  visible: boolean;
  label?: string;
  placeholder?: string;
};

type SearchBarProps = {
  label: string;
  value: string;
  placeholder?: string;
  onChange: (value: string) => void;
  onSubmit: () => void;
  onCancel: () => void;
};

function SearchBarViewport({ children }: { children: React.ReactNode }) {
  return (
    <div className="fixed inset-0 z-50 grid grid-rows-[1fr_auto_2fr] justify-items-center p-4">
      {children}
    </div>
  );
}

export function SearchBar({
  label,
  value,
  placeholder,
  onChange,
  onSubmit,
  onCancel,
}: SearchBarProps) {
  return (
    <SearchBarViewport>
      <div className="relative bg-black/60 rounded-menu grid gap-1 p-2 max-w-xl w-full">
        <span className="text-white text-sm">{label}</span>
        <input
          autoFocus
          type="text"
          value={value}
          onChange={(e) => onChange(e.target.value)}
          onKeyDown={(e) => {
            if (e.key === "Enter") {
              onSubmit();
            }
            if (e.key === "Escape") {
              onCancel();
            }
          }}
          className="bg-black text-white text-sm rounded-xs p-1 w-lg outline-none"
          placeholder={placeholder}
        />
      </div>
    </SearchBarViewport>
  );
}
