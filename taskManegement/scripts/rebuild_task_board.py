#!/usr/bin/env python3
from __future__ import annotations

import json
import re
import csv
from dataclasses import dataclass, field
from datetime import date, datetime, timedelta
from pathlib import Path
from typing import Iterable


ROOT = Path(__file__).resolve().parents[2]
TASK_DIR = ROOT / "taskManegement"


@dataclass
class Task:
    title: str
    area: str
    priority: str
    effort_minutes: int
    energy: str
    source_path: str
    source_anchor: str | None = None
    note: str | None = None
    due_date: date | None = None
    tags: list[str] = field(default_factory=list)
    score: int = 0

    def source_label(self) -> str:
        if self.source_anchor:
            return f"{self.source_path} ({self.source_anchor})"
        return self.source_path


@dataclass
class SessionEntry:
    timestamp: datetime
    device: str
    location: str
    minutes: int
    kind: str
    note: str


def load_json(path: Path):
    with path.open("r", encoding="utf-8") as fh:
        return json.load(fh)


def load_session_entries(path: Path) -> list[SessionEntry]:
    if not path.exists():
        return []
    entries: list[SessionEntry] = []
    with path.open("r", encoding="utf-8", newline="") as fh:
        reader = csv.DictReader(fh)
        for row in reader:
            if not row.get("timestamp"):
                continue
            entries.append(
                SessionEntry(
                    timestamp=datetime.fromisoformat(row["timestamp"]),
                    device=row.get("device", ""),
                    location=row.get("location", ""),
                    minutes=int(row.get("minutes", "0") or 0),
                    kind=row.get("kind", ""),
                    note=row.get("note", ""),
                )
            )
    entries.sort(key=lambda entry: entry.timestamp, reverse=True)
    return entries


def parse_jp_date(fragment: str, year_hint: int) -> date | None:
    match = re.search(r"(?:(\d{4})年)?\s*(\d{1,2})月(\d{1,2})日", fragment)
    if not match:
        return None
    year = int(match.group(1) or year_hint)
    month = int(match.group(2))
    day = int(match.group(3))
    return date(year, month, day)


def section_text(lines: list[str], start: int) -> list[str]:
    collected: list[str] = []
    for line in lines[start + 1 :]:
        if line.startswith("## "):
            break
        collected.append(line)
    return collected


def score_task(task: Task, today: date) -> int:
    score = 0
    priority_bonus = {"high": 80, "medium": 45, "low": 20}
    energy_bonus = {"high": 10, "medium": 6, "low": 2}
    area_bonus = {"school": 32, "constrain": 12, "reading": 8, "system": 6, "manual": 4}
    score += priority_bonus.get(task.priority, 0)
    score += energy_bonus.get(task.energy, 0)
    score += area_bonus.get(task.area, 0)
    if task.due_date:
        days = (task.due_date - today).days
        if days < 0:
            score += 120
        elif days == 0:
            score += 100
        elif days <= 2:
            score += 70
        elif days <= 7:
            score += 40
        elif days <= 14:
            score += 20
    if "unlock" in task.tags:
        score += 8
    if "routine" in task.tags:
        score -= 8
    return score


