pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts

import org.kde.kitemmodels as KItemModels
import org.kde.kirigami as Kirigami
import org.kde.ksysguard.sensors as Sensors
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid

import "../code/animation.js" as Animation
import "../code/components.js" as Components
import "../code/sensors.js" as SensorSelection

PlasmoidItem {
    id: root

    readonly property real defaultSmoothing: 0.4
    readonly property bool vertical:
        Plasmoid.formFactor === PlasmaCore.Types.Vertical
    readonly property var panelComponents: Plasmoid.configuration.componentConfigVersion < 1
        ? Components.migrateLegacy(Plasmoid.configuration)
        : Components.normalize(Plasmoid.configuration.components)
    readonly property int componentSpacing: Math.max(
        0, Math.min(24, Number(Plasmoid.configuration.indicatorSpacing))
    )

    property real smoothedCpu: 0
    property real cpuUsage: 0
    property bool sensorReady: false
    property string cpuTemperatureSensorId: ""

    function updateCpu(rawValue) {
        const value = Number(rawValue);
        if (!Number.isFinite(value)) {
            return;
        }
        const bounded = Animation.clamp(value, 0, 100);
        cpuUsage = bounded;
        if (!sensorReady) {
            smoothedCpu = bounded;
            sensorReady = true;
            return;
        }
        smoothedCpu = Animation.smooth(smoothedCpu, bounded, defaultSmoothing);
    }

    function discoverCpuTemperatureSensor() {
        let bestId = "";
        let bestScore = -1;
        for (let row = 0; row < flatSensorModel.rowCount(); ++row) {
            const index = flatSensorModel.index(row, 0);
            const sensorId = String(flatSensorModel.data(
                index, Sensors.SensorTreeModel.SensorId
            ) || "");
            if (sensorId.length === 0) {
                continue;
            }
            const name = String(flatSensorModel.data(index, Qt.DisplayRole) || "");
            const score = SensorSelection.cpuTemperatureSensorScore(
                sensorId, name
            );
            if (score > bestScore) {
                bestScore = score;
                bestId = sensorId;
            }
        }
        cpuTemperatureSensorId = bestId;
    }

    function migrateConfiguration() {
        if (Plasmoid.configuration.componentConfigVersion >= 2) {
            return;
        }
        const value = Plasmoid.configuration.componentConfigVersion < 1
            ? Components.migrateLegacy(Plasmoid.configuration)
            : Components.normalize(Plasmoid.configuration.components);
        Plasmoid.configuration.components = Components.serialize(
            value
        );
        Plasmoid.configuration.componentConfigVersion = 2;
    }

    function visiblePanelComponentCount() {
        let count = 0;
        for (let index = 0; index < panelComponents.length; ++index) {
            const component = panelComponents[index];
            if (component.type !== "ai"
                    || component.settings.showCodex
                    || component.settings.showClaude
                    || component.settings.showDaily) {
                ++count;
            }
        }
        return count;
    }

    Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground
    Plasmoid.title: i18n("RunCat")
    toolTipMainText: i18n("RunCat")
    toolTipSubText: sensorReady
        ? i18n("CPU usage: %1%", Math.round(smoothedCpu))
        : i18n("Waiting for CPU data")
    activationTogglesExpanded: false
    preferredRepresentation: compactRepresentation

    compactRepresentation: Item {
        id: representation

        readonly property int visibleComponentCount:
            root.visiblePanelComponentCount()
        readonly property real naturalHeight: Kirigami.Units.iconSizes.medium
        readonly property real minimumHeight: Kirigami.Units.iconSizes.small

        implicitWidth: componentRow.implicitWidth
        implicitHeight: naturalHeight
        Layout.minimumWidth: Math.max(1, componentRow.implicitWidth
            * minimumHeight / naturalHeight)
        Layout.minimumHeight: minimumHeight
        Layout.preferredWidth: implicitWidth
        Layout.preferredHeight: implicitHeight

        Row {
            id: componentRow

            anchors.fill: parent
            spacing: representation.visibleComponentCount > 1
                ? root.componentSpacing : 0

            Repeater {
                model: root.panelComponents

                PanelComponent {
                    required property var modelData

                    componentType: String(modelData.type)
                    componentSettings: modelData.settings || ({})
                    cpuUsage: root.cpuUsage
                    smoothedCpu: root.smoothedCpu
                    sensorReady: root.sensorReady
                    cpuTemperatureSensorId: root.cpuTemperatureSensorId
                    vertical: root.vertical
                    contentSpacing: root.componentSpacing
                    width: implicitWidth
                    height: componentRow.height
                    visible: componentType !== "ai"
                        || Boolean(componentSettings.showCodex)
                        || Boolean(componentSettings.showClaude)
                        || Boolean(componentSettings.showDaily)
                }
            }
        }
    }

    // PlasmoidItem expects both representation slots to exist. This empty
    // representation is never activated; it only keeps Plasma's compact
    // representation layout valid after a shell restart.
    fullRepresentation: Item {}

    Sensors.SensorTreeModel { id: sensorTreeModel }

    KItemModels.KDescendantsProxyModel {
        id: flatSensorModel
        model: sensorTreeModel
        expandsByDefault: true
    }

    Timer {
        id: sensorDiscoveryTimer
        interval: 100
        onTriggered: root.discoverCpuTemperatureSensor()
    }

    Connections {
        target: flatSensorModel
        function onRowsInserted() { sensorDiscoveryTimer.restart(); }
        function onModelReset() { sensorDiscoveryTimer.restart(); }
        function onLayoutChanged() { sensorDiscoveryTimer.restart(); }
    }

    Component.onCompleted: {
        migrateConfiguration();
        sensorDiscoveryTimer.start();
    }

    Sensors.Sensor {
        id: cpuSensor
        sensorId: "cpu/all/usage"
        enabled: root.visible
        updateRateLimit: 1000
        onValueChanged: root.updateCpu(value)
    }
}
