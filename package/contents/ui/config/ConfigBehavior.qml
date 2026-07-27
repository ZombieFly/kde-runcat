import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import org.kde.kcmutils as KCM
import org.kde.kirigami as Kirigami

KCM.SimpleKCM {
    property alias cfg_useIdleFrame: useIdleFrame.checked
    property bool cfg_useIdleFrameDefault
    property alias cfg_idleThreshold: idleThreshold.value
    property int cfg_idleThresholdDefault
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
            text: i18n("Run in the opposite direction")
        }

        CheckBox {
            id: showCpuUsage
            text: i18n("Show CPU usage next to the cat")
        }

        CheckBox {
            id: reverseSpeed
            text: i18n("Reverse speed response to CPU usage")
        }

        Label {
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            text: i18n("When enabled, the cat runs faster at low CPU usage and slower at high CPU usage.")
            opacity: 0.7
        }
    }
}
