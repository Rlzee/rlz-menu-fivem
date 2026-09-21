export type ButtonItem = {
  id: string;
  type: "button";
  label: string;
  anchor?: string;
  anchorColor?: string;
  description?: string;
  onSelect?: () => void;
  submenu?: boolean;
  disabled?: boolean;
  color?: string;
};

export type CheckboxItem = {
  id: string;
  type: "checkbox";
  label: string;
  description?: string;
  isChecked: boolean;
  onChange?: (isChecked: boolean) => void;
  disabled?: boolean;
  color?: string;
};

export type SwitchItem = {
  id: string;
  type: "switch";
  label: string;
  description?: string;
  isChecked: boolean;
  onChange?: (isChecked: boolean) => void;
  disabled?: boolean;
  color?: string;
};

export type LabelItem = {
  id: string;
  type: "label";
  label: string;
};

export type SeparatorItem = {
  id: string;
  type: "separator";
  visible: boolean;
};

export type ListItem = {
  id: string;
  type: "list";
  label: string;
  description?: string;
  values: string[];
  index: number;
  value: string;
  onChange?: (selectedIndex: number, selectedValue: string) => void;
  disabled?: boolean;
  color?: string;
};

export type MenuItem =
  | ButtonItem
  | CheckboxItem
  | SwitchItem
  | LabelItem
  | SeparatorItem
  | ListItem;
