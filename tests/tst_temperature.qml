import QtQuick
import QtTest

import "../package/contents/code/temperature.js" as Temperature

TestCase {
    name: "Temperature"

    function test_converts_units() {
        compare(Temperature.convert(0, "fahrenheit"), 32);
        compare(Temperature.convert(100, "fahrenheit"), 212);
        compare(Temperature.convert(42, "celsius"), 42);
        compare(Temperature.format(55, "celsius"), "55°C");
        compare(Temperature.format(55, "fahrenheit"), "131°F");
        compare(Temperature.unavailable("celsius"), "--°C");
    }

    function test_uses_celsius_thresholds() {
        compare(Temperature.color(50.1), "#f67400");
        compare(Temperature.color(69.9), "#f67400");
        compare(Temperature.color(70), "#da4453");
    }

    function test_normalizes_unit() {
        compare(Temperature.normalizeUnit("fahrenheit"), "fahrenheit");
        compare(Temperature.normalizeUnit("kelvin"), "celsius");
        compare(Temperature.suffix("fahrenheit"), "F");
        compare(Temperature.suffix("celsius"), "C");
    }
}
