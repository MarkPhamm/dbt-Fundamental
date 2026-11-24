"""MkDocs hook: serve duckdb/raw_data.sql and duckdb/data/*.csv under data/ for the in-browser SQL playground.

The playground runs raw_data.sql itself, so the browser and load_raw.py build the same raw tables.
"""

from pathlib import Path

from mkdocs.structure.files import File

DUCKDB_DIR = Path(__file__).parent / "duckdb"


def on_files(files, config):
    sources = [DUCKDB_DIR / "raw_data.sql", *sorted((DUCKDB_DIR / "data").glob("*.csv"))]
    for path in sources:
        files.append(File.generated(config, f"data/{path.name}", abs_src_path=str(path)))
    return files
