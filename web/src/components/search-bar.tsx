import { useEffect, useRef, useState } from "react";
import { fetchNui } from "../utils/fetchNui";

import { Dialog, DialogContent, DialogTitle } from "./ui/dialog";

type SearchBarProps = {
  label: string;
};

export const SearchBar = ({ label }: SearchBarProps) => {
  const [value, setValue] = useState("");
  const inputRef = useRef<HTMLInputElement>(null);

  useEffect(() => {
    inputRef.current?.focus();
  }, []);

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
