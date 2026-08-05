pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts

import org.kde.kirigami as Kirigami
import org.kde.plasma.extras as PlasmaExtras

PlasmaExtras.Representation {
    id: root

    required property string cpuTemperatureSensorId
    required property string gpuUsageSensorId
    required property string localIpv4SensorId

    readonly property real cardSpacing: Kirigami.Units.smallSpacing

    Layout.minimumWidth: Kirigami.Units.gridUnit * 34
    Layout.minimumHeight: Kirigami.Units.gridUnit * 17
    Layout.preferredWidth: Kirigami.Units.gridUnit * 38
    Layout.preferredHeight: Kirigami.Units.gridUnit * 19

    collapseMarginsHint: true

    Item {
        id: dashboard

        anchors.fill: parent
        anchors.margins: Kirigami.Units.largeSpacing

        Item {
            id: topRow

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            // The lower cards include an extra detail line, so give them a
            // little more room than the gauge-only top row.
            height: Math.floor(
                (parent.height - root.cardSpacing) / 2
                - Kirigami.Units.largeSpacing
            )

            Kirigami.Card {
                id: cpuCard

                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: Math.floor((parent.width - root.cardSpacing) * 2 / 3)

                header: Kirigami.Heading {
                    leftPadding: Kirigami.Units.smallSpacing
                    rightPadding: Kirigami.Units.smallSpacing
                    level: 4
                    text: i18n("CPU")
                }

                contentItem: RowLayout {
                    spacing: Kirigami.Units.smallSpacing

                    MetricGauge {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumWidth: 0
                        Layout.horizontalStretchFactor: 1
                        title: i18n("Usage")
                        sensorId: "cpu/all/usage"
                        color: Kirigami.Theme.highlightColor
                    }

                    MetricGauge {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumWidth: 0
                        Layout.horizontalStretchFactor: 1
                        title: i18n("Temperature")
                        sensorId: root.cpuTemperatureSensorId
                        maximumValue: 100
                        color: "#f67400"
                    }
                }
            }

            Kirigami.Card {
                anchors.left: cpuCard.right
                anchors.leftMargin: root.cardSpacing
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom

                header: Kirigami.Heading {
                    leftPadding: Kirigami.Units.smallSpacing
                    rightPadding: Kirigami.Units.smallSpacing
                    level: 4
                    text: i18n("GPU")
                }

                contentItem: MetricGauge {
                    title: i18n("Usage")
                    sensorId: root.gpuUsageSensorId
                    color: Kirigami.Theme.highlightColor
                }
            }
        }

        Item {
            id: bottomRow

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: topRow.bottom
            anchors.topMargin: root.cardSpacing
            anchors.bottom: parent.bottom

            readonly property real columnWidth: Math.floor(
                (width - root.cardSpacing * 2) / 3
            )

            Kirigami.Card {
                id: memoryCard

                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: bottomRow.columnWidth

                header: Kirigami.Heading {
                    leftPadding: Kirigami.Units.smallSpacing
                    rightPadding: Kirigami.Units.smallSpacing
                    level: 4
                    text: i18n("Memory")
                }

                contentItem: MetricGauge {
                    title: i18n("Usage")
                    sensorId: "memory/physical/usedPercent"
                    detailSensorId: "memory/physical/used"
                    detailTotalSensorId: "memory/physical/total"
                    color: "#3daee9"
                }
            }

            Kirigami.Card {
                id: diskCard

                anchors.left: memoryCard.right
                anchors.leftMargin: root.cardSpacing
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: bottomRow.columnWidth

                header: Kirigami.Heading {
                    leftPadding: Kirigami.Units.smallSpacing
                    rightPadding: Kirigami.Units.smallSpacing
                    level: 4
                    text: i18n("Disk")
                }

                contentItem: MetricGauge {
                    title: i18n("Usage")
                    sensorId: "disk/all/usedPercent"
                    detailSensorId: "disk/all/used"
                    detailTotalSensorId: "disk/all/total"
                    color: "#27ae60"
                }
            }

            Kirigami.Card {
                anchors.left: diskCard.right
                anchors.leftMargin: root.cardSpacing
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom

                header: Kirigami.Heading {
                    leftPadding: Kirigami.Units.smallSpacing
                    rightPadding: Kirigami.Units.smallSpacing
                    level: 4
                    text: i18n("Network I/O")
                }

                contentItem: NetworkStats {
                    localIpv4SensorId: root.localIpv4SensorId
                }
            }
        }
    }
}
