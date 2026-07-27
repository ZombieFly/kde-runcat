pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts

import org.kde.kirigami as Kirigami
import org.kde.ksysguard.sensors as Sensors

ColumnLayout {
    id: root

    required property string localIpv4SensorId

    spacing: Kirigami.Units.largeSpacing

    Sensors.Sensor {
        id: downloadSensor

        sensorId: "network/all/download"
        updateRateLimit: 1000
    }

    Sensors.Sensor {
        id: uploadSensor

        sensorId: "network/all/upload"
        updateRateLimit: 1000
    }

    Sensors.Sensor {
        id: localIpv4Sensor

        sensorId: root.localIpv4SensorId
        enabled: root.localIpv4SensorId.length > 0
        updateRateLimit: 5000
    }

    Item {
        Layout.fillHeight: true
    }

    RowLayout {
        Layout.fillWidth: true
        Layout.minimumWidth: 0
        spacing: Kirigami.Units.smallSpacing

        Kirigami.Icon {
            source: "network-connect"
            color: Kirigami.Theme.textColor
            implicitWidth: Kirigami.Units.iconSizes.smallMedium
            implicitHeight: implicitWidth
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.minimumWidth: 0
            spacing: 0

            Kirigami.Heading {
                Layout.fillWidth: true
                level: 5
                text: i18n("Local IPv4")
            }

            Kirigami.Heading {
                Layout.fillWidth: true
                elide: Text.ElideRight
                level: 4
                text: localIpv4Sensor.formattedValue || i18n("Unavailable")
            }
        }
    }

    RowLayout {
        Layout.fillWidth: true
        Layout.minimumWidth: 0
        spacing: Kirigami.Units.smallSpacing

        Kirigami.Icon {
            source: "arrow-down"
            color: Kirigami.Theme.highlightColor
            implicitWidth: Kirigami.Units.iconSizes.smallMedium
            implicitHeight: implicitWidth
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.minimumWidth: 0
            spacing: 0

            Kirigami.Heading {
                Layout.fillWidth: true
                level: 5
                text: i18n("Download")
            }

            Kirigami.Heading {
                Layout.fillWidth: true
                elide: Text.ElideRight
                level: 3
                text: downloadSensor.formattedValue || i18n("Unavailable")
            }
        }
    }

    RowLayout {
        Layout.fillWidth: true
        Layout.minimumWidth: 0
        spacing: Kirigami.Units.smallSpacing

        Kirigami.Icon {
            source: "arrow-up"
            color: Kirigami.Theme.positiveTextColor
            implicitWidth: Kirigami.Units.iconSizes.smallMedium
            implicitHeight: implicitWidth
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.minimumWidth: 0
            spacing: 0

            Kirigami.Heading {
                Layout.fillWidth: true
                level: 5
                text: i18n("Upload")
            }

            Kirigami.Heading {
                Layout.fillWidth: true
                elide: Text.ElideRight
                level: 3
                text: uploadSensor.formattedValue || i18n("Unavailable")
            }
        }
    }

    Item {
        Layout.fillHeight: true
    }
}
