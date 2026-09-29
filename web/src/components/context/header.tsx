type HeaderProps = {
  title: string;
};

export function ContextHeader({ title }: HeaderProps) {
  return (
    <div className="bg-black flex items-center justify-start px-2 py-1 font-bold text-md text-white w-full">
      {title}
    </div>
  );
}
