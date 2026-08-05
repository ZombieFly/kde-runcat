function normalizeUnit(value) {
    return value === "fahrenheit" ? "fahrenheit" : "celsius";
}

function convert(celsius, unit) {
    return normalizeUnit(unit) === "fahrenheit"
        ? celsius * 9 / 5 + 32 : celsius;
}

function suffix(unit) {
    return normalizeUnit(unit) === "fahrenheit" ? "F" : "C";
}

function format(celsius, unit) {
    return Math.round(convert(celsius, unit)) + "°" + suffix(unit);
}

function unavailable(unit) {
    return "--°" + suffix(unit);
}

function color(celsius) {
    if (celsius < 70) {
        return "#f67400";
    }
    return "#da4453";
}
