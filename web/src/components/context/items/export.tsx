import { ContextMenuButton } from "./button";
import { ContextMenuCheckbox } from "./checkbox";
import { ContextMenuSwitch } from "./switch";
import { ContextMenuSeparator } from "./separator";
import { SubMenu } from "./submenu";
import { ContextMenuRadio } from "./radio";

export const ContextMenuItems = {
  item: {
    Button: ContextMenuButton,
    Checkbox: ContextMenuCheckbox,
    Switch: ContextMenuSwitch,
    Separator: ContextMenuSeparator,
    SubMenu,
    Radio: ContextMenuRadio,
  },
};
