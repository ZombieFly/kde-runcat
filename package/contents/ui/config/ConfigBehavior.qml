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
