"""
n1_countdown.py
Outputs: 月曜日 · N1まであと 127日
Day of week in Japanese + days until next JLPT N1 exam.

JLPT N1 schedule (approximate):
  - First sitting: first Sunday of July
  - Second sitting: first Sunday of December
"""

import sys
import datetime

sys.stdout.reconfigure(encoding="utf-8")

DAYS_JP = ["月曜日", "火曜日", "水曜日", "木曜日", "金曜日", "土曜日", "日曜日"]


def first_sunday(year: int, month: int) -> datetime.date:
    """Return the first Sunday of the given month/year."""
    d = datetime.date(year, month, 1)
    # weekday(): Monday=0 ... Sunday=6
    days_until_sunday = (6 - d.weekday()) % 7
    return d + datetime.timedelta(days=days_until_sunday)


def next_n1_date(today: datetime.date) -> datetime.date:
    """Return the date of the nearest upcoming JLPT N1 exam."""
    candidates = []
    for year in [today.year, today.year + 1]:
        for month in [7, 12]:
            d = first_sunday(year, month)
            if d > today:
                candidates.append(d)
    return min(candidates)


def main():
    today = datetime.date.today()
    day_jp = DAYS_JP[today.weekday()]
    exam_date = next_n1_date(today)
    days_left = (exam_date - today).days
    print(f"{day_jp} · N1まであと {days_left}日", end="")


if __name__ == "__main__":
    main()
