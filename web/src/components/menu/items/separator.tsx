import { Separator } from "../../ui/separator";

type MenuSeparatorProps = {
  visible: boolean;
};

export function MenuSeparator({ visible }: MenuSeparatorProps) {
  return (
    <div
      data-slot="menu-separator"
      className="py-2 mx-1 flex items-center justify-center"
    >
      <Separator
        orientation="horizontal"
        className={visible ? "bg-white/20" : "bg-transparent"}
      />
    </div>
  );
}
