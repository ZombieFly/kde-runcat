import QtQuick
import QtTest

import "../package/contents/code/sensors.js" as SensorSelection

TestCase {
    name: "SensorSelection"

    function test_prefersCpuPackageTemperature() {
        verify(SensorSelection.cpuTemperatureSensorScore(
            "lmsensors/coretemp-isa-0000/Package_id_0/temp1_input",
            "Package id 0"
        ) > SensorSelection.cpuTemperatureSensorScore(
            "lmsensors/coretemp-isa-0000/Core_0/temp2_input",
            "Core 0"
        ));
    }

    function test_prefersAggregateCpuTemperature() {
        verify(SensorSelection.cpuTemperatureSensorScore(
            "cpu/all/averageTemperature",
            "Average CPU Temperature"
        ) > SensorSelection.cpuTemperatureSensorScore(
            "cpu/cpu0/temperature",
            "Core 1 Current Temperature"
        ));
        verify(SensorSelection.cpuTemperatureSensorScore(
            "cpu/cpu0/temperature",
            "Core 1 Current Temperature"
        ) > SensorSelection.cpuTemperatureSensorScore(
            "lmsensors/coretemp-isa-0000/Package_id_0/temp1_input",
            "Package id 0"
        ));
    }

    function test_prefersAverageOverMaximumCpuTemperature() {
        verify(SensorSelection.cpuTemperatureSensorScore(
            "cpu/all/averageTemperature",
            "Average CPU Temperature"
        ) > SensorSelection.cpuTemperatureSensorScore(
            "cpu/all/maximumTemperature",
            "Maximum CPU Temperature"
        ));
    }

    function test_rejectsNonCpuHardwareTemperatures() {
        const sensors = [
            ["lmsensors/nvme-pci-0100/temp1", "Composite"],
            ["lmsensors/iwlwifi_1_1-virtual-0/temp1", "Temperature 1"],
            ["lmsensors/pch_cometlake_0-virtual-0/temp1", "Temperature 1"]
        ];

        for (const sensor of sensors) {
            compare(SensorSelection.cpuTemperatureSensorScore(
                sensor[0], sensor[1]
            ), -1);
        }
    }

    function test_rejectsTemperatureLimits() {
        compare(SensorSelection.cpuTemperatureSensorScore(
            "lmsensors/k10temp-pci-00c3/Tctl/temp1_crit",
            "Critical temperature"
        ), -1);
    }
}
