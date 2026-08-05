function formatTokens(tokens) {
    const number = Number(tokens);
    const value = Number.isFinite(number) ? Math.max(0, number) : 0;
    if (value === 0) {
        return "0";
    }

    let scaled;
    let suffix;
    if (value >= 1000000) {
        scaled = value / 1000000;
        suffix = "m";
    } else {
        scaled = value / 1000;
        suffix = "k";
    }
    return scaled.toFixed(1).replace(/\.0$/, "") + suffix;
}
