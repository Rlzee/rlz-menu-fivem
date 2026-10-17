import { cn } from "../../utils/cn"
import { ReloadIcon } from "@radix-ui/react-icons"

function Spinner({ className, ...props }: React.ComponentProps<typeof ReloadIcon>) {
  return (
    <ReloadIcon
      data-slot="spinner"
      role="status"
      aria-label="Loading"
      className={cn("size-4 animate-spin", className)}
      {...props}
    />
  )
}

export { Spinner }
