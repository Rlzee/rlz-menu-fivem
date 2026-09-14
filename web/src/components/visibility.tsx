import React, { createContext, useContext, useState } from "react";
import { useNuiEvent } from "../hooks/useNuiEvent";

type VisibilityProviderValue = {
  visible: boolean;
  contextVisible: boolean;

  setVisible: (visible: boolean) => void;
  setContextVisible: (visible: boolean) => void;
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
  const [contextVisible, setContextVisible] = useState(false);

  useNuiEvent<VisibilityData>("rlz_menu:setVisible", (data) => {
    setVisible(data.state);
  });

  useNuiEvent<VisibilityData>("rlz_context:setVisible", (data) => {
    setContextVisible(data.state);
  });

  return (
    <VisibilityContext.Provider
      value={{
        visible,
        contextVisible,
        setVisible,
        setContextVisible,
      }}
    >
      {children}
    </VisibilityContext.Provider>
  );
};
