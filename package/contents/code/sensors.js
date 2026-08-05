function sensorScore(sensorId, name, kind) {
    const id = sensorId.toLowerCase();
    const label = name.toLowerCase();
    const text = id + " " + label;

    if (kind === "gpuUsage") {
        if (!id.startsWith("gpu/") || !id.endsWith("/usage")) {
            return -1;
        }
        return id === "gpu/all/usage" ? 1000 : 100;
    }
    if (kind === "localIpv4") {
        if (!id.startsWith("network/") || !id.endsWith("/ipv4address")) {
            return -1;
        }

        const parts = id.split("/");
        const device = parts.length > 2 ? parts[1] : "";
        if (device === "all" || device === "lo") {
            return -1;
        }

        let score = 100;
        if (device.startsWith("wl") || device.startsWith("en")
                || device.startsWith("eth")) {
            score += 100;
        }
        if (device.startsWith("docker") || device.startsWith("veth")
                || device.startsWith("virbr") || device.startsWith("br-")
                || device.startsWith("tun") || device.startsWith("tap")) {
            score -= 200;
        }
        return score;
    }
    if (kind === "cpuTemperature") {
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
        if (!cpuSensor) {
            return -1;
        }

        let score = 100;
        if (text.includes("package")) {
            score += 100;
        }
        if (text.includes("tctl")) {
            score += 90;
        }
        if (text.includes("tdie")) {
            score += 80;
        }
        if (text.includes("coretemp") || text.includes("k10temp")) {
            score += 40;
        }
        if (text.includes("zenpower")) {
            score += 40;
        }
        if (text.includes("input")) {
            score += 20;
        }
        if (text.includes("crit") || text.includes("max")
                || text.includes("alarm") || text.includes("emergency")) {
            return -1;
        }
        return score;
    }
    return -1;
}
