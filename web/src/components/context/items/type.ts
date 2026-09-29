export type ButtonItem = {
  id: string;
  type: "button";
  label: string;
  selected?: boolean;
  disabled?: boolean;
  onSelect?: () => void;
};

export type ContextMenuItem = ButtonItem;