import QtQuick
import QtTest

import "../package/contents/code/sensors.js" as SensorSelection

TestCase {
    name: "SensorSelection"

    function test_prefersAggregateGpuSensors() {
        verify(SensorSelection.sensorScore(
            "gpu/all/usage", "All GPUs Usage", "gpuUsage"
        ) > SensorSelection.sensorScore(
            "gpu/gpu0/usage", "GPU 1 Usage", "gpuUsage"
        ));
    }

    function test_rejectsUnrelatedGpuSensors() {
        compare(SensorSelection.sensorScore(
            "gpu/gpu0/coreFrequency", "Core frequency", "gpuUsage"
        ), -1);
    }

    function test_prefersPhysicalNetworkForIpv4() {
        verify(SensorSelection.sensorScore(
            "network/wlan0/ipv4address", "IPv4 Address", "localIpv4"
        ) > SensorSelection.sensorScore(
            "network/docker0/ipv4address", "IPv4 Address", "localIpv4"
        ));
    }

    function test_rejectsLoopbackIpv4() {
        compare(SensorSelection.sensorScore(
            "network/lo/ipv4address", "IPv4 Address", "localIpv4"
        ), -1);
    }

    function test_prefersCpuPackageTemperature() {
        verify(SensorSelection.sensorScore(
            "lmsensors/coretemp-isa-0000/Package_id_0/temp1_input",
            "Package id 0",
            "cpuTemperature"
        ) > SensorSelection.sensorScore(
            "lmsensors/coretemp-isa-0000/Core_0/temp2_input",
            "Core 0",
            "cpuTemperature"
        ));
    }

    function test_rejectsTemperatureLimits() {
        verify(SensorSelection.sensorScore(
            "lmsensors/k10temp-pci-00c3/Tctl/temp1_input",
            "Tctl",
            "cpuTemperature"
        ) > SensorSelection.sensorScore(
            "lmsensors/k10temp-pci-00c3/Tctl/temp1_crit",
            "Critical temperature",
            "cpuTemperature"
        ));
    }
}
