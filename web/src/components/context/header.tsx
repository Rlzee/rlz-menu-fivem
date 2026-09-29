type HeaderProps = {
  title: string;
};

export function ContextMenuHeader({ title }: HeaderProps) {
  return (
    <div className="bg-black flex items-center justify-start px-1.5 py-1 font-bold text-md text-white w-full rounded-t-menu">
      {title}
    </div>
  );
}
