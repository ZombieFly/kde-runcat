pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Effects
import QtQuick.Layouts

import org.kde.kitemmodels as KItemModels
import org.kde.kirigami as Kirigami
import org.kde.ksysguard.sensors as Sensors
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid

import "../code/animation.js" as Animation
import "../code/runners.js" as RunnerSelection
import "../code/sensors.js" as SensorSelection

PlasmoidItem {
    id: root

    readonly property int defaultSlowCycleMs: 2500
    readonly property int defaultFastCycleMs: 150
    readonly property int defaultMaxFps: 30
    readonly property real defaultSmoothing: 0.4
    readonly property color memoryPieColor: "#3daee9"
    readonly property color diskPieColor: "#27ae60"
    readonly property string runnerId: RunnerSelection.normalizeRunnerId(
        Plasmoid.configuration.runner
    )
    readonly property var runningFrames: RunnerSelection.frameOrder(runnerId).map(
        function(frameNumber) {
            return Qt.resolvedUrl(
                "../images/" + root.runnerId + "/run-" + frameNumber + ".png"
            );
        }
    )
    readonly property url idleFrame: runnerId === "cat"
        ? Qt.resolvedUrl("../images/cat/idle.png")
        : runningFrames[0]
    readonly property real runnerAspectRatio: RunnerSelection.aspectRatio(runnerId)
    readonly property bool vertical: Plasmoid.formFactor === PlasmaCore.Types.Vertical
    readonly property bool isIdle: Plasmoid.configuration.useIdleFrame
        && sensorReady
        && smoothedCpu <= Plasmoid.configuration.idleThreshold
    readonly property real frameInterval: Animation.frameInterval(
        smoothedCpu,
        runningFrames.length,
        defaultSlowCycleMs,
        defaultFastCycleMs,
        defaultMaxFps,
        Plasmoid.configuration.reverseSpeed,
        Plasmoid.configuration.speedPercent
    )

    property real smoothedCpu: 0
    property real cpuUsage: 0
    property bool sensorReady: false
    property int frameIndex: 0
    property string cpuTemperatureSensorId: ""
    property string gpuUsageSensorId: ""
    property string localIpv4SensorId: ""

    onRunnerIdChanged: frameIndex = 0

    function updateCpu(rawValue) {
        const value = Number(rawValue);
        if (!Number.isFinite(value)) {
            return;
        }

        const bounded = Animation.clamp(value, 0, 100);
        cpuUsage = bounded;
        if (!sensorReady) {
            smoothedCpu = bounded;
            sensorReady = true;
            return;
        }

        smoothedCpu = Animation.smooth(
            smoothedCpu,
            bounded,
            defaultSmoothing
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

        readonly property real runnerImplicitWidth: root.vertical
            ? Kirigami.Units.iconSizes.medium
            : Math.round(runnerImplicitHeight * root.runnerAspectRatio)
        readonly property real runnerImplicitHeight: root.vertical
            ? Math.round(Kirigami.Units.iconSizes.medium / root.runnerAspectRatio)
            : Kirigami.Units.iconSizes.medium
        readonly property real runnerMinimumWidth: root.vertical
            ? Kirigami.Units.iconSizes.small
            : Math.round(runnerMinimumHeight * root.runnerAspectRatio)
        readonly property real runnerMinimumHeight: root.vertical
            ? Math.round(Kirigami.Units.iconSizes.small / root.runnerAspectRatio)
            : Kirigami.Units.iconSizes.small
        readonly property real cpuLabelWidth: cpuLabelMetrics.advanceWidth
        readonly property int indicatorCount:
            (Plasmoid.configuration.showMemoryUsage ? 1 : 0)
            + (Plasmoid.configuration.showDiskUsage ? 1 : 0)
            + (Plasmoid.configuration.showCpuUsage ? 1 : 0)
            + (Plasmoid.configuration.showCpuTemperature ? 1 : 0)
            + (networkRate.visible ? 1 : 0)
        readonly property real usagePieImplicitSize: Math.round(
            runnerImplicitHeight * 0.9
        )
        readonly property real usagePieMinimumSize: Math.round(
            runnerMinimumHeight * 0.9
        )
        readonly property real usagePieSize: Math.round(
            Math.min(height, runnerImplicitHeight) * 0.9
        )
        readonly property real temperatureImplicitWidth: Math.round(
            usagePieImplicitSize * 0.45
        )
        readonly property real temperatureMinimumWidth: Math.round(
            usagePieMinimumSize * 0.45
        )
        readonly property real temperatureWidth: Math.round(
            usagePieSize * 0.45
        )
        readonly property real componentSpacing: Math.max(
            0,
            Math.min(24, Number(Plasmoid.configuration.indicatorSpacing))
        )
        readonly property real indicatorSpacing: indicatorCount > 1
            ? componentSpacing
            : 0
        readonly property real contentSpacing: indicatorCount > 0
            ? componentSpacing
            : 0
        readonly property real indicatorImplicitWidth:
            (Plasmoid.configuration.showMemoryUsage ? usagePieImplicitSize : 0)
            + (Plasmoid.configuration.showDiskUsage ? usagePieImplicitSize : 0)
            + (Plasmoid.configuration.showCpuUsage ? cpuLabelWidth : 0)
            + (Plasmoid.configuration.showCpuTemperature
                ? temperatureImplicitWidth : 0)
            + (networkRate.visible ? networkRate.implicitWidth : 0)
            + Math.max(0, indicatorCount - 1) * indicatorSpacing
        readonly property real indicatorMinimumWidth:
            (Plasmoid.configuration.showMemoryUsage ? usagePieMinimumSize : 0)
            + (Plasmoid.configuration.showDiskUsage ? usagePieMinimumSize : 0)
            + (Plasmoid.configuration.showCpuUsage ? cpuLabelWidth : 0)
            + (Plasmoid.configuration.showCpuTemperature
                ? temperatureMinimumWidth : 0)
            + (networkRate.visible ? networkRate.implicitWidth : 0)
            + Math.max(0, indicatorCount - 1) * indicatorSpacing
        readonly property real indicatorWidth:
            (Plasmoid.configuration.showMemoryUsage ? usagePieSize : 0)
            + (Plasmoid.configuration.showDiskUsage ? usagePieSize : 0)
            + (Plasmoid.configuration.showCpuUsage ? cpuLabelWidth : 0)
            + (Plasmoid.configuration.showCpuTemperature
                ? temperatureWidth : 0)
            + (networkRate.visible ? networkRate.implicitWidth : 0)
            + Math.max(0, indicatorCount - 1) * indicatorSpacing

        implicitWidth: runnerImplicitWidth + contentSpacing
            + indicatorImplicitWidth
        implicitHeight: runnerImplicitHeight

        Layout.minimumWidth: runnerMinimumWidth + contentSpacing
            + indicatorMinimumWidth
        Layout.minimumHeight: runnerMinimumHeight
        Layout.preferredWidth: implicitWidth
        Layout.preferredHeight: implicitHeight

        Item {
            id: frameContainer

            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: representation.indicatorCount > 0
                ? indicators.left
                : parent.right
            anchors.rightMargin: representation.contentSpacing
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

        TextMetrics {
            id: cpuLabelMetrics

            font: cpuLabel.font
            text: i18n("100%")
        }

        Row {
            id: indicators

            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            width: representation.indicatorWidth
            height: parent.height
            spacing: representation.indicatorSpacing
            visible: representation.indicatorCount > 0

            QQC2.Label {
                id: cpuLabel

                width: representation.cpuLabelWidth
                height: parent.height
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight
                text: root.sensorReady
                    ? i18n("%1%", Math.round(root.cpuUsage))
                    : i18n("--%")
                visible: Plasmoid.configuration.showCpuUsage
            }

            CpuTemperature {
                width: representation.temperatureWidth
                height: representation.usagePieSize
                anchors.verticalCenter: parent.verticalCenter
                sensorId: root.cpuTemperatureSensorId
                visible: Plasmoid.configuration.showCpuTemperature
            }

            UsagePie {
                width: representation.usagePieSize
                height: width
                anchors.verticalCenter: parent.verticalCenter
                title: i18n("Memory")
                sensorId: "memory/physical/usedPercent"
                color: root.memoryPieColor
                visible: Plasmoid.configuration.showMemoryUsage
            }

            UsagePie {
                width: representation.usagePieSize
                height: width
                anchors.verticalCenter: parent.verticalCenter
                title: i18n("Disk")
                sensorId: "disk/all/usedPercent"
                color: root.diskPieColor
                visible: Plasmoid.configuration.showDiskUsage
            }

            NetworkRate {
                id: networkRate

                width: implicitWidth
                height: parent.height
                visible: Plasmoid.configuration.showNetworkRate && fits
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
