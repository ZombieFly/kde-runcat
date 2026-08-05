pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls as QQC2

import org.kde.kirigami as Kirigami
import org.kde.ksysguard.sensors as Sensors
import org.kde.quickcharts as Charts

Item {
    id: root

    required property string title
    required property string sensorId
    required property color color

    readonly property real sensorValue: Number(sensor.value)
    readonly property bool available: sensor.status === Sensors.Sensor.Ready
        && Number.isFinite(sensorValue)
    readonly property real usage: available
        ? Math.max(0, Math.min(100, sensorValue))
        : 0
    readonly property string valueText: available
        ? i18n("%1: %2%", title, Math.round(usage))
        : i18n("%1: unavailable", title)

    Accessible.name: valueText

    Sensors.Sensor {
        id: sensor

        sensorId: root.sensorId
        enabled: root.visible
        updateRateLimit: 1000
    }

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
        filled: true
        backgroundColor: Kirigami.ColorUtils.linearInterpolation(
            Kirigami.Theme.backgroundColor,
            Kirigami.Theme.textColor,
            0.16
        )
        opacity: root.available ? 1 : 0.45
    }

    HoverHandler {
        id: hoverHandler
    }

    QQC2.ToolTip.visible: hoverHandler.hovered
    QQC2.ToolTip.text: valueText
    QQC2.ToolTip.delay: Kirigami.Units.toolTipDelay
}
