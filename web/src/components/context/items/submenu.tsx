import {
  ContextMenuSub,
  ContextMenuSubContent,
  ContextMenuGroup,
} from "../../ui/context-menu";
import type { ContextMenuItem } from "./type";
import { ContextMenuRenderItems } from "../render-items";
import type { Color } from "../../../utils/color";
import { ContextSubTrigger } from "./context-sub-trigger";

type SubMenuProps = {
  id: string;
  label: string;
  disabled?: boolean;
  items?: ContextMenuItem[];
  hoverColor?: Color;
};

export function SubMenu({ id, label, disabled, items, hoverColor }: SubMenuProps) {
  return (
    <ContextMenuSub>
      <ContextSubTrigger id={id} disabled={disabled} hoverColor={hoverColor}>
        {label}
      </ContextSubTrigger>
      <ContextMenuSubContent>
        <ContextMenuGroup>
          {items && <ContextMenuRenderItems items={items} hoverColor={hoverColor} />}
        </ContextMenuGroup>
      </ContextMenuSubContent>
    </ContextMenuSub>
  );
}
