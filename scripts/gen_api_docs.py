#!/usr/bin/env python3
"""Shim — see scripts/docs/gen_api_docs.py"""
import runpy
from pathlib import Path

runpy.run_path(str(Path(__file__).resolve().parent / "docs" / "gen_api_docs.py"), run_name="__main__")
