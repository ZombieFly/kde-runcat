function cpuTemperatureSensorScore(sensorId, name) {
    const id = sensorId.toLowerCase();
    const label = name.toLowerCase();
    const text = id + " " + label;

    if (id === "cpu/all/averagetemperature") {
        return 1000;
    }
    if (id === "cpu/all/maximumtemperature") {
        return 900;
    }
    if (/^cpu\/cpu\d+\/temperature$/.test(id)) {
        return 800;
    }
    if (!id.startsWith("lmsensors/")) {
        return -1;
    }

    const cpuSensor = text.includes("package")
        || text.includes("tctl")
        || text.includes("tdie")
        || text.includes("coretemp")
        || text.includes("k10temp")
        || text.includes("zenpower");
    if (!cpuSensor || text.includes("crit") || text.includes("max")
            || text.includes("alarm") || text.includes("emergency")) {
        return -1;
    }

    let score = 100;
    if (text.includes("package")) score += 100;
    if (text.includes("tctl")) score += 90;
    if (text.includes("tdie")) score += 80;
    if (text.includes("coretemp") || text.includes("k10temp")) score += 40;
    if (text.includes("zenpower")) score += 40;
    if (text.includes("input")) score += 20;
    return score;
}
