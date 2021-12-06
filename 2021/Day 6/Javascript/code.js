// Thank you! Alan Malloy! For the concept!
exports.part1 = (input) => {
    let ageMap = new Map();

    input.split(',').map(Number).forEach((v) => {
        ageMap.set(v, ageMap.get(v) ? ageMap.get(v) + 1 : 1);
    });

    for (let day = 0; day < 80; day++) {
        const newAgeMap = new Map();
        for (let [key, value] of ageMap) {
            if (key == 0) {
                newAgeMap.set(6, (newAgeMap.get(6) || 0) + value);
                newAgeMap.set(8, (newAgeMap.get(8) || 0) + value);
            } else {
                newAgeMap.set(key - 1, (newAgeMap.get(key - 1) || 0) + value);
            }
        }
        ageMap = newAgeMap;
    }

    let fishCount = 0;

    for (let [_, value] of ageMap) {
        fishCount += value;
    }

    return fishCount;
}

exports.part2 = (input) => {
    let ageMap = new Map();

    input.split(',').map(Number).forEach((v) => {
        ageMap.set(v, ageMap.get(v) ? ageMap.get(v) + 1 : 1);
    });

    for (let day = 0; day < 256; day++) {
        const newAgeMap = new Map();
        for (let [key, value] of ageMap) {
            if (key == 0) {
                newAgeMap.set(6, (newAgeMap.get(6) || 0) + value);
                newAgeMap.set(8, (newAgeMap.get(8) || 0) + value);
            } else {
                newAgeMap.set(key - 1, (newAgeMap.get(key - 1) || 0) + value);
            }
        }
        ageMap = newAgeMap;
    }

    let fishCount = 0;

    for (let [_, value] of ageMap) {
        fishCount += value;
    }

    return fishCount;
}