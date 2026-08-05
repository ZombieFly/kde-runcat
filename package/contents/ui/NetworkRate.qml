pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls as QQC2

import org.kde.kirigami as Kirigami
import org.kde.ksysguard.sensors as Sensors

Item {
    id: root

    readonly property bool fits: height >= rates.implicitHeight
    readonly property string downloadText: downloadSensor.status
        === Sensors.Sensor.Ready
        ? downloadSensor.formattedValue
        : i18n("Unavailable")
    readonly property string uploadText: uploadSensor.status
        === Sensors.Sensor.Ready
        ? uploadSensor.formattedValue
        : i18n("Unavailable")

    implicitWidth: Kirigami.Units.gridUnit * 4
    implicitHeight: rates.implicitHeight
    Accessible.name: i18n(
        "Download: %1; Upload: %2",
        downloadText,
        uploadText
    )

    Sensors.Sensor {
        id: downloadSensor

        sensorId: "network/all/download"
        enabled: root.visible
        updateRateLimit: 1000
    }

    Sensors.Sensor {
        id: uploadSensor

        sensorId: "network/all/upload"
        enabled: root.visible
        updateRateLimit: 1000
    }

    Column {
        id: rates

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        spacing: 0

        QQC2.Label {
            width: parent.width
            font: Kirigami.Theme.smallFont
            color: "#00bcd4"
            elide: Text.ElideRight
            text: i18n("↓ %1", root.downloadText)
        }

        QQC2.Label {
            width: parent.width
            font: Kirigami.Theme.smallFont
            color: "#9b59b6"
            elide: Text.ElideRight
            text: i18n("↑ %1", root.uploadText)
        }
    }

    HoverHandler {
        id: hoverHandler
    }

    QQC2.ToolTip.visible: hoverHandler.hovered
    QQC2.ToolTip.text: i18n(
        "Download: %1\nUpload: %2",
        downloadText,
        uploadText
    )
    QQC2.ToolTip.delay: Kirigami.Units.toolTipDelay
}
