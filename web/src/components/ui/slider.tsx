import type * as React from "react";
import { Slider as SliderPrimitive } from "radix-ui";

import { cn } from "../../utils/cn";

type SliderProps = React.ComponentProps<typeof SliderPrimitive.Root> & {
  trackClassName?: string;
  rangeClassName?: string;
  thumbClassName?: string;
};

export function Slider({
  className,
  trackClassName,
  rangeClassName,
  thumbClassName,
  value = [0],
  min = 0,
  max = 100,
  step = 1,
  ...props
}: SliderProps) {
  return (
    <SliderPrimitive.Root
      data-slot="slider"
      value={value}
      min={min}
      max={max}
      step={step}
      className={cn(
        "relative flex w-full select-none touch-none items-center data-[disabled]:opacity-50",
        className,
      )}
      {...props}
    >
      <SliderPrimitive.Track
        data-slot="slider-track"
        className={cn(
          "relative h-1 w-full grow overflow-hidden rounded-control bg-control",
          trackClassName,
        )}
      >
        <SliderPrimitive.Range
          data-slot="slider-range"
          className={cn("absolute h-full bg-anchor", rangeClassName)}
        />
      </SliderPrimitive.Track>
      {value.map((_, index) => (
        <SliderPrimitive.Thumb
          key={index}
          data-slot="slider-thumb"
          className={cn(
            "relative z-10 block size-3 shrink-0 rounded-full bg-white ring-0 outline-none",
            thumbClassName,
          )}
        />
      ))}
    </SliderPrimitive.Root>
  );
}
