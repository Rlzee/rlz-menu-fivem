type MenuFooterProps = {
  description?: string;
};

export function MenuFooter({ description }: MenuFooterProps) {
  return (
    <div
      data-slot="menu-footer"
      className="flex h-auto items-center justify-start rounded-b-menu bg-background-menu py-1 px-2 text-white text-sm"
    >
      {description}
    </div>
  );
}
