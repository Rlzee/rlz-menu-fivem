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

export type ContextMenuItem = ButtonItem | CheckboxItem;