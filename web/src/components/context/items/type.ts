export type ButtonItem = {
  id: string;
  type: "button";
  label: string;
  disabled?: boolean;
  onClick?: () => void;
};

export type CheckboxItem = {
  id: string;
  type: "checkbox";
  label: string;
  isChecked: boolean;
  disabled?: boolean;
  onToggle?: (checked: boolean) => void;
};

export type SwitchItem = {
  id: string;
  type: "switch";
  label: string;
  isChecked: boolean;
  disabled?: boolean;
  onToggle?: (checked: boolean) => void;
};

export type SeparatorItem = {
  id: string;
  type: "separator";
};

export type SubMenuItem = {
  id: string;
  type: "submenu";
  label: string;
  disabled?: boolean;
  items: ContextMenuItem[];
};

export type RadioItem = {
  id: string;
  type: "radio";
  isChecked: string;
  items: {
    id: string;
    label: string;
    disabled?: boolean;
  }[];
};

export type ContextMenuItem =
  | ButtonItem
  | CheckboxItem
  | SwitchItem
  | SeparatorItem
  | SubMenuItem
  | RadioItem;
