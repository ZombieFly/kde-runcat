.pragma library

function clamp(value, minimum, maximum) {
    return Math.min(maximum, Math.max(minimum, value));
}

function smooth(previous, current, alpha) {
    const weight = clamp(alpha, 0, 1);
    return previous + (current - previous) * weight;
}

function cycleDuration(cpuUsage, slowCycleMs, fastCycleMs) {
    const low = Math.min(slowCycleMs, fastCycleMs);
    const high = Math.max(slowCycleMs, fastCycleMs);
    const load = clamp(cpuUsage, 0, 100) / 100;

    // Interpolate geometrically so medium and high load feels much faster
    // while preserving the configured idle and maximum cycle durations.
    const speed = Math.pow(load, 0.55);
    return high * Math.pow(low / high, speed);
}

function frameInterval(cpuUsage, frameCount, slowCycleMs, fastCycleMs, maxFps) {
    const frames = Math.max(1, frameCount);
    const fps = Math.max(1, maxFps);
    const desired = cycleDuration(cpuUsage, slowCycleMs, fastCycleMs) / frames;
    return Math.max(1000 / fps, desired);
}
