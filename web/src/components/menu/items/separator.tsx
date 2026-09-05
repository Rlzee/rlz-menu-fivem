export function MenuSeparator() {
  return (
    <div
      data-slot="menu-separator"
      className="py-2 mx-1 flex items-center justify-center"
    >
      <div className="w-full h-px bg-white/20" />
    </div>
  );
}
