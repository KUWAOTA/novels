#!/usr/bin/env python3
from __future__ import annotations

import argparse
import csv
import socket
from datetime import datetime
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
LOG_PATH = ROOT / "taskManegement" / "logs" / "session_log.csv"


def main() -> None:
    parser = argparse.ArgumentParser(description="作業セッションを記録する")
    parser.add_argument("--minutes", type=int, default=60)
    parser.add_argument("--device", default=socket.gethostname())
    parser.add_argument("--location", default="office")
    parser.add_argument("--kind", default="focus")
    parser.add_argument("--note", default="")
    args = parser.parse_args()

    LOG_PATH.parent.mkdir(parents=True, exist_ok=True)
    needs_header = not LOG_PATH.exists() or LOG_PATH.stat().st_size == 0
    with LOG_PATH.open("a", encoding="utf-8", newline="") as fh:
        writer = csv.writer(fh)
        if needs_header:
            writer.writerow(["timestamp", "device", "location", "minutes", "kind", "note"])
        writer.writerow(
            [
                datetime.now().isoformat(timespec="minutes"),
                args.device,
                args.location,
                args.minutes,
                args.kind,
                args.note,
            ]
        )


if __name__ == "__main__":
    main()
