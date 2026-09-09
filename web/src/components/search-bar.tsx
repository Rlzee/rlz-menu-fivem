import { useEffect, useRef, useState } from "react";
import { fetchNui } from "../utils/fetchNui";

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
    <div className="fixed inset-0 z-50 flex items-start justify-center bg-black/40 p-2 pt-[35vh]">
      <form
        className="w-full max-w-xl rounded-menu bg-background-menu p-2"
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
    </div>
  );
};
