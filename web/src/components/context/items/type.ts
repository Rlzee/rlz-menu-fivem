export type ButtonItem = {
  id: string;
  type: "button";
  label: string;
  disabled?: boolean; 
  onClick?: () => void;
};

export type ContextMenuItem = ButtonItem;