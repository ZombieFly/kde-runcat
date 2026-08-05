import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import org.kde.kcmutils as KCM
import org.kde.kirigami as Kirigami

import "../../code/runners.js" as RunnerSelection

KCM.SimpleKCM {
    id: behavior

    readonly property var runnerIds: RunnerSelection.availableRunnerIds()

    property alias cfg_useIdleFrame: useIdleFrame.checked
    property bool cfg_useIdleFrameDefault
    property alias cfg_idleThreshold: idleThreshold.value
    property int cfg_idleThresholdDefault
    property string cfg_runner
    property string cfg_runnerDefault
    property alias cfg_speedPercent: speedPercent.value
    property int cfg_speedPercentDefault
    property alias cfg_flipHorizontally: flipHorizontally.checked
    property bool cfg_flipHorizontallyDefault
    property alias cfg_showCpuUsage: showCpuUsage.checked
    property bool cfg_showCpuUsageDefault
    property alias cfg_showCpuTemperature: showCpuTemperature.checked
    property bool cfg_showCpuTemperatureDefault
    property alias cfg_showMemoryUsage: showMemoryUsage.checked
    property bool cfg_showMemoryUsageDefault
    property alias cfg_showDiskUsage: showDiskUsage.checked
    property bool cfg_showDiskUsageDefault
    property alias cfg_showNetworkRate: showNetworkRate.checked
    property bool cfg_showNetworkRateDefault
    property alias cfg_showCodexTokenUsage: showCodexTokenUsage.checked
    property bool cfg_showCodexTokenUsageDefault
    property alias cfg_showClaudeTokenUsage: showClaudeTokenUsage.checked
    property bool cfg_showClaudeTokenUsageDefault
    property alias cfg_showDailyTokenUsage: showDailyTokenUsage.checked
    property bool cfg_showDailyTokenUsageDefault
    property alias cfg_claudeContextWindow: claudeContextWindow.value
    property int cfg_claudeContextWindowDefault
    property alias cfg_indicatorSpacing: indicatorSpacing.value
    property int cfg_indicatorSpacingDefault
    property alias cfg_reverseSpeed: reverseSpeed.checked
    property bool cfg_reverseSpeedDefault

    Kirigami.FormLayout {
        CheckBox {
            id: useIdleFrame
            text: i18n("Rest when the system is idle")
        }

        SpinBox {
            id: idleThreshold
            from: 0
            to: 25
            stepSize: 1
            enabled: useIdleFrame.checked
            Kirigami.FormData.label: i18n("Idle threshold:")
            textFromValue: function(value) { return i18n("%1%", value); }
            valueFromText: function(text) { return parseInt(text, 10); }
        }

        ComboBox {
            id: runner

            model: [
                i18n("Cat"),
                i18n("Dog"),
                i18n("Slime"),
                i18n("Drop"),
                i18n("Coffee"),
                i18n("Newton's cradle"),
                i18n("Engine"),
                i18n("Mochi")
            ]
            currentIndex: Math.max(
                0,
                behavior.runnerIds.indexOf(behavior.cfg_runner)
            )
            Kirigami.FormData.label: i18n("Runner:")
            onActivated: behavior.cfg_runner = behavior.runnerIds[currentIndex]
        }

        SpinBox {
            id: speedPercent
            from: 25
            to: 200
            stepSize: 25
            Kirigami.FormData.label: i18n("Running speed:")
            textFromValue: function(value) { return i18n("%1%", value); }
            valueFromText: function(text) { return parseInt(text, 10); }
        }

        CheckBox {
            id: flipHorizontally
            text: i18n("Flip runner horizontally")
        }

        CheckBox {
            id: showCpuUsage
            text: i18n("Show CPU usage next to the runner")
        }

        CheckBox {
            id: showCpuTemperature
            text: i18n("Show CPU temperature next to the runner")
        }

        CheckBox {
            id: showMemoryUsage
            text: i18n("Show memory usage pie next to the runner")
        }

        CheckBox {
            id: showDiskUsage
            text: i18n("Show disk usage pie next to the runner")
        }

        CheckBox {
            id: showNetworkRate
            text: i18n("Show network rate next to the runner")
        }

        CheckBox {
            id: showCodexTokenUsage
            text: i18n("Show Codex context ring")
        }

        CheckBox {
            id: showClaudeTokenUsage
            text: i18n("Show Claude Code context ring")
        }

        CheckBox {
            id: showDailyTokenUsage
            text: i18n("Show today's Codex and Claude Code token usage")
        }

        SpinBox {
            id: claudeContextWindow

            from: 10000
            to: 2000000
            stepSize: 10000
            enabled: showClaudeTokenUsage.checked
            Kirigami.FormData.label: i18n("Claude context window:")
            textFromValue: function(value) {
                return i18n("%1K tokens", Math.round(value / 1000));
            }
            valueFromText: function(text) {
                return Math.max(10000, parseInt(text, 10) * 1000);
            }
        }

        SpinBox {
            id: indicatorSpacing

            from: 0
            to: 24
            stepSize: 1
            Kirigami.FormData.label: i18n("Indicator spacing:")
            textFromValue: function(value) { return i18n("%1 px", value); }
            valueFromText: function(text) { return parseInt(text, 10); }
        }

        CheckBox {
            id: reverseSpeed
            text: i18n("Reverse speed response to CPU usage")
        }

        Label {
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            text: i18n("When enabled, the runner moves faster at low CPU usage and slower at high CPU usage.")
            opacity: 0.7
        }
    }
}
