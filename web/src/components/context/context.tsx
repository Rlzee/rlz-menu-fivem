import { useState } from "react";

import { useNuiEvent } from "../../hooks/useNuiEvent";

import { ContextView, type ContextMenuData } from "./context-view";

export function ContextMenu() {
  const [contextVisible, setContextVisible] = useState(false);
  const [context, SetContext] = useState<ContextMenuData>({
    type: "world",
    title: "",
    items: [],
    x: 0,
    y: 0,
  });

  useNuiEvent<ContextMenuData>("rlz_menu:context:setData", (data) => {
    SetContext(data);
  });
  useNuiEvent<{ state: boolean }>(
    "rlz_menu:context:setVisible",
    ({ state }) => setContextVisible(state),
  );

  if (!contextVisible) {
    return null;
  }

  return <ContextView context={context} />;
}
