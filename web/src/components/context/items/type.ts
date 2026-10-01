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

export type ContextMenuItem =
  | ButtonItem
  | CheckboxItem
  | SwitchItem
  | SeparatorItem;
