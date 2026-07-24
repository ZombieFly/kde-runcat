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
    property alias cfg_slowCycleMs: slowCycleMs.value
    property int cfg_slowCycleMsDefault
    property alias cfg_fastCycleMs: fastCycleMs.value
    property int cfg_fastCycleMsDefault
    property alias cfg_maxFps: maxFps.value
    property int cfg_maxFpsDefault
    property alias cfg_smoothingPercent: smoothingPercent.value
    property int cfg_smoothingPercentDefault
    property alias cfg_flipHorizontally: flipHorizontally.checked
    property bool cfg_flipHorizontallyDefault

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
            id: slowCycleMs
            from: 500
            to: 5000
            stepSize: 100
            editable: true
            Kirigami.FormData.label: i18n("Slow cycle:")
            textFromValue: function(value) { return i18n("%1 ms", value); }
            valueFromText: function(text) { return parseInt(text, 10); }
        }

        SpinBox {
            id: fastCycleMs
            from: 100
            to: 2000
            stepSize: 50
            editable: true
            Kirigami.FormData.label: i18n("Fast cycle:")
            textFromValue: function(value) { return i18n("%1 ms", value); }
            valueFromText: function(text) { return parseInt(text, 10); }
        }

        SpinBox {
            id: maxFps
            from: 5
            to: 60
            stepSize: 5
            Kirigami.FormData.label: i18n("Maximum frame rate:")
            textFromValue: function(value) { return i18n("%1 FPS", value); }
            valueFromText: function(text) { return parseInt(text, 10); }
        }

        SpinBox {
            id: smoothingPercent
            from: 5
            to: 100
            stepSize: 5
            Kirigami.FormData.label: i18n("Responsiveness:")
            textFromValue: function(value) { return i18n("%1%", value); }
            valueFromText: function(text) { return parseInt(text, 10); }
        }

        Label {
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            text: i18n("Lower responsiveness produces steadier speed changes; higher responsiveness follows CPU spikes more closely.")
            opacity: 0.7
        }

        CheckBox {
            id: flipHorizontally
            text: i18n("Run in the opposite direction")
        }
    }
}
