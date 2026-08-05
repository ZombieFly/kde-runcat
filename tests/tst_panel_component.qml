pragma ComponentBehavior: Bound

import QtQuick
import QtTest

import "../package/contents/ui"

TestCase {
    id: testCase

    name: "PanelComponent"
    when: windowShown

    readonly property var metrics: ({
        memoryUsage: 42,
        memoryUsed: "12 GiB",
        memoryTotal: "32 GiB",
        memoryUsageAvailable: true,
        memoryDetailAvailable: true,
        diskUsage: 30,
        diskUsed: "150 GiB",
        diskTotal: "500 GiB",
        diskUsageAvailable: true,
        diskDetailAvailable: true,
        downloadRate: "1 MiB/s",
        uploadRate: "100 KiB/s",
        downloadAvailable: true,
        uploadAvailable: true,
        gpuUsage: 45,
        gpuUsageAvailable: true,
        gpuTemperature: 55,
        gpuTemperatureAvailable: true,
        vramUsage: 25,
        vramUsed: "2 GiB",
        vramTotal: "8 GiB",
        vramUsageAvailable: true,
        vramDetailAvailable: true,
        diskReadRate: "10 MiB/s",
        diskWriteRate: "2 MiB/s",
        diskReadAvailable: true,
        diskWriteAvailable: true,
        codexTodayTokens: 1000,
        codexContextTokens: 2000,
        codexContextWindow: 100000,
        claudeTodayTokens: 3000,
        claudeContextTokens: 4000,
        codexAvailable: true,
        claudeAvailable: true,
        codexUpdatedAt: "2026-08-05T12:00:00+08:00",
        claudeUpdatedAt: "2026-08-05T12:00:00+08:00"
    })

    Component {
        id: panelComponentFactory

        PanelComponent {
            componentType: "runner"
            componentSettings: ({
                runner: "cat",
                useIdleFrame: true,
                idleThreshold: 2,
                speedPercent: 100,
                flipHorizontally: false,
                reverseSpeed: false
            })
            cpuUsage: 42
            smoothedCpu: 42
            sensorReady: true
            cpuTemperature: 55
            temperatureReady: true
            metrics: testCase.metrics
            height: 32
        }
    }

    Component {
        id: tallPanelComponentFactory

        PanelComponent {
            componentType: "runner"
            componentSettings: ({runner: "cat"})
            cpuUsage: 0
            smoothedCpu: 0
            sensorReady: true
            cpuTemperature: 55
            temperatureReady: true
            metrics: testCase.metrics
            height: 64
        }
    }

    Component {
        id: cpuUsageRunnerFactory

        PanelComponent {
            componentType: "runner"
            componentSettings: ({runner: "cat", showCpuUsage: true})
            cpuUsage: 42
            smoothedCpu: 42
            sensorReady: true
            cpuTemperature: 55
            temperatureReady: true
            metrics: testCase.metrics
            height: 32
        }
    }

    Component {
        id: temperatureRunnerFactory

        PanelComponent {
            componentType: "runner"
            componentSettings: ({
                runner: "cat",
                showCpuUsage: true,
                showCpuTemperature: true,
                temperatureUnit: "celsius"
            })
            cpuUsage: 42
            smoothedCpu: 42
            sensorReady: true
            cpuTemperature: 55
            temperatureReady: true
            metrics: testCase.metrics
            height: 32
        }
    }

    Component {
        id: memoryRingFactory

        PanelComponent {
            componentType: "memory"
            componentSettings: ({showText: false})
            cpuUsage: 0
            smoothedCpu: 0
            sensorReady: true
            cpuTemperature: 0
            temperatureReady: false
            metrics: testCase.metrics
            height: 32
        }
    }

    Component {
        id: memoryRingWithTextFactory

        PanelComponent {
            componentType: "memory"
            componentSettings: ({showText: true})
            cpuUsage: 0
            smoothedCpu: 0
            sensorReady: true
            cpuTemperature: 0
            temperatureReady: false
            metrics: testCase.metrics
            height: 32
        }
    }

    Component {
        id: codexRingFactory

        PanelComponent {
            componentType: "codex"
            componentSettings: ({showText: false})
            cpuUsage: 0
            smoothedCpu: 0
            sensorReady: true
            cpuTemperature: 0
            temperatureReady: false
            metrics: testCase.metrics
            height: 32
        }
    }

    Component {
        id: networkRateFactory

        PanelComponent {
            componentType: "network"
            componentSettings: ({})
            cpuUsage: 0
            smoothedCpu: 0
            sensorReady: true
            cpuTemperature: 0
            temperatureReady: false
            metrics: testCase.metrics
            height: 32
        }
    }

    Component {
        id: codexRingWithTextFactory

        PanelComponent {
            componentType: "codex"
            componentSettings: ({showText: true})
            cpuUsage: 0
            smoothedCpu: 0
            sensorReady: true
            cpuTemperature: 0
            temperatureReady: false
            metrics: testCase.metrics
            height: 32
        }
    }

    Component {
        id: gpuFactory

        PanelComponent {
            componentType: "gpu"
            componentSettings: ({
                showText: true,
                showGpuTemperature: true,
                temperatureUnit: "celsius"
            })
            cpuUsage: 0
            smoothedCpu: 0
            sensorReady: true
            cpuTemperature: 0
            temperatureReady: false
            metrics: testCase.metrics
            height: 32
        }
    }

    Component {
        id: vramFactory

        PanelComponent {
            componentType: "vram"
            componentSettings: ({showText: true})
            cpuUsage: 0
            smoothedCpu: 0
            sensorReady: true
            cpuTemperature: 0
            temperatureReady: false
            metrics: testCase.metrics
            height: 32
        }
    }

    Component {
        id: diskIoFactory

        PanelComponent {
            componentType: "diskio"
            componentSettings: ({})
            cpuUsage: 0
            smoothedCpu: 0
            sensorReady: true
            cpuTemperature: 0
            temperatureReady: false
            metrics: testCase.metrics
            height: 32
        }
    }

    Component {
        id: claudeRingFactory

        PanelComponent {
            componentType: "claude"
            componentSettings: ({showText: false, contextWindow: 200000})
            cpuUsage: 0
            smoothedCpu: 0
            sensorReady: true
            cpuTemperature: 0
            temperatureReady: false
            metrics: testCase.metrics
            height: 32
        }
    }

    Component {
        id: claudeRingWithTextFactory

        PanelComponent {
            componentType: "claude"
            componentSettings: ({showText: true, contextWindow: 200000})
            cpuUsage: 0
            smoothedCpu: 0
            sensorReady: true
            cpuTemperature: 0
            temperatureReady: false
            metrics: testCase.metrics
            height: 32
        }
    }

    function test_canInstantiate() {
        const component = createTemporaryObject(panelComponentFactory, testCase);
        verify(component !== null);
        compare(component.componentType, "runner");
        verify(component.implicitWidth > 0);
        verify(component.implicitHeight > 0);
    }

    function test_runner_does_not_grow_with_tall_panel() {
        const component = createTemporaryObject(
            tallPanelComponentFactory, testCase
        );
        verify(component !== null);
        compare(component.implicitHeight, 32);
        compare(component.implicitWidth, Math.round(32 * 56 / 36));
    }

    function test_cpu_usage_adds_width_to_runner() {
        const runnerOnly = createTemporaryObject(
            panelComponentFactory, testCase
        );
        const withCpu = createTemporaryObject(
            cpuUsageRunnerFactory, testCase
        );
        verify(runnerOnly !== null);
        verify(withCpu !== null);
        verify(withCpu.implicitWidth > runnerOnly.implicitWidth);
        compare(withCpu.implicitHeight, runnerOnly.implicitHeight);
    }

    function test_temperature_text_stacks_without_growing_runner() {
        const withCpu = createTemporaryObject(
            cpuUsageRunnerFactory, testCase
        );
        const withTemperature = createTemporaryObject(
            temperatureRunnerFactory, testCase
        );
        verify(withCpu !== null);
        verify(withTemperature !== null);
        compare(withTemperature.implicitHeight, withCpu.implicitHeight);
        verify(withTemperature.implicitWidth >= withCpu.implicitWidth);
        compare(withTemperature.temperatureText, "55°C");
        verify(withTemperature.temperatureIsCool);

        withTemperature.cpuTemperature = 59.9;
        verify(withTemperature.temperatureIsCool);
        withTemperature.cpuTemperature = 60;
        verify(!withTemperature.temperatureIsCool);
        compare(withTemperature.temperatureColor.toString(), "#f67400");
        withTemperature.cpuTemperature = 90;
        compare(withTemperature.temperatureColor.toString(), "#da4453");
    }

    function test_resource_text_adds_width_without_growing_ring() {
        const ringOnly = createTemporaryObject(memoryRingFactory, testCase);
        const withText = createTemporaryObject(
            memoryRingWithTextFactory, testCase
        );
        verify(ringOnly !== null);
        verify(withText !== null);
        verify(withText.implicitWidth > ringOnly.implicitWidth);
        compare(withText.implicitHeight, ringOnly.implicitHeight);
    }

    function test_codex_text_adds_width_without_growing_ring() {
        const ringOnly = createTemporaryObject(codexRingFactory, testCase);
        const withText = createTemporaryObject(
            codexRingWithTextFactory, testCase
        );
        verify(ringOnly !== null);
        verify(withText !== null);
        verify(withText.implicitWidth > ringOnly.implicitWidth);
        compare(withText.implicitHeight, ringOnly.implicitHeight);
    }

    function test_network_icon_and_rates_fit_panel_height() {
        const component = createTemporaryObject(networkRateFactory, testCase);
        verify(component !== null);
        verify(component.implicitWidth > 0);
        compare(component.implicitHeight, 32);

        const initialWidth = component.implicitWidth;
        component.metrics = Object.assign({}, testCase.metrics, {
            downloadRate: "999.9 MiB/s",
            uploadRate: "1 B/s"
        });
        compare(component.implicitWidth, initialWidth);
    }

    function test_claude_text_adds_width_without_growing_ring() {
        const ringOnly = createTemporaryObject(claudeRingFactory, testCase);
        const withText = createTemporaryObject(
            claudeRingWithTextFactory, testCase
        );
        verify(ringOnly !== null);
        verify(withText !== null);
        verify(withText.implicitWidth > ringOnly.implicitWidth);
        compare(withText.implicitHeight, ringOnly.implicitHeight);
    }

    function test_hardware_components_fit_panel_height() {
        const gpu = createTemporaryObject(gpuFactory, testCase);
        const vram = createTemporaryObject(vramFactory, testCase);
        const diskIo = createTemporaryObject(diskIoFactory, testCase);
        verify(gpu !== null);
        verify(vram !== null);
        verify(diskIo !== null);
        verify(gpu.implicitWidth > 0);
        verify(vram.implicitWidth > 0);
        verify(diskIo.implicitWidth > 0);
        compare(gpu.implicitHeight, 32);
        compare(vram.implicitHeight, 32);
        compare(diskIo.implicitHeight, 32);

        const initialGpuWidth = gpu.implicitWidth;
        gpu.metrics = Object.assign({}, testCase.metrics, {
            gpuUsage: 100,
            gpuTemperature: 90
        });
        compare(gpu.implicitWidth, initialGpuWidth);

        const initialWidth = diskIo.implicitWidth;
        diskIo.metrics = Object.assign({}, testCase.metrics, {
            diskReadRate: "999.9 MiB/s",
            diskWriteRate: "1 B/s"
        });
        compare(diskIo.implicitWidth, initialWidth);
    }
}
