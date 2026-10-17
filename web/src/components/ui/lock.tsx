import type * as React from "react";

/** Solid (filled) padlock used as the disabled indicator. Color follows currentColor. */
export function LockIcon({ className, ...props }: React.ComponentProps<"svg">) {
  return (
    <svg
      xmlns="http://www.w3.org/2000/svg"
      viewBox="0 0 20 20"
      fill="currentColor"
      aria-hidden="true"
      className={className}
      {...props}
    >
      <path
        fillRule="evenodd"
        clipRule="evenodd"
        d="M10 1a4.5 4.5 0 0 0-4.5 4.5V7H5a2 2 0 0 0-2 2v6a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V9a2 2 0 0 0-2-2h-.5V5.5A4.5 4.5 0 0 0 10 1Zm3 6V5.5a3 3 0 1 0-6 0V7h6Z"
      />
    </svg>
  );
}
