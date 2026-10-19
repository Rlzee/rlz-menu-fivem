/**
 * Single source of truth for the NUI contract between the web UI and the Lua
 * client scripts. The values are the `rlz_menu:*` action names understood by
 * both sides; referencing them here avoids string typos and documents every
 * event the menu system exchanges in one place.
 */
export const NUI_EVENT = {
  // Events received from Lua (via `useNuiEvent`).
  setData: "rlz_menu:setData",
  setVisible: "rlz_menu:setVisible",
  openSearch: "rlz_menu:openSearch",
  closeSearch: "rlz_menu:closeSearch",
  editPosition: "rlz_menu:editPosition",

  // Events sent to Lua (via `fetchNui`).
  navigate: "rlz_menu:navigate",
  hoverItem: "rlz_menu:hoverItem",
  leaveItem: "rlz_menu:leaveItem",
  selectButton: "rlz_menu:selectButton",
  toggleCheckbox: "rlz_menu:toggleCheckbox",
  selectRadio: "rlz_menu:selectRadio",
  changeList: "rlz_menu:changeList",
  changeSlider: "rlz_menu:changeSlider",
  changeLevel: "rlz_menu:changeLevel",
  goBack: "rlz_menu:goBack",
  savePosition: "rlz_menu:savePosition",
  resetPosition: "rlz_menu:resetPosition",
  submitSearch: "rlz_menu:submitSearch",
  cancelSearch: "rlz_menu:cancelSearch",
} as const;
