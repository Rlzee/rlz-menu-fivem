import React, { createContext, useContext, useState } from "react";
import { useNuiEvent } from "../hooks/useNuiEvent";

type VisibilityProviderValue = {
  contextVisible: boolean;
  menuVisible: boolean;
  setContextVisible: (visible: boolean) => void;
  setMenuVisible: (visible: boolean) => void;
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
  const [menuVisible, setMenuVisible] = useState(false);
  const [contextVisible, setContextVisible] = useState(false);

  useNuiEvent<VisibilityData>("rlz_menu:setVisible", (data) => {
    setMenuVisible(data.state);
  });

  return (
    <VisibilityContext.Provider
      value={{
        contextVisible,
        menuVisible,
        setContextVisible,
        setMenuVisible,
      }}
    >
      {children}
    </VisibilityContext.Provider>
  );
};