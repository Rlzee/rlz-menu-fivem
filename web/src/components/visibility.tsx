import { useState, type ReactNode } from "react";
import { useNuiEvent } from "../hooks/useNuiEvent";
import { NUI_EVENT } from "../utils/nuiEvents";
import { VisibilityContext } from "./visibility-context";

type VisibilityData = {
  state: boolean;
};

export const VisibilityProvider = ({ children }: { children: ReactNode }) => {
  const [visible, setVisible] = useState(false);

  useNuiEvent<VisibilityData>(NUI_EVENT.setVisible, (data) => {
    setVisible(data.state);
  });

  return (
    <VisibilityContext.Provider value={{ visible, setVisible }}>
      {children}
    </VisibilityContext.Provider>
  );
};
