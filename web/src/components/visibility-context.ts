import { createContext, useContext } from "react";

export type VisibilityProviderValue = {
  setVisible: (visible: boolean) => void;
  visible: boolean;
};

export const VisibilityContext = createContext<VisibilityProviderValue | null>(
  null,
);

export const useVisibility = (): VisibilityProviderValue => {
  const ctx = useContext(VisibilityContext);

  if (!ctx) {
    throw new Error("useVisibility must be used within a VisibilityProvider");
  }

  return ctx;
};
