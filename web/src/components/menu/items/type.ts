export type ButtonItem = {
  type: "button";
  label: string;
  anchor?: string;
  description?: string;
  onSelect?: () => void;
};

export type CheckboxItem = {
  type: "checkbox";
  label: string;
  description?: string;
  isChecked: boolean;
  onChange?: (isChecked: boolean) => void;
};

export type LabelItem = {
  type: "label";
  label: string;
};

export type SeparatorItem = {
  type: "separator";
};

export type MenuItem = ButtonItem | CheckboxItem | LabelItem | SeparatorItem;
