pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects
import QtQuick.Layouts

import org.kde.kitemmodels as KItemModels
import org.kde.kirigami as Kirigami
import org.kde.ksysguard.sensors as Sensors
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid

import "../code/animation.js" as Animation
import "../code/sensors.js" as SensorSelection

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
    property string cpuTemperatureSensorId: ""
    property string gpuUsageSensorId: ""
    property string localIpv4SensorId: ""

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

    function discoverOptionalSensors() {
        const kinds = [
            "cpuTemperature",
            "gpuUsage",
            "localIpv4"
        ];
        const bestIds = ["", "", ""];
        const bestScores = [-1, -1, -1];

        for (let row = 0; row < flatSensorModel.rowCount(); ++row) {
            const index = flatSensorModel.index(row, 0);
            const sensorId = String(flatSensorModel.data(
                index,
                Sensors.SensorTreeModel.SensorId
            ) || "");
            if (sensorId.length === 0) {
                continue;
            }
            const name = String(flatSensorModel.data(index, Qt.DisplayRole) || "");

            for (let kindIndex = 0; kindIndex < kinds.length; ++kindIndex) {
                const score = SensorSelection.sensorScore(
                    sensorId,
                    name,
                    kinds[kindIndex]
                );
                if (score > bestScores[kindIndex]) {
                    bestScores[kindIndex] = score;
                    bestIds[kindIndex] = sensorId;
                }
            }
        }

        cpuTemperatureSensorId = bestIds[0];
        gpuUsageSensorId = bestIds[1];
        localIpv4SensorId = bestIds[2];
    }

    Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground
    Plasmoid.title: i18n("RunCat")
    toolTipMainText: i18n("RunCat")
    toolTipSubText: sensorReady
        ? i18n("CPU usage: %1%", Math.round(smoothedCpu))
        : i18n("Waiting for CPU data")

    activationTogglesExpanded: true
    preloadFullRepresentation: true
    preferredRepresentation: Plasmoid.formFactor === PlasmaCore.Types.Planar
        ? fullRepresentation
        : null

    compactRepresentation: Item {
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

        MouseArea {
            anchors.fill: parent
            onClicked: root.expanded = !root.expanded
        }
    }

    fullRepresentation: Dashboard {
        cpuTemperatureSensorId: root.cpuTemperatureSensorId
        gpuUsageSensorId: root.gpuUsageSensorId
        localIpv4SensorId: root.localIpv4SensorId
    }

    Sensors.SensorTreeModel {
        id: sensorTreeModel
    }

    KItemModels.KDescendantsProxyModel {
        id: flatSensorModel

        model: sensorTreeModel
        expandsByDefault: true
    }

    Timer {
        id: sensorDiscoveryTimer

        interval: 100
        onTriggered: root.discoverOptionalSensors()
    }

    Connections {
        target: flatSensorModel

        function onRowsInserted() {
            sensorDiscoveryTimer.restart();
        }

        function onModelReset() {
            sensorDiscoveryTimer.restart();
        }

        function onLayoutChanged() {
            sensorDiscoveryTimer.restart();
        }
    }

    Component.onCompleted: sensorDiscoveryTimer.start()

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
