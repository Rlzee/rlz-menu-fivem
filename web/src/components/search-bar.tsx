import { useEffect, useRef, useState } from "react";
import { fetchNui } from "../utils/fetchNui";
import { useNuiEvent } from "../hooks/useNuiEvent";

import { Dialog, DialogContent, DialogTitle } from "./ui/dialog";

export const SearchBar = () => {
  const [value, setValue] = useState("");
  const [label, setLabel] = useState<string | null>(null);
  const inputRef = useRef<HTMLInputElement>(null);

  useNuiEvent<{ label: string }>("rlz_menu:openSearch", ({ label }) => {
    setValue("");
    setLabel(label);
  });
  useNuiEvent("rlz_menu:closeSearch", () => setLabel(null));

  useEffect(() => {
    if (!label) {
      return;
    }

    inputRef.current?.focus();
  }, [label]);

  if (!label) {
    return null;
  }

  const submit = () => {
    fetchNui("rlz_menu:submitSearch", { value });
  };

  return (
    <Dialog open onOpenChange={(open) => !open && fetchNui("rlz_menu:cancelSearch")}>
      <DialogContent className="top-[35vh] translate-y-0 p-2 max-w-xl">
        <DialogTitle className="sr-only">{label}</DialogTitle>
        <form
          onSubmit={(event) => {
            event.preventDefault();
            submit();
          }}
        >
          <label className="mb-1 block text-sm text-white" htmlFor="rlz-search">
            {label}
          </label>
          <input
            ref={inputRef}
            id="rlz-search"
            className="w-full bg-black px-1 py-1 text-white outline-none"
            value={value}
            onChange={(event) => setValue(event.target.value)}
            onKeyDown={(event) => {
              event.stopPropagation();

              if (event.key === "Escape") {
                event.preventDefault();
                fetchNui("rlz_menu:cancelSearch");
              }
            }}
          />
        </form>
      </DialogContent>
    </Dialog>
  );
};
