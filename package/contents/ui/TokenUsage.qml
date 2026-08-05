pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls as QQC2

import org.kde.kirigami as Kirigami

import "../code/token_format.js" as TokenFormat

Item {
    id: root

    property bool showCodex: true
    property bool showClaude: true
    required property int codexTodayTokens
    required property int codexContextTokens
    required property int codexContextWindow
    required property int claudeTodayTokens
    required property int claudeContextTokens
    required property int claudeContextWindow
    required property bool codexAvailable
    required property bool claudeAvailable
    required property string codexUpdatedAt
    required property string claudeUpdatedAt

    readonly property real gaugeSize: Math.round(
        Math.min(height, Kirigami.Units.iconSizes.medium) * 0.9
    )
    readonly property real codexPercent: contextPercent(
        codexContextTokens, codexContextWindow
    )
    readonly property real claudePercent: contextPercent(
        claudeContextTokens, claudeContextWindow
    )
    function contextPercent(tokens, windowTokens) {
        if (windowTokens <= 0) {
            return 0;
        }
        return Math.max(0, Math.min(100, tokens / windowTokens * 100));
    }

    implicitWidth: indicators.implicitWidth
    implicitHeight: indicators.implicitHeight
    Accessible.name: i18n(
        "Codex today: %1 tokens, context: %2%; Claude today: %3 tokens, context: %4%",
        codexTodayTokens,
        Math.round(codexPercent),
        claudeTodayTokens,
        Math.round(claudePercent)
    )

    Row {
        id: indicators

        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        spacing: Kirigami.Units.smallSpacing

        TokenRing {
            size: root.gaugeSize
            iconSource: Qt.resolvedUrl("../images/brands/codex.svg")
            title: i18n("Codex")
            percent: root.codexPercent
            available: root.codexAvailable
            color: "#10a37f"
            todayTokens: root.codexTodayTokens
            contextTokens: root.codexContextTokens
            contextWindow: root.codexContextWindow
            updatedAt: root.codexUpdatedAt
            visible: root.showCodex
        }

        TokenRing {
            size: root.gaugeSize
            iconSource: Qt.resolvedUrl("../images/brands/claude.svg")
            title: i18n("Claude Code")
            percent: root.claudePercent
            available: root.claudeAvailable
            color: "#d97757"
            todayTokens: root.claudeTodayTokens
            contextTokens: root.claudeContextTokens
            contextWindow: root.claudeContextWindow
            updatedAt: root.claudeUpdatedAt
            visible: root.showClaude
        }

        Column {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 0
            visible: root.showCodex || root.showClaude

            QQC2.Label {
                font: Kirigami.Theme.smallFont
                color: "#10a37f"
                visible: root.showCodex
                text: i18n(
                    "codex: %1",
                    TokenFormat.formatTokens(root.codexTodayTokens)
                )
            }

            QQC2.Label {
                font: Kirigami.Theme.smallFont
                color: "#d97757"
                visible: root.showClaude
                text: i18n(
                    "claude: %1",
                    TokenFormat.formatTokens(root.claudeTodayTokens)
                )
            }
        }
    }
}
