#!/usr/bin/env python3
"""Shim — see scripts/checks/check_qstr_coverage.py"""
import runpy
from pathlib import Path

runpy.run_path(str(Path(__file__).resolve().parent / "checks" / "check_qstr_coverage.py"), run_name="__main__")
