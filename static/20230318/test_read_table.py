# Copyright️ 2023 Pieter Swinkels <swinkels.pieter@yahoo.com>
#
# Use of this source code is governed by an MIT-style license that can be found
# in the LICENSE file or at https://opensource.org/licenses/MIT.

import numpy as np

from read_table import read_table


class TestReadTableWithSingleWordColumnNames:
    def test_default_case(self):
        table = """
FirstName LastName FirstAppearance
Donald    Duck     1934
Mickey    Mouse    1928
Goofy              1932
        """
        df = read_table(table)
        assert list(df.columns) == ["FirstName", "LastName", "FirstAppearance"]

        assert list(df["FirstName"]) == ["Donald", "Mickey", "Goofy"]
        assert list(df["LastName"]) == ["Duck", "Mouse", np.nan]
        assert list(df["FirstAppearance"]) == [1934, 1928, 1932]

    def test_support_for_leading_spaces(self):
        table = """
  FirstName LastName FirstAppearance
  Donald    Duck     1934
  Mickey    Mouse    1928
  Goofy              1932
        """
        df = read_table(table)
        assert list(df.columns) == ["FirstName", "LastName", "FirstAppearance"]

        assert list(df["FirstName"]) == ["Donald", "Mickey", "Goofy"]
        assert list(df["LastName"]) == ["Duck", "Mouse", np.nan]
        assert list(df["FirstAppearance"]) == [1934, 1928, 1932]

    def test_support_for_leading_spaces_with_index(self):
        table = """
     FirstName LastName FirstAppearance
  0  Donald    Duck     1934
  2  Mickey    Mouse    1928
  3  Goofy              1932
        """
        df = read_table(table, index_col=0)
        assert list(df.columns) == ["FirstName", "LastName", "FirstAppearance"]
        assert list(df.index) == [0, 2, 3]

        assert list(df["FirstName"]) == ["Donald", "Mickey", "Goofy"]
        assert list(df["LastName"]) == ["Duck", "Mouse", np.nan]
        assert list(df["FirstAppearance"]) == [1934, 1928, 1932]


class TestReadTableWithMultiWordColumnNames:
    @property
    def expected_df_content(self):
        return {
            "First name": ["Donald", "Mickey", "Goofy"],
            "Last name": ["Duck", "Mouse", np.nan],
            "First appearance": [1934, 1928, 1932],
        }

    def test_a_2_word_column_name_can_be_read_as_two_columns(self):
        table = """
First name Last name First appearance
Donald     Duck      1934
Mickey     Mouse     1928
Goofy                1932
        """
        df = read_table(table)
        assert list(df.columns) == ["First name", "Last name", "First", "appearance"]

    def test_a_2_word_column_name_can_be_read_as_a_single_column(self):
        table = """
First name Last name First appearance
Donald     Duck      1934
Mickey     Mouse     1928
Goofy                1932
        """
        df = read_table(table, columns=["First name", "Last name", "First appearance"])

        assert df.to_dict("list") == self.expected_df_content

    def test_the_table_does_not_have_to_be_left_aligned(self):
        table = """
  First name Last name First appearance
  Donald     Duck      1934
  Mickey     Mouse     1928
  Goofy                1932
        """
        df = read_table(table, columns=["First name", "Last name", "First appearance"])

        assert df.to_dict("list") == self.expected_df_content

    def test_the_table_can_consist_of_a_header_only(self):
        table = """
  First name Last name First appearance
        """
        df = read_table(table, columns=["First name", "Last name", "First appearance"])

        assert df.to_dict("list") == {
            "First name": [],
            "Last name": [],
            "First appearance": [],
        }

    def test_the_table_can_have_an_index(self):
        table = """
   First name Last name First appearance
 0 Donald     Duck      1934
 2 Mickey     Mouse     1928
 3 Goofy                1932
        """
        df = read_table(
            table, columns=["First name", "Last name", "First appearance"], index_col=0
        )

        assert df.to_dict("list") == self.expected_df_content
        assert list(df.index) == [0, 2, 3]
