# Copyright 2023 Pieter Swinkels <swinkels.pieter@yahoo.com>
#
# Use of this source code is governed by an MIT-style license that can be found
# in the LICENSE file or at https://opensource.org/licenses/MIT.

import io
import re
from typing import List, Optional, Tuple

import pandas as pd


def read_table(
    table: str, columns: Optional[List[str]] = None, **kwargs
) -> pd.DataFrame:
    stripped_table = strip_table(table)
    stream = io.StringIO(stripped_table)

    if columns is None:
        colspecs = "infer"
    else:
        m = re.search(".*\n", stripped_table + "\n")
        assert m is not None, "the table does not seem to have a header"
        header = m.group().rstrip()
        colspecs = _get_colspecs(header, columns)

        start_pos = colspecs[0][0]
        if start_pos and kwargs.get("index_col", None) == 0:
            colspecs = [(0, start_pos)] + colspecs

    return pd.read_fwf(stream, colspecs=colspecs, **kwargs)


def strip_table(table: str) -> str:
    return table.lstrip("\r\n").rstrip()


def _get_colspecs(header: str, columns: Optional[List[str]]) -> List[Tuple[int, int]]:
    colspecs = []

    previous_start = None
    for column in columns:
        m = re.search(column, header)
        assert m is not None, f"no column named '{column}' found"
        if previous_start is not None:
            previous_end = m.start()
            colspecs = colspecs + [(previous_start, previous_end)]
        previous_start = m.start()

    colspecs = colspecs + [(previous_end, previous_end + len(columns[-1]))]

    return colspecs


def assert_equal_dfs(df0: pd.DataFrame, df1: pd.DataFrame):
    """Assert that the exports of the given DataFrame(s) are equal."""
    assert df0.to_string(index=False) == df1.to_string(index=False)
