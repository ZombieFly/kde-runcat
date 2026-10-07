import QtQuick
import QtTest

import "../package/contents/code/runners.js" as RunnerSelection

TestCase {
    name: "RunnerSelection"

    function test_listsAllBundledRunners() {
        compare(RunnerSelection.availableRunnerIds(), [
            "cat",
            "dog",
            "slime",
            "drop",
            "coffee",
            "newton-cradle",
            "engine",
            "mochi",
            "ds-chan"
        ]);
    }

    function test_fallsBackToCat() {
        compare(RunnerSelection.normalizeRunnerId("unknown"), "cat");
        compare(RunnerSelection.normalizeRunnerId(""), "cat");
        compare(RunnerSelection.frameOrder("unknown"), [0, 1, 2, 3, 4]);
    }

    function test_preservesSpecialFrameOrders() {
        compare(RunnerSelection.frameOrder("slime"),
                [0, 1, 2, 3, 4, 4, 3, 2, 1]);
        compare(RunnerSelection.frameOrder("newton-cradle"),
                [0, 1, 2, 1, 0, 3, 4, 3]);
        compare(RunnerSelection.frameOrder("mochi"),
                [0, 1, 2, 3, 4, 3, 2, 1]);
    }

    function test_usesRunnerAspectRatio() {
        compare(RunnerSelection.aspectRatio("cat"), 56 / 36);
        compare(RunnerSelection.aspectRatio("engine"), 83 / 36);
        compare(RunnerSelection.aspectRatio("unknown"), 56 / 36);
    }

    function test_dsChanProperties() {
        verify(RunnerSelection.isColored("ds-chan"));
        compare(RunnerSelection.isColored("cat"), false);
        verify(RunnerSelection.hasIdleFrame("ds-chan"));
        compare(RunnerSelection.frameOrder("ds-chan").length, 24);
        compare(RunnerSelection.frameOrder("ds-chan")[0], 0);
        compare(RunnerSelection.frameOrder("ds-chan")[23], 23);
        compare(RunnerSelection.aspectRatio("ds-chan"), 488 / 410);
    }
}
