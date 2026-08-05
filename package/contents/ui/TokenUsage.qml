pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls as QQC2

import org.kde.kirigami as Kirigami

import "../code/token_format.js" as TokenFormat

Item {
    id: root

    required property url iconSource
    required property string title
    required property color ringColor
    required property int todayTokens
    required property int contextTokens
    required property int contextWindow
    required property bool available
    required property string updatedAt
    property bool showText: false
    property real spacing: Kirigami.Units.smallSpacing

    readonly property real gaugeSize: Math.round(
        Math.min(height, Kirigami.Units.iconSizes.medium) * 0.9
    )
    readonly property real percent: contextWindow > 0
        ? Math.max(0, Math.min(100, contextTokens / contextWindow * 100)) : 0
    readonly property string contextText: available
        ? TokenFormat.formatTokens(contextTokens) : i18n("Unavailable")
    readonly property string todayText: available
        ? TokenFormat.formatTokens(todayTokens) : i18n("Unavailable")
    readonly property real textWidth: Math.ceil(Math.max(
        contextTextMetrics.advanceWidth,
        todayTextMetrics.advanceWidth
    ))

    implicitWidth: gaugeSize + (showText ? spacing + textWidth : 0)
    implicitHeight: gaugeSize

    TextMetrics {
        id: contextTextMetrics

        font: Kirigami.Theme.smallFont
        text: root.contextText
    }

    TextMetrics {
        id: todayTextMetrics

        font: Kirigami.Theme.smallFont
        text: root.todayText
    }

    Row {
        anchors.fill: parent
        spacing: root.showText ? root.spacing : 0

        TokenRing {
            anchors.verticalCenter: parent.verticalCenter
            size: root.gaugeSize
            iconSource: root.iconSource
            title: root.title
            percent: root.percent
            available: root.available
            color: root.ringColor
            todayTokens: root.todayTokens
            contextTokens: root.contextTokens
            contextWindow: root.contextWindow
            updatedAt: root.updatedAt
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
                text: root.contextText
            }

            QQC2.Label {
                width: parent.width
                font: Kirigami.Theme.smallFont
                elide: Text.ElideRight
                opacity: 0.7
                text: root.todayText
            }
        }
    }
}
