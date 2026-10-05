import { useState } from "react";
import type * as React from "react";
import { ContextMenuItem } from "../../ui/context-menu";
import { toColorValue, type Color } from "../../../utils/color";

type ContextItemProps = React.ComponentProps<typeof ContextMenuItem> & {
  hoverColor?: Color;
};

export function ContextItem({ hoverColor, style, ...props }: ContextItemProps) {
  const [active, setActive] = useState(false);

  return (
    <ContextMenuItem
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
