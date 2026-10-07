.pragma library

const runnerIds = [
    "cat",
    "dog",
    "slime",
    "drop",
    "coffee",
    "newton-cradle",
    "engine",
    "mochi",
    "ds-chan"
];

const runners = {
    "cat": {
        width: 56,
        height: 36,
        frameOrder: [0, 1, 2, 3, 4]
    },
    "dog": {
        width: 70,
        height: 36,
        frameOrder: [0, 1, 2, 3, 4]
    },
    "slime": {
        width: 61,
        height: 36,
        frameOrder: [0, 1, 2, 3, 4, 4, 3, 2, 1]
    },
    "drop": {
        width: 43,
        height: 36,
        frameOrder: [0, 1, 2, 3, 4]
    },
    "coffee": {
        width: 38,
        height: 36,
        frameOrder: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    },
    "newton-cradle": {
        width: 82,
        height: 36,
        frameOrder: [0, 1, 2, 1, 0, 3, 4, 3]
    },
    "engine": {
        width: 83,
        height: 36,
        frameOrder: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    },
    "mochi": {
        width: 62,
        height: 36,
        frameOrder: [0, 1, 2, 3, 4, 3, 2, 1]
    },
    "ds-chan": {
        width: 488,
        height: 410,
        frameOrder: [
            0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,
            12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23
        ],
        colored: true,
        hasIdle: true
    }
};

function availableRunnerIds() {
    return runnerIds.slice();
}

function normalizeRunnerId(runnerId) {
    const id = String(runnerId || "");
    return runners[id] ? id : "cat";
}

function frameOrder(runnerId) {
    return runners[normalizeRunnerId(runnerId)].frameOrder.slice();
}

function aspectRatio(runnerId) {
    const runner = runners[normalizeRunnerId(runnerId)];
    return runner.width / runner.height;
}

function isColored(runnerId) {
    const runner = runners[normalizeRunnerId(runnerId)];
    return Boolean(runner && runner.colored);
}

function hasIdleFrame(runnerId) {
    const runner = runners[normalizeRunnerId(runnerId)];
    return Boolean(runner && (runner.hasIdle || normalizeRunnerId(runnerId) === "cat"));
}
