import {
  ContextMenuSub,
  ContextMenuSubTrigger,
  ContextMenuSubContent,
  ContextMenuGroup,
} from "../../ui/context-menu";
import type { ContextMenuItem, SubMenuItem } from "./type";
import { ContextMenuRenderItems } from "../render-items";

type SubMenuProps = {
  id: string;
  label: string;
  disabled?: boolean;
  items?: Exclude<ContextMenuItem, SubMenuItem>[];
};

export function SubMenu({ id, label, disabled, items }: SubMenuProps) {
  return (
    <ContextMenuSub>
      <ContextMenuSubTrigger id={id} disabled={disabled}>
        {label}
      </ContextMenuSubTrigger>
      <ContextMenuSubContent>
        <ContextMenuGroup>
          {items && <ContextMenuRenderItems items={items} />}
        </ContextMenuGroup>
      </ContextMenuSubContent>
    </ContextMenuSub>
  );
}
