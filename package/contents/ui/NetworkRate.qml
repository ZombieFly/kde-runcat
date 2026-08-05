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
    property string iconName: "network-wired-symbolic"
    property string downloadPrefix: "↓"
    property string uploadPrefix: "↑"
    property string downloadName: i18n("Download")
    property string uploadName: i18n("Upload")

    readonly property string downloadText: downloadAvailable
        ? downloadRate : i18n("Unavailable")
    readonly property string uploadText: uploadAvailable
        ? uploadRate : i18n("Unavailable")
    readonly property real iconSize: Math.min(
        height,
        Kirigami.Units.iconSizes.smallMedium
    )
    readonly property real textWidth: Kirigami.Units.gridUnit * 4
    readonly property real prefixWidth: Math.ceil(Math.max(
        downloadPrefixMetrics.advanceWidth,
        uploadPrefixMetrics.advanceWidth
    ))

    implicitWidth: iconSize + spacing + textWidth
    implicitHeight: Math.max(iconSize, rates.implicitHeight)
    Accessible.name: i18n(
        "%1: %2; %3: %4",
        downloadName,
        downloadText,
        uploadName,
        uploadText
    )

    TextMetrics {
        id: downloadPrefixMetrics

        font: Kirigami.Theme.smallFont
        text: root.downloadPrefix
    }

    TextMetrics {
        id: uploadPrefixMetrics

        font: Kirigami.Theme.smallFont
        text: root.uploadPrefix
    }

    Row {
        anchors.fill: parent
        spacing: root.spacing

        Kirigami.Icon {
            width: root.iconSize
            height: width
            anchors.verticalCenter: parent.verticalCenter
            source: root.iconName
            color: Kirigami.Theme.textColor
            opacity: root.downloadAvailable || root.uploadAvailable ? 1 : 0.45
        }

        Column {
            id: rates

            width: root.textWidth
            anchors.verticalCenter: parent.verticalCenter
            spacing: 0

            Row {
                width: parent.width
                spacing: Kirigami.Units.smallSpacing

                QQC2.Label {
                    width: root.prefixWidth
                    font: Kirigami.Theme.smallFont
                    text: root.downloadPrefix
                    horizontalAlignment: Text.AlignRight
                }

                QQC2.Label {
                    width: parent.width - root.prefixWidth - parent.spacing
                    font: Kirigami.Theme.smallFont
                    elide: Text.ElideRight
                    text: root.downloadText
                }
            }

            Row {
                width: parent.width
                spacing: Kirigami.Units.smallSpacing

                QQC2.Label {
                    width: root.prefixWidth
                    font: Kirigami.Theme.smallFont
                    text: root.uploadPrefix
                    horizontalAlignment: Text.AlignRight
                }

                QQC2.Label {
                    width: parent.width - root.prefixWidth - parent.spacing
                    font: Kirigami.Theme.smallFont
                    elide: Text.ElideRight
                    text: root.uploadText
                }
            }
        }
    }

    HoverHandler {
        id: hoverHandler
    }

    QQC2.ToolTip.visible: hoverHandler.hovered
    QQC2.ToolTip.text: i18n(
        "%1: %2\n%3: %4",
        downloadName,
        downloadText,
        uploadName,
        uploadText
    )
    QQC2.ToolTip.delay: Kirigami.Units.toolTipDelay
}
