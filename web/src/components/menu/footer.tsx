type MenuFooterProps = {
  description?: string;
};

export function MenuFooter({ description }: MenuFooterProps) {
  return (
    <div
      data-slot="menu-footer"
      className="flex h-auto items-center justify-start rounded-b-menu bg-background-menu p-2 text-white"
    >
      {description}
    </div>
  );
}
