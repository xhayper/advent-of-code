exports.part1 = (input) => input.split("\n").map(Number).filter((e, i, a) => i >= 1 && e > a[i-1]).length;


exports.part2 = (input) => input.split("\n").map(Number).filter((e, i, a) => i >= 1 && e + a[i + 1] + a[i + 2] > a[i-1] + e + a[i + 1]).length;