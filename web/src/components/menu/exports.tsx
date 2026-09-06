import { MenuContent } from "./content";
import { MenuFooter } from "./footer";
import { MenuHeader } from "./header";

// Items
import { MenuButton } from "./items/button";
import { MenuLabel } from "./items/label";
import { MenuSeparator } from "./items/separator";
import { MenuCheckbox } from "./items/checkbox";

export const Menu = {
  Header: MenuHeader,
  Content: MenuContent,
  Footer: MenuFooter,

  Item: {
    Button: MenuButton,
    Label: MenuLabel,
    Checkbox: MenuCheckbox,
    Separator: MenuSeparator,
  },
};