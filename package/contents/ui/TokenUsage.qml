pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls as QQC2

import org.kde.kirigami as Kirigami
import org.kde.plasma.plasma5support as Plasma5Support

Item {
    id: root

    property int claudeContextWindow: 200000
    property bool showCodex: true
    property bool showClaude: true
    property bool showDaily: true
    property int codexTodayTokens: 0
    property int codexContextTokens: 0
    property int codexContextWindow: 0
    property int claudeTodayTokens: 0
    property int claudeContextTokens: 0
    property bool codexAvailable: false
    property bool claudeAvailable: false
    property string codexUpdatedAt: ""
    property string claudeUpdatedAt: ""

    readonly property real gaugeSize: Math.round(
        Math.min(height, Kirigami.Units.iconSizes.medium) * 0.9
    )
    readonly property real codexPercent: contextPercent(
        codexContextTokens, codexContextWindow
    )
    readonly property real claudePercent: contextPercent(
        claudeContextTokens, claudeContextWindow
    )
    readonly property string scriptPath: decodeURIComponent(
        Qt.resolvedUrl("../code/token_usage.py").toString()
            .replace(/^file:\/\//, "")
    )
    readonly property string command: "/usr/bin/python3 "
        + shellQuote(scriptPath)
        + " --claude-context-window " + claudeContextWindow

    function shellQuote(value) {
        return "'" + value.replace(/'/g, "'\\''") + "'";
    }

    function contextPercent(tokens, windowTokens) {
        if (windowTokens <= 0) {
            return 0;
        }
        return Math.max(0, Math.min(100, tokens / windowTokens * 100));
    }

    function formatTokens(tokens) {
        const value = Math.max(0, Number(tokens));
        let scaled;
        let suffix;
        if (value >= 1000000) {
            scaled = value / 1000000;
            suffix = "m";
        } else {
            scaled = value / 1000;
            suffix = "k";
        }
        return scaled.toFixed(1).replace(/\.0$/, "") + suffix;
    }

    function updateUsage(rawOutput) {
        try {
            const value = JSON.parse(String(rawOutput).trim());
            const codex = value.codex || {};
            const claude = value.claude || {};
            codexAvailable = Boolean(codex.available);
            codexTodayTokens = Number(codex.todayTokens) || 0;
            codexContextTokens = Number(codex.contextTokens) || 0;
            codexContextWindow = Number(codex.contextWindow) || 0;
            codexUpdatedAt = String(codex.updatedAt || "");
            claudeAvailable = Boolean(claude.available);
            claudeTodayTokens = Number(claude.todayTokens) || 0;
            claudeContextTokens = Number(claude.contextTokens) || 0;
            claudeUpdatedAt = String(claude.updatedAt || "");
        } catch (error) {
            console.warn("RunCat could not parse token usage:", error);
        }
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

    Plasma5Support.DataSource {
        id: tokenSource

        engine: "executable"
        connectedSources: root.visible ? [root.command] : []
        interval: 30000

        onNewData: function(sourceName, data) {
            if (sourceName === root.command
                    && Number(data["exit code"]) === 0) {
                root.updateUsage(data["stdout"]);
            }
        }
    }

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
            visible: root.showDaily

            QQC2.Label {
                font: Kirigami.Theme.smallFont
                color: "#10a37f"
                text: i18n(
                    "codex: %1",
                    root.formatTokens(root.codexTodayTokens)
                )
            }

            QQC2.Label {
                font: Kirigami.Theme.smallFont
                color: "#d97757"
                text: i18n(
                    "claude: %1",
                    root.formatTokens(root.claudeTodayTokens)
                )
            }
        }
    }
}
