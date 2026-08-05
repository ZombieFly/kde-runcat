import QtQuick
import QtTest

import "../package/contents/code/components.js" as Components

TestCase {
    name: "Components"

    function test_default_has_only_runner() {
        const value = Components.defaultComponents();
        compare(value.length, 1);
        compare(value[0].type, "runner");
        compare(value[0].settings.runner, "cat");
        compare(value[0].settings.speedPercent, 100);
        compare(value[0].settings.showCpuUsage, false);
        compare(value[0].settings.showCpuTemperature, false);
        compare(value[0].settings.temperatureUnit, "celsius");
    }

    function test_resource_components_hide_text_by_default() {
        compare(Components.defaultSettings("memory").showText, false);
        compare(Components.defaultSettings("disk").showText, false);

        const value = Components.normalize([
            {type: "memory", settings: {showText: true}},
            {type: "disk", settings: {}}
        ]);
        compare(value[0].settings.showText, true);
        compare(value[1].settings.showText, false);
    }

    function test_normalize_preserves_order_and_settings() {
        const value = Components.normalize(JSON.stringify([
            {type: "memory", settings: {}},
            {type: "runner", settings: {runner: "dog", speedPercent: 150}},
            {type: "ai", settings: {
                showCodex: false,
                showClaude: true,
                showDaily: true,
                claudeContextWindow: 400000
            }}
        ]));
        compare(value.length, 3);
        compare(value[0].type, "memory");
        compare(value[1].settings.runner, "dog");
        compare(value[1].settings.speedPercent, 150);
        compare(value[2].settings.showCodex, false);
        compare(value[2].settings.claudeContextWindow, 400000);
    }

    function test_normalize_rejects_unknown_and_duplicate_types() {
        const value = Components.normalize([
            {type: "memory", settings: {}},
            {type: "unknown", settings: {}},
            {type: "memory", settings: {}}
        ]);
        compare(value.length, 1);
        compare(value[0].type, "memory");
    }

    function test_normalize_moves_cpu_component_into_runner() {
        const value = Components.normalize([
            {type: "memory", settings: {}},
            {type: "runner", settings: {runner: "dog"}},
            {type: "cpu", settings: {}}
        ]);
        compare(value.length, 2);
        compare(value[0].type, "memory");
        compare(value[1].type, "runner");
        compare(value[1].settings.runner, "dog");
        compare(value[1].settings.showCpuUsage, true);
    }

    function test_cpu_without_runner_restores_runner_at_cpu_position() {
        const value = Components.normalize([
            {type: "memory", settings: {}},
            {type: "cpu", settings: {}},
            {type: "disk", settings: {}}
        ]);
        compare(value.length, 3);
        compare(value[0].type, "memory");
        compare(value[1].type, "runner");
        compare(value[1].settings.showCpuUsage, true);
        compare(value[2].type, "disk");
    }

    function test_legacy_migration_keeps_enabled_metrics() {
        const value = Components.migrateLegacy({
            runner: "mochi",
            useIdleFrame: false,
            idleThreshold: 5,
            speedPercent: 125,
            flipHorizontally: true,
            reverseSpeed: true,
            showCpuUsage: true,
            showCpuTemperature: true,
            showMemoryUsage: true,
            showDiskUsage: false,
            showNetworkRate: true,
            showCodexTokenUsage: false,
            showClaudeTokenUsage: true,
            showDailyTokenUsage: true,
            claudeContextWindow: 300000
        });
        compare(value.length, 4);
        compare(value[0].type, "runner");
        compare(value[0].settings.runner, "mochi");
        compare(value[0].settings.showCpuUsage, true);
        compare(value[1].type, "memory");
        compare(value[2].type, "network");
        compare(value[3].type, "ai");
        compare(value[3].settings.showCodex, false);
        compare(value[3].settings.showClaude, true);
        compare(value[3].settings.showDaily, true);
        compare(value[3].settings.claudeContextWindow, 300000);
    }

    function test_invalid_json_falls_back_to_runner() {
        const value = Components.normalize("not json");
        compare(value.length, 1);
        compare(value[0].type, "runner");
    }

    function test_normalize_removes_temperature_component() {
        const value = Components.normalize([
            {type: "runner", settings: {}},
            {type: "cpuTemperature", settings: {}},
            {type: "memory", settings: {}}
        ]);
        compare(value.length, 2);
        compare(value[0].type, "runner");
        compare(value[0].settings.showCpuTemperature, true);
        compare(value[1].type, "memory");
    }

    function test_runner_normalizes_temperature_settings() {
        const fahrenheit = Components.normalize([{
            type: "runner",
            settings: {showCpuTemperature: true, temperatureUnit: "fahrenheit"}
        }]);
        compare(fahrenheit[0].settings.showCpuTemperature, true);
        compare(fahrenheit[0].settings.temperatureUnit, "fahrenheit");

        const invalid = Components.normalize([{
            type: "runner",
            settings: {temperatureUnit: "kelvin"}
        }]);
        compare(invalid[0].settings.temperatureUnit, "celsius");
    }
}
