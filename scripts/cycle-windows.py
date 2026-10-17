#!/usr/bin/env python3
import json
import subprocess
import sys

# Usage:
# ./cycle-center.py right
# ./cycle-center.py left
# ./cycle-center.py up
# ./cycle-center.py down

SW = 1920
SH = 1080


def mmsg(*args):
    return subprocess.check_output(
        ["mmsg", *args],
        text=True
    ).strip()


def get_windows():
    output = mmsg("get", "all-clients")
    data = json.loads(output)

    if isinstance(data, dict):
        data = data.get("clients", [])

    return [
        w for w in data
        if w.get("is_floating") and w.get("is_visible")
    ]


def center(window):
    return (
        window["x"] + window["width"] // 2,
        window["y"] + window["height"] // 2,
    )


def move_and_focus(windows, target):
    tx, ty = center(target)

    dx = SW // 2 - tx
    dy = SH // 2 - ty

    for window in windows:
        subprocess.run([
            "mmsg", "dispatch",
            f"movewin,{dx:+d},{dy:+d},client,{window['id']}"
        ], check=True)

    subprocess.run([
        "mmsg", "dispatch",
        f"focusid,client,{target['id']}"
    ], check=True)


def main():
    direction = sys.argv[1] if len(sys.argv) > 1 else "1"

    windows = get_windows()
    if not windows:
        return

    focused = next(
        (w for w in windows if w.get("is_focused")),
        None
    )

    if focused is None:
        data = json.loads(mmsg("get", "focusing-client"))
        focused_id = data.get("id") if isinstance(data, dict) else None
        focused = next(
            (w for w in windows if w["id"] == focused_id),
            None
        )

    if focused is None:
        return

    if direction in ("left", "right"):
        idx = next(
            i for i, w in enumerate(windows)
            if w["id"] == focused["id"]
        )
        if (direction == "left"):
            step = -1
        elif (direction == "right"):
            step = 1
        else:
            step = 0
        target = windows[(idx + step) % len(windows)]

    elif direction in ("up", "down"):
        cx, cy = center(focused)

        candidates = []
        for window in windows:
            if window["id"] == focused["id"]:
                continue

            wx, wy = center(window)

            if direction == "up" and wy < cy:
                candidates.append((window, wx, wy))
            elif direction == "down" and wy > cy:
                candidates.append((window, wx, wy))

        if not candidates:
            return

        # Choose the closest window vertically.
        # Use horizontal distance to break ties.
        target, _, _ = min(
            candidates,
            key=lambda item: (
                abs(item[2] - cy),
                abs(item[1] - cx)
            )
        )

    else:
        print("Usage: cycle-center.py [left|right|up|down]")
        return

    move_and_focus(windows, target)


if __name__ == "__main__":
    main()