def parse_school_prepare(path: Path, area: str, today: date) -> list[Task]:
    text = path.read_text(encoding="utf-8")
    lines = text.splitlines()
    event_dates: list[date] = []
    for line in lines[:20]:
        parsed = parse_jp_date(line, today.year)
        if parsed and parsed > today:
            event_dates.append(parsed)
    first_event = min(event_dates) if event_dates else today + timedelta(days=5)
    second_event = max(event_dates) if len(event_dates) >= 2 else first_event + timedelta(days=9)
    task_sections = {
        "まず先に決めておくこと",
        "3月15日までに済ませておいた方がよい準備",
        "3月15日から3月24日までにやると良いこと",
        "当日に聞けると有益な質問例",
        "見学後、最終的にどう比較すると決めやすいか",
    }

    tasks: list[Task] = []
    current_h2 = ""
    for idx, line in enumerate(lines):
        if line.startswith("## "):
            current_h2 = line[3:].strip()
            continue
        if current_h2 not in task_sections:
            continue
        if not line.startswith("### "):
            continue
        title = line[4:].strip()
        note_lines = []
        for candidate in lines[idx + 1 : idx + 6]:
            if not candidate.strip():
                continue
            if candidate.startswith("#"):
                break
            stripped = candidate.strip()
            if stripped.startswith("- "):
                continue
            note_lines.append(stripped)
        note = " ".join(note_lines[:1]) if note_lines else None
        due_date = None
        priority = "medium"
        effort = 45
        if current_h2 == "まず先に決めておくこと":
            due_date = first_event - timedelta(days=1)
            priority = "high"
            effort = 35
        elif current_h2 == "3月15日までに済ませておいた方がよい準備":
            due_date = first_event - timedelta(days=1)
            priority = "high"
            effort = 30
        elif current_h2 == "3月15日から3月24日までにやると良いこと":
            due_date = second_event - timedelta(days=1)
            priority = "medium"
            effort = 30
        elif current_h2 == "当日に聞けると有益な質問例":
            due_date = first_event - timedelta(days=1)
            priority = "high"
            effort = 20
        elif current_h2 == "見学後、最終的にどう比較すると決めやすいか":
            due_date = second_event - timedelta(days=1)
            priority = "medium"
            effort = 20
        task_title = f"学校準備: {title}"
        tasks.append(
            Task(
                title=task_title,
                area=area,
                priority=priority,
                effort_minutes=effort,
                energy="low" if effort <= 30 else "medium",
                source_path=str(path.relative_to(ROOT)),
                source_anchor=title,
                note=note,
                due_date=due_date,
                tags=["school"],
            )
        )
    return dedupe_tasks(tasks)


def parse_constrain_writing_issues(path: Path, area: str, today: date) -> list[Task]:
    text = path.read_text(encoding="utf-8")
    lines = text.splitlines()
    tasks: list[Task] = []
    current_priority = "medium"
    current_due = today + timedelta(days=14)
    for line in lines:
        if "## 🔴 CRITICAL" in line:
            current_priority = "high"
            current_due = today + timedelta(days=7)
        elif "## 🟠 IMPORTANT" in line:
            current_priority = "medium"
            current_due = today + timedelta(days=21)
        elif line.startswith("### "):
            title = re.sub(r"^\d+\.\s*", "", line[4:].strip())
            tasks.append(
                Task(
                    title=f"Constrain 設定決め: {title}",
                    area=area,
                    priority=current_priority,
                    effort_minutes=45 if current_priority == "high" else 60,
                    energy="medium",
                    source_path=str(path.relative_to(ROOT)),
                    source_anchor=title,
                    note="執筆の詰まりを解消するための設定決定",
                    due_date=current_due,
                    tags=["unlock", "writing_issue"],
                )
            )
    return tasks


def parse_constrain_setting_handover(path: Path, area: str, today: date) -> list[Task]:
    text = path.read_text(encoding="utf-8")
    lines = text.splitlines()
    tasks: list[Task] = []
    current_priority = "medium"
    for line in lines:
        if "### 優先度 高" in line:
            current_priority = "high"
        elif "### 優先度 中" in line:
            current_priority = "medium"
        elif line.startswith("#### `"):
            match = re.match(r"#### `([^`]+)`\s+—\s+(.+?)(?:（目標:\s*(\d+)個）)?$", line)
            if not match:
                continue
            file_name, description, target_count = match.groups()
            title = f"Constrain アイデア補充: {file_name}"
            note = description
            if target_count:
                note = f"{description} / 目標 {target_count} 個"
            tasks.append(
                Task(
                    title=title,
                    area=area,
                    priority=current_priority,
                    effort_minutes=90 if current_priority == "high" else 75,
                    energy="high" if current_priority == "high" else "medium",
                    source_path=str(path.relative_to(ROOT)),
                    source_anchor=file_name,
                    note=note,
                    due_date=today + timedelta(days=21 if current_priority == "high" else 35),
                    tags=["creative_backlog"],
                )
            )
    return tasks


def parse_manual_markdown(path: Path, area: str, today: date) -> list[Task]:
    text = path.read_text(encoding="utf-8")
    tasks: list[Task] = []
    for line in text.splitlines():
        if not line.startswith("- [ ] "):
            continue
        raw = line[6:].strip()
        segments = [segment.strip() for segment in raw.split("|")]
        title = segments[0]
        meta = {}
        for segment in segments[1:]:
            if ":" not in segment:
                continue
            key, value = segment.split(":", 1)
            meta[key.strip()] = value.strip()
        due = None
        if meta.get("due"):
            due = datetime.strptime(meta["due"], "%Y-%m-%d").date()
        tasks.append(
            Task(
                title=title,
                area=meta.get("area", area),
                priority=meta.get("priority", "medium"),
                effort_minutes=int(meta.get("effort", "30")),
                energy=meta.get("energy", "medium"),
                source_path=str(path.relative_to(ROOT)),
                note=meta.get("note"),
                due_date=due,
                tags=["manual"],
            )
        )
    return tasks


