#!/usr/bin/env python3
"""Type-check the portable Swift examples and run their bounded behavior probes.

Requires macOS and Swift 6. Newer feature examples declare compiler and runtime
availability; skipped runtime scenarios are reported by the executable.
"""

from pathlib import Path
import platform
import subprocess
import sys
import tempfile


def run(command: list[str], *, timeout: int = 60) -> None:
    subprocess.run(command, check=True, timeout=timeout)


def main() -> int:
    if sys.platform != "darwin":
        print("Swift example checks require macOS and its Foundation SDK.", file=sys.stderr)
        return 1
    root = Path(__file__).resolve().parent.parent
    examples = root / "skills/swift-comments-that-matter/examples"
    run(["swiftc", "--version"])
    with tempfile.TemporaryDirectory(prefix="swift-comment-contracts-") as scratch:
        common = [
            "swiftc", "-swift-version", "6", "-warnings-as-errors",
            "-module-cache-path", str(Path(scratch) / "ModuleCache"),
        ]
        for source in sorted(examples.glob("*.swift")):
            run([*common, "-typecheck", str(source)])
        print("All Swift example files type-check", flush=True)
        binary = str(Path(scratch) / "example-contracts")
        runtime_sources = []
        runtime_flags = []
        # New concurrency runtime symbols must not enter an older OS executable,
        # even when a source-level availability branch would skip the function.
        if int(platform.mac_ver()[0].split(".")[0]) >= 27:
            runtime_sources.append(str(examples / "async-cleanup.swift"))
            runtime_flags = ["-D", "CAN_RUN_ASYNC_CLEANUP"]
        run([
            *common, *runtime_flags, "-parse-as-library",
            str(examples / "concurrency.swift"),
            str(examples / "invariants.swift"),
            *runtime_sources,
            str(root / "tests/example-contracts.swift"),
            "-o", binary,
        ])
        run([binary], timeout=30)
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except (subprocess.CalledProcessError, subprocess.TimeoutExpired) as error:
        print(f"Swift example validation failed: {error}", file=sys.stderr)
        sys.exit(1)
