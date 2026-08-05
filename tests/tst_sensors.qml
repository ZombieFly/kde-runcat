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

    function test_prefersStandardGpuTemperature() {
        verify(SensorSelection.gpuTemperatureSensorScore(
            "gpu/gpu0/temperature", "GPU Temperature"
        ) > SensorSelection.gpuTemperatureSensorScore(
            "lmsensors/amdgpu-pci-0300/temp1", "edge input"
        ));
        verify(SensorSelection.gpuTemperatureSensorScore(
            "gpu/gpu0/temperature", "GPU 0"
        ) > SensorSelection.gpuTemperatureSensorScore(
            "gpu/gpu1/temperature", "GPU 1"
        ));
    }

    function test_rejectsNonGpuTemperature() {
        compare(SensorSelection.gpuTemperatureSensorScore(
            "lmsensors/nvme-pci-0100/temp1", "Composite"
        ), -1);
    }
}
