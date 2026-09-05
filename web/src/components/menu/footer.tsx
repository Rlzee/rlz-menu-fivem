type MenuFooterProps = {
  description?: string;
};

export function MenuFooter({ description }: MenuFooterProps) {
  return (
    <div data-slot="menu-footer" className="mt-0.5 flex h-auto items-center justify-start rounded-b-xs bg-black/60 p-2 text-white">
      {description}
    </div>
  );
};