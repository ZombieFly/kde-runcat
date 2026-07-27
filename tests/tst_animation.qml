import QtQuick
import QtTest

import "../package/contents/code/animation.js" as Animation

TestCase {
    name: "Animation"

    function fuzzyCompare(actual, expected, epsilon) {
        verify(Math.abs(actual - expected) <= epsilon,
               "expected " + expected + ", got " + actual);
    }

    function test_clamp() {
        compare(Animation.clamp(-1, 0, 100), 0);
        compare(Animation.clamp(55, 0, 100), 55);
        compare(Animation.clamp(101, 0, 100), 100);
    }

    function test_smooth() {
        compare(Animation.smooth(20, 100, 0), 20);
        compare(Animation.smooth(20, 100, 1), 100);
        compare(Animation.smooth(20, 100, 0.25), 40);
    }

    function test_cycleDuration_is_bounded_and_monotonic() {
        compare(Animation.cycleDuration(-10, 2500, 250), 2500);
        compare(Animation.cycleDuration(100, 2500, 250), 250);
        compare(Animation.cycleDuration(110, 2500, 250), 250);
        verify(Animation.cycleDuration(50, 2500, 250)
               < Animation.cycleDuration(10, 2500, 250));
    }

    function test_cycleDuration_accelerates_at_medium_load() {
        verify(Animation.cycleDuration(25, 2500, 250) < 900);
        verify(Animation.cycleDuration(50, 2500, 250) < 550);
        verify(Animation.cycleDuration(75, 2500, 250) < 400);
    }

    function test_cycleDuration_can_reverse_cpu_mapping() {
        compare(Animation.cycleDuration(0, 2500, 250, true), 250);
        compare(Animation.cycleDuration(100, 2500, 250, true), 2500);
        verify(Animation.cycleDuration(25, 2500, 250, true)
               < Animation.cycleDuration(75, 2500, 250, true));
    }

    function test_frameInterval_respects_fps_limit() {
        fuzzyCompare(Animation.frameInterval(100, 5, 2500, 50, 30),
                     1000 / 30, 0.001);
        compare(Animation.frameInterval(0, 5, 2500, 250, 30), 500);
    }

    function test_frameInterval_normalizes_reversed_cycle_settings() {
        compare(Animation.frameInterval(0, 5, 250, 2500, 60), 500);
        compare(Animation.frameInterval(100, 5, 250, 2500, 60), 50);
    }

    function test_frameInterval_reverses_cpu_mapping() {
        compare(Animation.frameInterval(0, 5, 2500, 250, 60, true), 50);
        compare(Animation.frameInterval(100, 5, 2500, 250, 60, true), 500);
    }

    function test_frameInterval_scales_running_speed() {
        compare(Animation.frameInterval(0, 5, 2500, 250, 60, false, 50), 1000);
        compare(Animation.frameInterval(0, 5, 2500, 250, 60, false, 100), 500);
        compare(Animation.frameInterval(0, 5, 2500, 250, 60, false, 200), 250);
    }

    function test_frameInterval_defaults_and_clamps_speed() {
        compare(Animation.frameInterval(0, 5, 2500, 250, 60, false), 500);
        compare(Animation.frameInterval(0, 5, 2500, 250, 60, false, 0), 2000);
        compare(Animation.frameInterval(0, 5, 2500, 250, 60, false, 500), 250);
    }
}
