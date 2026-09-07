export type ButtonItem = {
  id: string;
  type: "button";
  label: string;
  anchor?: string;
  description?: string;
  onSelect?: () => void;
  submenu?: boolean;
  disabled?: boolean;
};

export type CheckboxItem = {
  id: string;
  type: "checkbox";
  label: string;
  description?: string;
  isChecked: boolean;
  onChange?: (isChecked: boolean) => void;
};

export type LabelItem = {
  id: string;
  type: "label";
  label: string;
};

export type SeparatorItem = {
  id: string;
  type: "separator";
};

export type ListItem = {
  id: string;
  type: "list";
  label: string;
  description?: string;
  values: string[];
  index: number;
  value: string;
};

export type MenuItem = ButtonItem | CheckboxItem | LabelItem | SeparatorItem | ListItem;
