pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls as QQC2

import org.kde.kirigami as Kirigami

Item {
    id: root

    required property string downloadRate
    required property string uploadRate
    required property bool downloadAvailable
    required property bool uploadAvailable
    property real spacing: Kirigami.Units.smallSpacing

    readonly property string downloadText: downloadAvailable
        ? downloadRate : i18n("Unavailable")
    readonly property string uploadText: uploadAvailable
        ? uploadRate : i18n("Unavailable")
    readonly property string shownDownloadText: i18n("↓ %1", downloadText)
    readonly property string shownUploadText: i18n("↑ %1", uploadText)
    readonly property real iconSize: Math.min(
        height,
        Kirigami.Units.iconSizes.smallMedium
    )
    readonly property real textWidth: Kirigami.Units.gridUnit * 4

    implicitWidth: iconSize + spacing + textWidth
    implicitHeight: Math.max(iconSize, rates.implicitHeight)
    Accessible.name: i18n(
        "Download: %1; Upload: %2",
        downloadText,
        uploadText
    )

    Row {
        anchors.fill: parent
        spacing: root.spacing

        Kirigami.Icon {
            width: root.iconSize
            height: width
            anchors.verticalCenter: parent.verticalCenter
            source: "network-wired-symbolic"
            color: Kirigami.Theme.textColor
            opacity: root.downloadAvailable || root.uploadAvailable ? 1 : 0.45
        }

        Column {
            id: rates

            width: root.textWidth
            anchors.verticalCenter: parent.verticalCenter
            spacing: 0

            QQC2.Label {
                width: parent.width
                font: Kirigami.Theme.smallFont
                elide: Text.ElideRight
                text: root.shownDownloadText
            }

            QQC2.Label {
                width: parent.width
                font: Kirigami.Theme.smallFont
                elide: Text.ElideRight
                text: root.shownUploadText
            }
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
