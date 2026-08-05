import QtQuick
import QtTest

import "../package/contents/code/token_format.js" as TokenFormat

TestCase {
    name: "TokenFormat"

    function test_zero_has_no_suffix() {
        compare(TokenFormat.formatTokens(0), "0");
        compare(TokenFormat.formatTokens(-1), "0");
        compare(TokenFormat.formatTokens("not a number"), "0");
    }

    function test_abbreviates_nonzero_values() {
        compare(TokenFormat.formatTokens(1000), "1k");
        compare(TokenFormat.formatTokens(1250), "1.3k");
        compare(TokenFormat.formatTokens(1000000), "1m");
    }
}
