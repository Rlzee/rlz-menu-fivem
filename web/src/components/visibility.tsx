import React, { createContext, useContext, useState } from "react";
import { useNuiEvent } from "../hooks/useNuiEvent";

type VisibilityProviderValue = {
  setVisible: (visible: boolean) => void;
  visible: boolean;
};

type VisibilityData = {
  state: boolean;
};

const VisibilityContext = createContext<VisibilityProviderValue | null>(null);

export const useVisibility = (): VisibilityProviderValue => {
  const ctx = useContext(VisibilityContext);

  if (!ctx) {
    throw new Error("useVisibility must be used within a VisibilityProvider");
  }

  return ctx;
};

export const VisibilityProvider = ({
  children,
}: {
  children: React.ReactNode;
}) => {
  const [visible, setVisible] = useState(false);

  useNuiEvent<VisibilityData>("rlz_menu:setVisible", (data) => {
    setVisible(data.state);
  });

  return (
    <VisibilityContext.Provider value={{ visible, setVisible }}>
      {children}
    </VisibilityContext.Provider>
  );
};