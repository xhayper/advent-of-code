function nthTriangleNumber(n) {
    return n * (n + 1) / 2;
}

exports.part1 = (input) => {
    let crabPositions = input.split(",").map(Number);
    crabPositions.sort((a, b) => a - b);
    let leastPosition = Math.ceil(crabPositions.length % 2 == 0 ? (crabPositions[crabPositions.length / 2] + crabPositions[crabPositions.length / 2 - 1]) / 2 : crabPositions[Math.floor(crabPositions.length / 2)]); // The median of the input ceiled up.

    let crabPositionMap = new Map();
    crabPositions.forEach((v) => {
        crabPositionMap.set(v, crabPositionMap.get(v) + 1 || 1);
    })
    let fuelUsed = 0;
    crabPositionMap.forEach((v, k) => {
        fuelUsed += Math.abs(leastPosition - k) * v;
    });
    return fuelUsed;
}

exports.part2 = (input) => {
    let crabPositions = input.split(",").map(Number);
    crabPositions.sort((a, b) => a - b);
    let crabPositionMap = new Map();
    crabPositions.forEach((v) => {
        crabPositionMap.set(v, crabPositionMap.get(v) + 1 || 1);
    })
    let leastFuel = Infinity;
    for (let pos = crabPositions[0]; pos <= crabPositions[crabPositions.length - 1]; pos++) {
        let fuelUsed = 0;
        crabPositionMap.forEach((v, k) => {
            fuelUsed += nthTriangleNumber(Math.abs(pos - k)) * v;
        });
        leastFuel = Math.min(fuelUsed, leastFuel);
    }
    return leastFuel;
}