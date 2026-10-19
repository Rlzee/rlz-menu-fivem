import {
  type CSSProperties,
  type MouseEventHandler,
  type PointerEvent as ReactPointerEvent,
  type PointerEventHandler,
  type RefObject,
  useCallback,
  useEffect,
  useRef,
  useState,
} from "react";
import { fetchNui } from "../utils/fetchNui";
import { NUI_EVENT } from "../utils/nuiEvents";

type MenuPosition = {
  x: number;
  y: number;
};

type UseMenuDragProps = {
  menuId?: string;
  savedX?: number;
  savedY?: number;
  /** Whether the menu is currently displayed. */
  active?: boolean;
};

type UseMenuDragResult = {
  containerRef: RefObject<HTMLDivElement | null>;
  containerStyle: CSSProperties | undefined;
  isDragging: boolean;
  isMoveMode: boolean;
  startMoveMode: (applyToAll?: boolean) => void;
  onHeaderPointerDown: PointerEventHandler<HTMLDivElement>;
  onHeaderDoubleClick: MouseEventHandler<HTMLDivElement>;
};

const DRAG_THRESHOLD = 2;

const clamp = (value: number, min: number, max: number) => {
  return Math.min(Math.max(value, min), max);
};

const toRatio = (value: number, max: number) => {
  return Math.round(clamp(value / max, 0, 1) * 10000) / 10000;
};

/**
 * Makes the menu draggable by its header anywhere on the screen.
 * The position is stored as ratios between 0 and 1 (resolution
 * independent) and saved through the `rlz_menu:savePosition` NUI
 * callback when the drag ends. It is restored when the displayed
 * menu changes.
 */
