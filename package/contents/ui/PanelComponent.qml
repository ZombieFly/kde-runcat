pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Effects

import org.kde.kirigami as Kirigami

import "../code/animation.js" as Animation
import "../code/runners.js" as RunnerSelection

Item {
    id: root

    required property string componentType
    required property var componentSettings
    required property real cpuUsage
    required property real smoothedCpu
    required property bool sensorReady
    required property string cpuTemperatureSensorId
    property bool vertical: false
    property real contentSpacing: Kirigami.Units.smallSpacing
    readonly property real resourceRingSize: Math.round(
        Math.min(availableHeight, Kirigami.Units.iconSizes.medium) * 0.9
    )

    readonly property real availableHeight: height > 0
        ? height : Kirigami.Units.iconSizes.medium
    readonly property string runnerId: RunnerSelection.normalizeRunnerId(
        String(componentSettings.runner || "cat")
    )
    readonly property real runnerAspectRatio:
        RunnerSelection.aspectRatio(runnerId)
    readonly property real runnerImplicitWidth: vertical
        ? Kirigami.Units.iconSizes.medium
        : Math.round(runnerImplicitHeight * runnerAspectRatio)
    readonly property real runnerImplicitHeight: vertical
        ? Math.round(Kirigami.Units.iconSizes.medium / runnerAspectRatio)
        : Kirigami.Units.iconSizes.medium

    implicitWidth: {
        switch (componentType) {
        case "runner":
            return runnerImplicitWidth
                + (Boolean(componentSettings.showCpuUsage)
                    ? contentSpacing + cpuMetrics.advanceWidth : 0);
        case "cpuTemperature":
            return Math.round(availableHeight * 0.45);
        case "memory":
        case "disk":
            return componentLoader.item
                ? Number(componentLoader.item.implicitWidth)
                    || resourceRingSize
                : resourceRingSize;
        case "network":
            return Kirigami.Units.gridUnit * 4;
        case "ai":
            return componentLoader.item
                ? Number(componentLoader.item.implicitWidth) || 0 : 0;
        }
        return 0;
    }
    implicitHeight: Kirigami.Units.iconSizes.medium

    TextMetrics {
        id: cpuMetrics

        font: Kirigami.Theme.defaultFont
        // This is only a width sentinel, not user-facing text.
        text: "100%"
    }

    Loader {
        id: componentLoader

        anchors.centerIn: parent
        width: root.width
        height: root.componentType === "runner"
            ? Math.min(root.height, root.runnerImplicitHeight)
            : root.height
        sourceComponent: {
            switch (root.componentType) {
            case "runner": return runnerComponent;
            case "cpuTemperature": return cpuTemperatureComponent;
            case "memory": return memoryComponent;
            case "disk": return diskComponent;
            case "network": return networkComponent;
            case "ai": return aiComponent;
            }
            return null;
        }
    }

    Component {
        id: runnerComponent

        Item {
            id: runnerContent

            Row {
                anchors.centerIn: parent
                width: implicitWidth
                height: Math.min(parent.height, root.runnerImplicitHeight)
                spacing: cpuLabel.visible ? root.contentSpacing : 0

                Item {
                    id: runner

                    readonly property string runnerId: root.runnerId
                    readonly property var runningFrames:
                        RunnerSelection.frameOrder(runnerId).map(
                            function(frameNumber) {
                                return Qt.resolvedUrl(
                                    "../images/" + runner.runnerId + "/run-"
                                        + frameNumber + ".png"
                                );
                            }
                        )
                    readonly property url idleFrame: runnerId === "cat"
                        ? Qt.resolvedUrl("../images/cat/idle.png")
                        : runningFrames[0]
                    readonly property bool isIdle:
                        Boolean(root.componentSettings.useIdleFrame)
                        && root.sensorReady
                        && root.smoothedCpu <= Number(
                            root.componentSettings.idleThreshold || 0
                        )
                    readonly property real frameInterval:
                        Animation.frameInterval(
                            root.smoothedCpu,
                            runningFrames.length,
                            2500,
                            150,
                            30,
                            Boolean(root.componentSettings.reverseSpeed),
                            Number(root.componentSettings.speedPercent || 100)
                        )
                    property int frameIndex: 0

                    width: Math.min(root.runnerImplicitWidth,
                        height * root.runnerAspectRatio)
                    height: parent.height

                    onRunnerIdChanged: frameIndex = 0

                    transform: Scale {
                        origin.x: runner.width / 2
                        origin.y: runner.height / 2
                        xScale: Boolean(
                            root.componentSettings.flipHorizontally
                        ) ? -1 : 1
                    }

                    Repeater {
                        model: runner.runningFrames

                        Image {
                            required property int index
                            required property url modelData

                            anchors.fill: parent
                            source: modelData
                            fillMode: Image.PreserveAspectFit
                            asynchronous: false
                            cache: true
                            visible: !runner.isIdle
                                && index === runner.frameIndex
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
                        source: runner.idleFrame
                        fillMode: Image.PreserveAspectFit
                        asynchronous: false
                        cache: true
                        visible: runner.isIdle
                        layer.enabled: true
                        layer.effect: MultiEffect {
                            brightness: 1
                            colorization: 1
                            colorizationColor: Kirigami.Theme.textColor
                        }
                    }

                    Timer {
                        interval: runner.frameInterval
                        repeat: true
                        running: root.visible && !runner.isIdle
                        onTriggered: runner.frameIndex = (runner.frameIndex + 1)
                            % runner.runningFrames.length
                    }
                }

                QQC2.Label {
                    id: cpuLabel

                    width: visible ? cpuMetrics.advanceWidth : 0
                    height: parent.height
                    visible: Boolean(root.componentSettings.showCpuUsage)
                    text: root.sensorReady
                        ? i18n("%1%", Math.round(root.cpuUsage)) : i18n("--%")
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignRight
                }
            }
        }
    }

    Component {
        id: cpuTemperatureComponent

        CpuTemperature {
            sensorId: root.cpuTemperatureSensorId
        }
    }

    Component {
        id: memoryComponent

        ResourceRing {
            ringSize: root.resourceRingSize
            title: i18n("Memory Usage")
            usageSensorId: "memory/physical/usedPercent"
            usedSensorId: "memory/physical/used"
            totalSensorId: "memory/physical/total"
            iconName: "memory"
            color: "#3daee9"
            showText: Boolean(root.componentSettings.showText)
            spacing: root.contentSpacing
        }
    }

    Component {
        id: diskComponent

        ResourceRing {
            ringSize: root.resourceRingSize
            title: i18n("Disk Usage")
            usageSensorId: "disk/all/usedPercent"
            usedSensorId: "disk/all/used"
            totalSensorId: "disk/all/total"
            iconName: "drive-harddisk-symbolic"
            color: "#27ae60"
            showText: Boolean(root.componentSettings.showText)
            spacing: root.contentSpacing
        }
    }

    Component {
        id: networkComponent

        NetworkRate {}
    }

    Component {
        id: aiComponent

        TokenUsage {
            claudeContextWindow: Number(
                root.componentSettings.claudeContextWindow || 200000
            )
            showCodex: Boolean(root.componentSettings.showCodex)
            showClaude: Boolean(root.componentSettings.showClaude)
            showDaily: Boolean(root.componentSettings.showDaily)
        }
    }
}
