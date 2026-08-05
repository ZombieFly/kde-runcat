pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls as QQC2

import org.kde.kirigami as Kirigami
import org.kde.ksysguard.sensors as Sensors
import org.kde.quickcharts as Charts

Item {
    id: root

    required property real ringSize
    required property string title
    required property string usageSensorId
    required property string usedSensorId
    required property string totalSensorId
    required property string iconName
    required property color color
    property bool showText: false
    property real spacing: Kirigami.Units.smallSpacing

    readonly property real usageValue: Number(usageSensor.value)
    readonly property bool usageAvailable:
        usageSensor.status === Sensors.Sensor.Ready
        && Number.isFinite(usageValue)
    readonly property real usage: usageAvailable
        ? Math.max(0, Math.min(100, usageValue)) : 0
    readonly property bool detailAvailable:
        usedSensor.status === Sensors.Sensor.Ready
        && totalSensor.status === Sensors.Sensor.Ready
        && String(usedSensor.formattedValue || "").length > 0
        && String(totalSensor.formattedValue || "").length > 0
    readonly property string usedText: detailAvailable
        ? usedSensor.formattedValue : i18n("Unavailable")
    readonly property string totalText: detailAvailable
        ? totalSensor.formattedValue : i18n("Unavailable")
    readonly property string detailText: detailAvailable
        ? i18n(
            "%1 / %2",
            usedText,
            totalText
        )
        : i18n("Unavailable")
    readonly property string accessibleText: usageAvailable
        ? i18n("%1: %2%, %3", title, Math.round(usage), detailText)
        : i18n("%1: unavailable", title)
    readonly property real textWidth: Math.ceil(Math.max(
        usedTextMetrics.advanceWidth,
        totalTextMetrics.advanceWidth
    ))

    implicitWidth: ringSize + (showText ? spacing + textWidth : 0)
    implicitHeight: ringSize
    Accessible.name: accessibleText

    TextMetrics {
        id: usedTextMetrics

        font: Kirigami.Theme.smallFont
        text: root.usedText
    }

    TextMetrics {
        id: totalTextMetrics

        font: Kirigami.Theme.smallFont
        text: root.totalText
    }

    Sensors.Sensor {
        id: usageSensor

        sensorId: root.usageSensorId
        enabled: root.visible
        updateRateLimit: 1000
    }

    Sensors.Sensor {
        id: usedSensor

        sensorId: root.usedSensorId
        enabled: root.visible
        updateRateLimit: 1000
    }

    Sensors.Sensor {
        id: totalSensor

        sensorId: root.totalSensorId
        enabled: root.visible
        updateRateLimit: 1000
    }

    Row {
        anchors.fill: parent
        spacing: root.showText ? root.spacing : 0

        Item {
            width: root.ringSize
            height: root.ringSize
            anchors.verticalCenter: parent.verticalCenter

            Charts.PieChart {
                anchors.fill: parent

                valueSources: Charts.SingleValueSource {
                    value: root.usage
                }
                colorSource: Charts.ArraySource {
                    array: [root.color]
                }
                nameSource: Charts.ArraySource {
                    array: [root.title]
                }
                range.from: 0
                range.to: 100
                range.automatic: false
                thickness: Math.max(2, root.ringSize * 0.12)
                smoothEnds: true
                backgroundColor: Kirigami.ColorUtils.linearInterpolation(
                    Kirigami.Theme.backgroundColor,
                    Kirigami.Theme.textColor,
                    0.16
                )
                opacity: root.usageAvailable ? 1 : 0.45
            }

            Kirigami.Icon {
                anchors.centerIn: parent
                width: Math.round(root.ringSize * 0.42)
                height: width
                source: root.iconName
                color: Kirigami.Theme.textColor
                opacity: root.usageAvailable ? 1 : 0.45
            }
        }

        Column {
            width: root.showText ? root.textWidth : 0
            anchors.verticalCenter: parent.verticalCenter
            spacing: 0
            visible: root.showText

            QQC2.Label {
                width: parent.width
                font: Kirigami.Theme.smallFont
                elide: Text.ElideRight
                text: root.usedText
            }

            QQC2.Label {
                width: parent.width
                font: Kirigami.Theme.smallFont
                elide: Text.ElideRight
                opacity: 0.7
                text: root.totalText
            }
        }
    }

    HoverHandler { id: hoverHandler }

    QQC2.ToolTip.visible: hoverHandler.hovered
    QQC2.ToolTip.text: root.accessibleText
    QQC2.ToolTip.delay: Kirigami.Units.toolTipDelay
}