def dedupe_tasks(tasks: Iterable[Task]) -> list[Task]:
    deduped: dict[tuple[str, str], Task] = {}
    for task in tasks:
        key = (task.title, task.source_path)
        deduped[key] = task
    return list(deduped.values())


def build_routine_tasks(profile: dict, today: date) -> list[Task]:
    tasks: list[Task] = []
    for item in profile.get("routine_tasks", []):
        cadence = item.get("cadence", "weekly")
        instances = 1
        if cadence == "twice_weekly":
            instances = 2
        elif cadence == "three_times_weekly":
            instances = 3
        for index in range(instances):
            due_offset = 6 if cadence == "weekly" else min(6, 1 + index * 2)
            tasks.append(
                Task(
                    title=item["title"] if instances == 1 else f"{item['title']} #{index + 1}",
                    area=item["area"],
                    priority=item["priority"],
                    effort_minutes=item["effort_minutes"],
                    energy=item["energy"],
                    source_path="taskManegement/config/schedule_profile.json",
                    note=f"定例タスク ({cadence})",
                    due_date=today + timedelta(days=due_offset),
                    tags=["routine"],
                )
            )
    return tasks


def build_continuity_tasks(profile: dict, sessions: list[SessionEntry], today: date) -> list[Task]:
    guard = profile.get("continuity_guard", {})
    if not guard.get("enabled"):
        return []
    if today.weekday() >= 5:
        return []
    if any(entry.timestamp.date() == today for entry in sessions):
        return []
    return [
        Task(
            title=guard.get("fallback_title", "会社で1時間だけ続ける"),
            area="system",
            priority="high",
            effort_minutes=int(guard.get("fallback_minutes", 60)),
            energy="medium",
            source_path="taskManegement/logs/session_log.csv",
            note="今日は作業ログがないため、最低ラインとして会社で1時間だけ継続する",
            due_date=today,
            tags=["continuity", "office"],
        )
    ]


def load_tasks(today: date, sessions: list[SessionEntry]) -> list[Task]:
    config = load_json(TASK_DIR / "config" / "task_sources.json")
    profile = load_json(TASK_DIR / "config" / "schedule_profile.json")
    tasks: list[Task] = []
    parser_map = {
        "school_prepare": parse_school_prepare,
        "constrain_writing_issues": parse_constrain_writing_issues,
        "constrain_setting_handover": parse_constrain_setting_handover,
        "manual_markdown": parse_manual_markdown,
    }
    for item in config:
        parser = parser_map[item["parser"]]
        path = ROOT / item["path"]
        tasks.extend(parser(path, item["area"], today))
    tasks.extend(build_routine_tasks(profile, today))
    tasks.extend(build_continuity_tasks(profile, sessions, today))
    for task in tasks:
        task.score = score_task(task, today)
    tasks.sort(key=lambda task: (-task.score, task.due_date or date.max, task.title))
    return tasks


def slot_minutes(slot: dict) -> int:
    start = datetime.strptime(slot["start"], "%H:%M")
    end = datetime.strptime(slot["end"], "%H:%M")
    return int((end - start).seconds / 60)


def build_week_schedule(tasks: list[Task], profile: dict, today: date):
    remaining = [task for task in tasks if not task.due_date or task.due_date >= today - timedelta(days=1)]
    plan = []
    for offset in range(7):
        day = today + timedelta(days=offset)
        if day.weekday() < 5:
            slots = profile["weekday_slots"]
        else:
            slots = profile["weekend_slots"]
        day_plan = []
        for slot in slots:
            chosen = None
            for task in remaining:
                if task.effort_minutes > slot_minutes(slot) + 20:
                    continue
                if slot["energy"] == "low" and task.energy == "high":
                    continue
                if slot["energy"] == "medium" and task.energy == "high" and slot_minutes(slot) < 80:
                    continue
                chosen = task
                break
            if chosen:
                remaining.remove(chosen)
            day_plan.append((slot, chosen))
        plan.append((day, day_plan))
    return plan


