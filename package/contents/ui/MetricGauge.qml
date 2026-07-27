pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts

import org.kde.kirigami as Kirigami
import org.kde.ksysguard.sensors as Sensors
import org.kde.quickcharts as Charts

Item {
    id: root

    required property string title
    required property string sensorId

    property string totalSensorId: ""
    property string detailSensorId: ""
    property string detailTotalSensorId: ""
    property real maximumValue: 100
    property color color: Kirigami.Theme.highlightColor

    readonly property real sensorValue: Number(valueSensor.value)
    readonly property real totalValue: Number(totalSensor.value)
    readonly property bool usesRatio: totalSensorId.length > 0
    readonly property bool available: valueSensor.status === Sensors.Sensor.Ready
        && Number.isFinite(sensorValue)
        && (!usesRatio || (totalSensor.status === Sensors.Sensor.Ready
                           && Number.isFinite(totalValue)
                           && totalValue > 0))
    readonly property real displayValue: {
        if (!available) {
            return 0;
        }
        return usesRatio ? sensorValue / totalValue * 100 : sensorValue;
    }
    readonly property real chartValue: Math.max(0, Math.min(maximumValue, displayValue))
    readonly property bool hasDetails: detailSensor.status === Sensors.Sensor.Ready
        && detailTotalSensor.status === Sensors.Sensor.Ready
    readonly property string detailText: hasDetails
        ? i18n("%1 / %2", detailSensor.formattedValue, detailTotalSensor.formattedValue)
        : ""
    readonly property string valueText: {
        if (!available) {
            return i18n("Unavailable");
        }
        if (usesRatio) {
            return i18n("%1%", Math.round(displayValue));
        }
        return valueSensor.formattedValue;
    }

    implicitWidth: Kirigami.Units.gridUnit * 4
    implicitHeight: Kirigami.Units.gridUnit * 5

    Sensors.Sensor {
        id: valueSensor

        sensorId: root.sensorId
        enabled: root.sensorId.length > 0
        updateRateLimit: 1000
    }

    Sensors.Sensor {
        id: totalSensor

        sensorId: root.totalSensorId
        enabled: root.totalSensorId.length > 0
        updateRateLimit: 1000
    }

    Sensors.Sensor {
        id: detailSensor

        sensorId: root.detailSensorId
        enabled: root.detailSensorId.length > 0
        updateRateLimit: 1000
    }

    Sensors.Sensor {
        id: detailTotalSensor

        sensorId: root.detailTotalSensorId
        enabled: root.detailTotalSensorId.length > 0
        updateRateLimit: 1000
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumHeight: Kirigami.Units.gridUnit * 3

            Charts.PieChart {
                anchors.centerIn: parent
                width: Math.min(parent.width, parent.height)
                height: width

                valueSources: Charts.SingleValueSource {
                    value: root.chartValue
                }
                colorSource: Charts.ArraySource {
                    array: [root.color]
                }
                nameSource: Charts.ArraySource {
                    array: [root.title]
                }

                range.from: 0
                range.to: root.maximumValue
                range.automatic: false
                thickness: Math.max(4, Kirigami.Units.smallSpacing)
                smoothEnds: true
                backgroundColor: Kirigami.ColorUtils.linearInterpolation(
                    Kirigami.Theme.backgroundColor,
                    Kirigami.Theme.textColor,
                    0.12
                )
                opacity: root.available ? 1 : 0.45
            }

            Column {
                anchors.centerIn: parent
                width: parent.width - Kirigami.Units.gridUnit
                spacing: 0

                Kirigami.Heading {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    elide: Text.ElideRight
                    level: 4
                    text: root.valueText
                }
            }
        }

        Kirigami.Heading {
            Layout.fillWidth: true
            Layout.minimumWidth: 0
            horizontalAlignment: Text.AlignHCenter
            elide: Text.ElideRight
            level: 5
            text: root.title
        }

        Kirigami.Heading {
            Layout.fillWidth: true
            Layout.minimumWidth: 0
            horizontalAlignment: Text.AlignHCenter
            elide: Text.ElideRight
            level: 6
            text: root.detailText
            visible: text.length > 0
        }
    }
}
