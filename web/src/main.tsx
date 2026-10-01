import { StrictMode } from "react";
import { createRoot } from "react-dom/client";
import { VisibilityProvider } from "./components/visibility";
import { debugData } from "./utils/debugData";

import "./index.css";
import App from "./app";

debugData([
  {
    action: "rlz_menu:context:setData",
    data: {
      type: "vehicle",
      title: "Vehicle",
      items: [
        {
          id: "1",
          type: "button",
          label: "Repair",
          selected: false,
          disabled: false,
        },
        {
          id: "2",
          type: "checkbox",
          label: "Delete",
          isChecked: false,
          disabled: false,
        },
        {
          id: "3",
          type: "switch",
          label: "Lock",
          isChecked: true,
          disabled: false,
        },
        {
          id: "4",
          type: "separator",
        },
        {
          id: "5",
          type: "button",
          label: "Close",
          selected: false,
          disabled: false,
        }
      ],
      x: 640,
      y: 360,
    },
  },
  {
    action: "rlz_menu:context:setVisible",
    data: { state: true },
  },
], 300);

createRoot(document.getElementById("root")!).render(
  <StrictMode>
    <VisibilityProvider>
      <App />
    </VisibilityProvider>
  </StrictMode>,
);
