pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls as QQC2

import org.kde.kirigami as Kirigami
import org.kde.ksysguard.sensors as Sensors

Item {
    id: root

    required property string sensorId

    property color color: "#f67400"
    property color hotColor: "#da4453"
    property real hotThreshold: 60

    readonly property real sensorValue: Number(sensor.value)
    readonly property bool available: sensor.status === Sensors.Sensor.Ready
        && Number.isFinite(sensorValue)
    readonly property real temperature: available
        ? Math.max(0, Math.min(100, sensorValue))
        : 0
    readonly property color displayColor: sensorValue > hotThreshold
        ? hotColor
        : color
    readonly property string valueText: available
        ? i18n("CPU temperature: %1", sensor.formattedValue)
        : i18n("CPU temperature: unavailable")
    readonly property color inactiveColor: Kirigami.ColorUtils.linearInterpolation(
        Kirigami.Theme.backgroundColor,
        Kirigami.Theme.textColor,
        0.2
    )

    implicitWidth: Math.round(implicitHeight * 0.45)
    implicitHeight: Kirigami.Units.iconSizes.medium
    Accessible.name: valueText

    Sensors.Sensor {
        id: sensor

        sensorId: root.sensorId
        enabled: root.visible && root.sensorId.length > 0
        updateRateLimit: 1000
    }

    Item {
        anchors.centerIn: parent
        width: Math.min(parent.width, Math.round(parent.height * 0.45))
        height: parent.height
        opacity: root.available ? 1 : 0.45

        Rectangle {
            id: tube

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: Math.max(1, Math.round(parent.height * 0.04))
            width: Math.max(6, Math.round(parent.width * 0.42))
            height: parent.height - bulb.height * 0.72 - anchors.topMargin
            radius: width / 2
            color: root.inactiveColor
            border.width: 1
            border.color: Kirigami.ColorUtils.linearInterpolation(
                Kirigami.Theme.backgroundColor,
                Kirigami.Theme.textColor,
                0.35
            )

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.margins: 2
                height: Math.max(
                    0,
                    (parent.height - anchors.margins * 2)
                        * root.temperature / 100
                )
                radius: width / 2
                color: root.available ? root.displayColor : root.inactiveColor
            }
        }

        Rectangle {
            id: bulb

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            width: Math.max(6, Math.round(parent.width * 0.7))
            height: width
            radius: width / 2
            color: root.available ? root.displayColor : root.inactiveColor
        }
    }

    HoverHandler {
        id: hoverHandler
    }

    QQC2.ToolTip.visible: hoverHandler.hovered
    QQC2.ToolTip.text: valueText
    QQC2.ToolTip.delay: Kirigami.Units.toolTipDelay
}
