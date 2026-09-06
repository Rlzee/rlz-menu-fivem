export type ButtonItem = {
  type: "button";
  label: string;
  anchor?: string;
  description?: string;
};

export type CheckboxItem = {
  type: "checkbox";
  label: string;
  description?: string;
  isChecked: boolean;
};

export type LabelItem = {
  type: "label";
  label: string;
};

export type SeparatorItem = {
  type: "separator";
};

export type MenuItem =
  | ButtonItem
  | CheckboxItem
  | LabelItem
  | SeparatorItem;