export function useMenuDrag({
  menuId,
  savedX,
  savedY,
  active = true,
}: UseMenuDragProps): UseMenuDragResult {
  const containerRef = useRef<HTMLDivElement>(null);
  const [position, setPosition] = useState<MenuPosition | null>(null);
  const [isDragging, setIsDragging] = useState(false);
  const [isMoveMode, setIsMoveMode] = useState(false);
  const preMoveRef = useRef<MenuPosition | null>(null);
  const moveSizeRef = useRef<{ width: number; height: number } | null>(null);
  const applyToAllRef = useRef(false);
  const [syncedMenu, setSyncedMenu] = useState<{
    menuId?: string;
    savedX?: number;
    savedY?: number;
  }>({ menuId, savedX, savedY });

  // Restore the saved position when the displayed menu changes
  if (
    syncedMenu.menuId !== menuId ||
    syncedMenu.savedX !== savedX ||
    syncedMenu.savedY !== savedY
  ) {
    setSyncedMenu({ menuId, savedX, savedY });
    setIsMoveMode(false);

    if (savedX == null || savedY == null) {
      setPosition(null);
    } else {
      setPosition({
        x: savedX * window.innerWidth,
        y: savedY * window.innerHeight,
      });
    }
  }

  // Leave the edit mode when the menu is closed
  if (!active && isMoveMode) {
    setIsMoveMode(false);
  }

  const resetPosition = useCallback(() => {
    setPosition(null);

    if (!menuId) {
      return;
    }

    fetchNui(NUI_EVENT.resetPosition, { menuId });
  }, [menuId]);

  const startMoveMode = useCallback(
    (applyToAll = false) => {
      const container = containerRef.current;

      if (!container) {
        return;
      }

      const rect = container.getBoundingClientRect();

      preMoveRef.current = position;
      moveSizeRef.current = { width: rect.width, height: rect.height };
      applyToAllRef.current = applyToAll;

      if (position == null) {
        setPosition({
          x: clamp(rect.left, 0, window.innerWidth - rect.width),
          y: clamp(rect.top, 0, window.innerHeight - rect.height),
        });
      }

      setIsMoveMode(true);
    },
    [position],
  );

  // Keyboard edition of the position: arrows to nudge the menu,
  // Enter to save and Backspace to cancel. Listened on the capture
  // phase so the menu navigation ignores the pressed keys.
  useEffect(() => {
    if (!isMoveMode) {
      return;
    }

    const size = moveSizeRef.current;

    if (!size) {
      return;
    }

    const handleKeyDown = (event: KeyboardEvent) => {
      const step = 0.01;
      let handled = true;

      switch (event.key) {
        case "ArrowLeft":
        case "ArrowRight":
        case "ArrowUp":
        case "ArrowDown": {
          const deltaX =
            event.key === "ArrowLeft"
              ? -step
              : event.key === "ArrowRight"
                ? step
                : 0;
          const deltaY =
            event.key === "ArrowUp"
              ? -step
              : event.key === "ArrowDown"
                ? step
                : 0;

          setPosition((current) => {
            if (!current) {
              return current;
            }

            return {
              x: clamp(
                current.x + deltaX * window.innerWidth,
                0,
                window.innerWidth - size.width,
              ),
              y: clamp(
                current.y + deltaY * window.innerHeight,
                0,
                window.innerHeight - size.height,
              ),
            };
          });

          fetchNui(NUI_EVENT.navigate);

          break;
        }

        case "Enter": {
          if (menuId && position) {
            fetchNui(NUI_EVENT.savePosition, {
              menuId,
              applyToAll: applyToAllRef.current,
              x: toRatio(position.x, window.innerWidth),
              y: toRatio(position.y, window.innerHeight),
            });
          }

          setIsMoveMode(false);

          break;
        }

        case "Backspace":
        case "Escape": {
          setPosition(preMoveRef.current);
          setIsMoveMode(false);

          break;
        }

        default: {
          handled = false;
        }
      }

      if (handled) {
        event.preventDefault();
        event.stopPropagation();
      }
    };

    window.addEventListener("keydown", handleKeyDown, true);

    return () => {
      window.removeEventListener("keydown", handleKeyDown, true);
    };
  }, [isMoveMode, menuId, position]);

  const onHeaderPointerDown = useCallback(
    (event: ReactPointerEvent<HTMLDivElement>) => {
      if (event.button !== 0) {
        return;
      }

      const container = containerRef.current;

      if (!container) {
        return;
      }

      event.preventDefault();
      event.currentTarget.setPointerCapture(event.pointerId);

      const rect = container.getBoundingClientRect();
      const startX = event.clientX;
      const startY = event.clientY;
      let hasMoved = false;
      let latestX = rect.left;
      let latestY = rect.top;

      setIsDragging(true);

      const handlePointerMove = (moveEvent: PointerEvent) => {
        const deltaX = moveEvent.clientX - startX;
        const deltaY = moveEvent.clientY - startY;

        if (
          !hasMoved &&
          Math.abs(deltaX) < DRAG_THRESHOLD &&
          Math.abs(deltaY) < DRAG_THRESHOLD
        ) {
          return;
        }

        hasMoved = true;

        latestX = clamp(
          rect.left + deltaX,
          0,
          window.innerWidth - rect.width,
        );
        latestY = clamp(
          rect.top + deltaY,
          0,
          window.innerHeight - rect.height,
        );

        setPosition({ x: latestX, y: latestY });
      };

      const handlePointerUp = () => {
        window.removeEventListener("pointermove", handlePointerMove);
        window.removeEventListener("pointerup", handlePointerUp);
        window.removeEventListener("pointercancel", handlePointerUp);
        setIsDragging(false);

        if (!hasMoved) {
          return;
        }

        if (!menuId) {
          return;
        }

        fetchNui(NUI_EVENT.savePosition, {
          menuId,
          x: toRatio(latestX, window.innerWidth),
          y: toRatio(latestY, window.innerHeight),
        });
      };

      window.addEventListener("pointermove", handlePointerMove);
      window.addEventListener("pointerup", handlePointerUp);
      window.addEventListener("pointercancel", handlePointerUp);
    },
    [menuId],
  );

  const containerStyle: CSSProperties | undefined = position
    ? {
        position: "fixed",
        left: position.x,
        top: position.y,
      }
    : undefined;

  return {
    containerRef,
    containerStyle,
    isDragging,
    isMoveMode,
    startMoveMode,
    onHeaderPointerDown,
    onHeaderDoubleClick: resetPosition,
  };
}
