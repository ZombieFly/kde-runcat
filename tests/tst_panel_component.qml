import QtQuick
import QtTest

import "../package/contents/ui"

TestCase {
    id: testCase

    name: "PanelComponent"
    when: windowShown

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
}
