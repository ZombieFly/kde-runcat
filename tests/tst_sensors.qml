import QtQuick
import QtTest

import "../package/contents/code/sensors.js" as SensorSelection

TestCase {
    name: "SensorSelection"

    function test_prefersAggregateCpuTemperature() {
        verify(SensorSelection.cpuTemperatureSensorScore(
            "cpu/all/averageTemperature", "Average CPU Temperature"
        ) > SensorSelection.cpuTemperatureSensorScore(
            "cpu/cpu0/temperature", "Core Temperature"
        ));
    }

    function test_rejectsNonCpuTemperature() {
        compare(SensorSelection.cpuTemperatureSensorScore(
            "lmsensors/nvme-pci-0100/temp1", "Composite"
        ), -1);
    }
}
