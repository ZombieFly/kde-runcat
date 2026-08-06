import QtQuick
import QtTest

import "../package/contents/code/value_format.js" as ValueFormat

TestCase {
    name: "ValueFormat"

    function test_percent_uses_at_most_three_digits() {
        compare(ValueFormat.formatPercent(2), "2%");
        compare(ValueFormat.formatPercent(23), "23%");
        compare(ValueFormat.formatPercent(100), "100%");
        compare(ValueFormat.formatPercent(101), "100%");
    }

    function test_binary_values_promote_at_1000_using_iec_conversion() {
        compare(ValueFormat.formatBytes(0), "0.0 B");
        compare(ValueFormat.formatBytes(999), "999.0 B");
        compare(ValueFormat.formatBytes(1000), "1.0 KiB");
        compare(ValueFormat.formatBytes(999 * 1024 * 1024 * 1024),
                "999.0 GiB");
        compare(ValueFormat.formatBytes(1000 * 1024 * 1024 * 1024),
                "1.0 TiB");
        compare(ValueFormat.formatBytes(1024 * 1024 * 1024 * 1024),
                "1.0 TiB");
    }

    function test_rates_follow_binary_value_rules() {
        compare(ValueFormat.formatRate(999), "999.0 B/s");
        compare(ValueFormat.formatRate(1000), "1.0 KiB/s");
    }

    function test_tokens_use_compact_decimal_units() {
        compare(ValueFormat.formatTokens(0), "0.0");
        compare(ValueFormat.formatTokens(999), "999.0");
        compare(ValueFormat.formatTokens(1000), "1.0k");
        compare(ValueFormat.formatTokens(1250), "1.3k");
        compare(ValueFormat.formatTokens(1000000), "1.0m");
    }

    function test_values_clamp_at_largest_unit() {
        compare(ValueFormat.formatBytes(Number.MAX_VALUE), "999.9 EiB");
        compare(ValueFormat.formatRate(Number.MAX_VALUE), "999.9 EiB/s");
        compare(ValueFormat.formatTokens(Number.MAX_VALUE), "999.9t");
    }

    function test_width_sentinels_cover_widest_unit_glyphs() {
        compare(ValueFormat.widestBinaryText(false), "999.9 MiB");
        compare(ValueFormat.widestBinaryText(true), "999.9 MiB/s");
        compare(ValueFormat.widestTokenText(), "999.9m");
    }

    function test_invalid_values_fall_back_to_zero() {
        compare(ValueFormat.formatBytes(-1), "0.0 B");
        compare(ValueFormat.formatRate("not a number"), "0.0 B/s");
        compare(ValueFormat.formatTokens(-1), "0.0");
    }
}
