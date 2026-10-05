import { useState } from "react";
import type * as React from "react";
import { ContextMenuSubTrigger } from "../../ui/context-menu";
import { toColorValue, type Color } from "../../../utils/color";

type ContextSubTriggerProps = React.ComponentProps<typeof ContextMenuSubTrigger> & {
  hoverColor?: Color;
};

export function ContextSubTrigger({
  hoverColor,
  style,
  ...props
}: ContextSubTriggerProps) {
  const [active, setActive] = useState(false);

  return (
    <ContextMenuSubTrigger
      {...props}
      style={{
        ...style,
        background: active && hoverColor
          ? toColorValue(hoverColor, 0.55)
          : style?.background,
      }}
      onFocus={(event) => {
        setActive(true);
        props.onFocus?.(event);
      }}
      onBlur={(event) => {
        setActive(false);
        props.onBlur?.(event);
      }}
      onPointerEnter={(event) => {
        setActive(true);
        props.onPointerEnter?.(event);
      }}
      onPointerLeave={(event) => {
        setActive(false);
        props.onPointerLeave?.(event);
      }}
    />
  );
}