def render_board(tasks: list[Task], sessions: list[SessionEntry], today: date) -> str:
    lines = [
        "# Task Board",
        "",
        f"更新日: {today.isoformat()}",
        "",
        "## 継続ログ",
        "",
    ]
    if sessions:
        latest = sessions[0]
        lines.append(
            f"- 最新: {latest.timestamp.isoformat(timespec='minutes')} / {latest.device} / {latest.location} / {latest.minutes}分 / {latest.kind}"
        )
    else:
        lines.append("- 最新: まだログがありません")
    lines.extend(
        [
            "",
        "## 今すぐ見る",
        "",
        ]
    )
    top_tasks = tasks[:10]
    for index, task in enumerate(top_tasks, start=1):
        due = task.due_date.isoformat() if task.due_date else "-"
        note = f" / {task.note}" if task.note else ""
        lines.append(
            f"{index}. [{task.area}] {task.title} | 優先度: {task.priority} | 期限: {due} | 工数: {task.effort_minutes}分 | 出典: {task.source_label()}{note}"
        )
    lines.extend(["", "## 全体バックログ", ""])
    for task in tasks:
        due = task.due_date.isoformat() if task.due_date else "-"
        lines.append(
            f"- [{task.area}] {task.title} | 優先度: {task.priority} | 期限: {due} | 工数: {task.effort_minutes}分 | エネルギー: {task.energy}"
        )
    lines.append("")
    lines.append("_generated by taskManegement/scripts/rebuild_task_board.py_")
    return "\n".join(lines)


def render_daily_brief(schedule, sessions: list[SessionEntry], today: date) -> str:
    lines = [
        "# Daily Brief",
        "",
        f"対象日: {today.isoformat()}",
        "",
        "## 今日の3件",
        "",
    ]
    today_plan = schedule[0][1] if schedule else []
    today_tasks = [task for _, task in today_plan if task][:3]
    for task in today_tasks:
        due = task.due_date.isoformat() if task.due_date else "-"
        lines.append(f"- {task.title} ({task.area}) / 期限: {due} / 工数: {task.effort_minutes}分")
        if task.note:
            lines.append(f"  補足: {task.note}")
    lines.extend(
        [
            "",
            "## 継続ログ",
            "",
        ]
    )
    if sessions:
        latest = sessions[0]
        lines.append(
            f"- 最新: {latest.timestamp.isoformat(timespec='minutes')} / {latest.device} / {latest.location} / {latest.minutes}分 / {latest.kind}"
        )
    else:
        lines.append("- 今日はまだログがありません。退勤後の会社1時間を最低ラインにします。")
    lines.extend(
        [
            "",
            "## ひとこと",
            "",
            "会社でまず流れを作り、帰宅後はその延長として進める構成です。",
            "",
            "_generated by taskManegement/scripts/rebuild_task_board.py_",
        ]
    )
    return "\n".join(lines)


def render_weekly_schedule(plan, today: date) -> str:
    lines = [
        "# Weekly Schedule",
        "",
        f"開始日: {today.isoformat()}",
        "",
    ]
    for day, day_plan in plan:
        weekday = ["月", "火", "水", "木", "金", "土", "日"][day.weekday()]
        lines.append(f"## {day.isoformat()} ({weekday})")
        lines.append("")
        for slot, task in day_plan:
            optional = " 任意枠" if slot.get("optional") else ""
            if task:
                lines.append(
                    f"- {slot['start']}-{slot['end']} {slot['label']}{optional}: {task.title} [{task.area}]"
                )
            else:
                lines.append(f"- {slot['start']}-{slot['end']} {slot['label']}{optional}: 予備")
        lines.append("")
    lines.append("_generated by taskManegement/scripts/rebuild_task_board.py_")
    return "\n".join(lines)


def main() -> None:
    today = datetime.now().date()
    profile = load_json(TASK_DIR / "config" / "schedule_profile.json")
    sessions = load_session_entries(TASK_DIR / "logs" / "session_log.csv")
    tasks = load_tasks(today, sessions)
    schedule = build_week_schedule(tasks, profile, today)

    (TASK_DIR / "outputs" / "board.md").write_text(render_board(tasks, sessions, today), encoding="utf-8")
    (TASK_DIR / "outputs" / "daily_brief.md").write_text(render_daily_brief(schedule, sessions, today), encoding="utf-8")
    (TASK_DIR / "outputs" / "weekly_schedule.md").write_text(render_weekly_schedule(schedule, today), encoding="utf-8")


if __name__ == "__main__":
    main()
