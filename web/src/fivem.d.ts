// Globals injected by the FiveM CEF/NUI host. Declared optionally so the app
// can run in a regular browser during development without them present.
export {};

declare global {
  interface Window {
    /** Present only inside the FiveM NUI host. */
    invokeNative?: (name: string, params: string) => void;
    /** Returns the resource name used to build NUI callback URLs. */
    GetParentResourceName?: () => string;
  }
}
