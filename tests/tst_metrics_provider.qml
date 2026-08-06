pragma ComponentBehavior: Bound

import QtQuick
import QtTest

import "../package/contents/ui"

TestCase {
    id: testCase

    name: "MetricsProvider"

    Component {
        id: providerFactory

        MetricsProvider {}
    }

    function test_tokenUsageStartsAtZero() {
        const provider = createTemporaryObject(providerFactory, testCase);
        verify(provider !== null);

        verify(provider.codexAvailable);
        compare(provider.codexTodayTokens, 0);
        compare(provider.codexContextTokens, 0);
        verify(provider.claudeAvailable);
        compare(provider.claudeTodayTokens, 0);
        compare(provider.claudeContextTokens, 0);
    }

    function test_sensorSubscriptionsFollowConfiguredComponents() {
        const provider = createTemporaryObject(providerFactory, testCase);
        verify(provider !== null);
        verify(!provider.memoryUsageSensor.enabled);
        verify(!provider.diskUsageSensor.enabled);
        verify(!provider.downloadSensor.enabled);
        verify(!provider.gpuUsageSensor.enabled);
        verify(!provider.vramUsedSensor.enabled);
        verify(!provider.diskReadSensor.enabled);

        provider.memoryEnabled = true;
        provider.diskEnabled = true;
        provider.networkEnabled = true;
        provider.gpuEnabled = true;
        provider.gpuTemperatureSensorId = "gpu/gpu0/temperature";
        provider.vramEnabled = true;
        provider.diskIoEnabled = true;

        verify(provider.memoryUsageSensor.enabled);
        verify(provider.memoryUsedSensor.enabled);
        verify(provider.memoryTotalSensor.enabled);
        verify(provider.diskUsageSensor.enabled);
        verify(provider.diskUsedSensor.enabled);
        verify(provider.diskTotalSensor.enabled);
        verify(provider.downloadSensor.enabled);
        verify(provider.uploadSensor.enabled);
        verify(provider.gpuUsageSensor.enabled);
        verify(!provider.gpuTemperatureSensor.enabled);
        provider.gpuTemperatureEnabled = true;
        verify(provider.gpuTemperatureSensor.enabled);
        verify(provider.vramUsedSensor.enabled);
        verify(provider.vramTotalSensor.enabled);
        verify(provider.diskReadSensor.enabled);
        verify(provider.diskWriteSensor.enabled);
    }

    function test_tokenUsageParsing() {
        const provider = createTemporaryObject(providerFactory, testCase);
        verify(provider !== null);
        provider.updateTokenUsage(JSON.stringify({
            codex: {
                available: true,
                todayTokens: 123,
                contextTokens: 45,
                contextWindow: 1000,
                updatedAt: "codex-time"
            },
            claude: {
                available: true,
                todayTokens: 456,
                contextTokens: 78,
                updatedAt: "claude-time"
            }
        }));

        compare(provider.codexTodayTokens, 123);
        compare(provider.codexContextTokens, 45);
        compare(provider.codexContextWindow, 1000);
        compare(provider.codexUpdatedAt, "codex-time");
        compare(provider.claudeTodayTokens, 456);
        compare(provider.claudeContextTokens, 78);
        compare(provider.claudeUpdatedAt, "claude-time");
    }
}
