import importlib.util
import json
import os
import tempfile
import unittest
from datetime import datetime, timedelta, timezone
from pathlib import Path


SCRIPT = (
    Path(__file__).parents[1]
    / "package"
    / "contents"
    / "code"
    / "token_usage.py"
)
SPEC = importlib.util.spec_from_file_location("token_usage", SCRIPT)
token_usage = importlib.util.module_from_spec(SPEC)
assert SPEC.loader is not None
SPEC.loader.exec_module(token_usage)


class TokenUsageTest(unittest.TestCase):
    def setUp(self):
        self.temp_dir = tempfile.TemporaryDirectory()
        self.root = Path(self.temp_dir.name)
        self.start = datetime(2026, 8, 5, tzinfo=timezone.utc)
        self.end = self.start + timedelta(days=1)

    def tearDown(self):
        self.temp_dir.cleanup()

    def write_records(self, name, records):
        path = self.root / name
        path.write_text(
            "".join(json.dumps(record) + "\n" for record in records),
            encoding="utf-8",
        )
        return path

    def test_codex_uses_cumulative_deltas_and_latest_context(self):
        path = self.write_records(
            "codex.jsonl",
            [
                self.codex_record("2026-08-04T23:59:00Z", 100, 40, 1000),
                self.codex_record("2026-08-05T00:01:00Z", 160, 60, 1000),
                self.codex_record("2026-08-05T00:01:01Z", 160, 60, 1000),
                self.codex_record("2026-08-05T01:00:00Z", 250, 90, 1000),
            ],
        )
        result = token_usage.codex_usage([path], self.start, self.end)
        self.assertEqual(result["todayTokens"], 150)
        self.assertEqual(result["contextTokens"], 90)
        self.assertEqual(result["contextWindow"], 1000)

    def test_claude_deduplicates_streamed_messages(self):
        path = self.write_records(
            "claude.jsonl",
            [
                self.claude_record("2026-08-05T01:00:00Z", "msg-1", 100),
                self.claude_record("2026-08-05T01:00:01Z", "msg-1", 100),
                self.claude_record("2026-08-05T02:00:00Z", "msg-2", 250),
            ],
        )
        result = token_usage.claude_usage(
            [path], self.start, self.end, 200_000
        )
        self.assertEqual(result["todayTokens"], 350)
        self.assertEqual(result["contextTokens"], 250)
        self.assertEqual(result["contextWindow"], 200_000)

    def test_recent_files_always_include_latest_session(self):
        old = self.write_records("old.jsonl", [])
        latest = self.write_records("latest.jsonl", [])
        old_time = (self.start - timedelta(days=4)).timestamp()
        latest_time = (self.start - timedelta(days=3)).timestamp()
        os.utime(old, (old_time, old_time))
        os.utime(latest, (latest_time, latest_time))

        self.assertEqual(
            token_usage._recent_jsonl(self.root, self.start), [latest]
        )

    @staticmethod
    def codex_record(stamp, total, last, window):
        return {
            "timestamp": stamp,
            "type": "event_msg",
            "payload": {
                "type": "token_count",
                "info": {
                    "total_token_usage": {"total_tokens": total},
                    "last_token_usage": {"total_tokens": last},
                    "model_context_window": window,
                },
            },
        }

    @staticmethod
    def claude_record(stamp, message_id, tokens):
        return {
            "timestamp": stamp,
            "type": "assistant",
            "isSidechain": False,
            "message": {
                "id": message_id,
                "model": "claude-test",
                "usage": {
                    "input_tokens": tokens,
                    "cache_creation_input_tokens": 0,
                    "cache_read_input_tokens": 0,
                    "output_tokens": 0,
                },
            },
        }


if __name__ == "__main__":
    unittest.main()
