pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects
import QtQuick.Layouts

import org.kde.kirigami as Kirigami
import org.kde.ksysguard.sensors as Sensors
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid

import "../code/animation.js" as Animation

PlasmoidItem {
    id: root

    readonly property var runningFrames: [
        Qt.resolvedUrl("../images/cat/run-0.png"),
        Qt.resolvedUrl("../images/cat/run-1.png"),
        Qt.resolvedUrl("../images/cat/run-2.png"),
        Qt.resolvedUrl("../images/cat/run-3.png"),
        Qt.resolvedUrl("../images/cat/run-4.png")
    ]
    readonly property url idleFrame: Qt.resolvedUrl("../images/cat/idle.png")
    readonly property bool vertical: Plasmoid.formFactor === PlasmaCore.Types.Vertical
    readonly property bool isIdle: Plasmoid.configuration.useIdleFrame
        && sensorReady
        && smoothedCpu <= Plasmoid.configuration.idleThreshold
    readonly property real frameInterval: Animation.frameInterval(
        smoothedCpu,
        runningFrames.length,
        Plasmoid.configuration.slowCycleMs,
        Plasmoid.configuration.fastCycleMs,
        Plasmoid.configuration.maxFps
    )

    property real smoothedCpu: 0
    property bool sensorReady: false
    property int frameIndex: 0

    function updateCpu(rawValue) {
        const value = Number(rawValue);
        if (!Number.isFinite(value)) {
            return;
        }

        const bounded = Animation.clamp(value, 0, 100);
        if (!sensorReady) {
            smoothedCpu = bounded;
            sensorReady = true;
            return;
        }

        smoothedCpu = Animation.smooth(
            smoothedCpu,
            bounded,
            Plasmoid.configuration.smoothingPercent / 100
        );
    }

    Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground
    Plasmoid.title: i18n("RunCat")
    toolTipMainText: i18n("RunCat")
    toolTipSubText: sensorReady
        ? i18n("CPU usage: %1%", Math.round(smoothedCpu))
        : i18n("Waiting for CPU data")

    preferredRepresentation: fullRepresentation

    fullRepresentation: Item {
        id: representation

        implicitWidth: root.vertical ? Kirigami.Units.iconSizes.medium : Math.round(implicitHeight * 14 / 9)
        implicitHeight: root.vertical ? Math.round(implicitWidth * 9 / 14) : Kirigami.Units.iconSizes.medium

        Layout.minimumWidth: root.vertical ? Kirigami.Units.iconSizes.small : Math.round(Layout.minimumHeight * 14 / 9)
        Layout.minimumHeight: root.vertical ? Math.round(Layout.minimumWidth * 9 / 14) : Kirigami.Units.iconSizes.small
        Layout.preferredWidth: implicitWidth
        Layout.preferredHeight: implicitHeight

        Item {
            id: frameContainer

            anchors.fill: parent
            transform: Scale {
                origin.x: frameContainer.width / 2
                origin.y: frameContainer.height / 2
                xScale: Plasmoid.configuration.flipHorizontally ? -1 : 1
            }

            Repeater {
                model: root.runningFrames

                Image {
                    required property int index
                    required property url modelData

                    anchors.fill: parent
                    source: modelData
                    fillMode: Image.PreserveAspectFit
                    asynchronous: false
                    cache: true
                    visible: !root.isIdle && index === root.frameIndex
                    layer.enabled: true
                    layer.effect: MultiEffect {
                        brightness: 1
                        colorization: 1
                        colorizationColor: Kirigami.Theme.textColor
                    }
                }
            }

            Image {
                anchors.fill: parent
                source: root.idleFrame
                fillMode: Image.PreserveAspectFit
                asynchronous: false
                cache: true
                visible: root.isIdle
                layer.enabled: true
                layer.effect: MultiEffect {
                    brightness: 1
                    colorization: 1
                    colorizationColor: Kirigami.Theme.textColor
                }
            }
        }
    }

    Sensors.Sensor {
        id: cpuSensor

        sensorId: "cpu/all/usage"
        enabled: root.visible
        updateRateLimit: 1000
        onValueChanged: root.updateCpu(value)
    }

    Timer {
        interval: root.frameInterval
        repeat: true
        running: root.visible && !root.isIdle
        onTriggered: root.frameIndex = (root.frameIndex + 1) % root.runningFrames.length
    }
}
