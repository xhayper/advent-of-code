const assert = require('assert'),
    code = require("./code.js"),
    data = require("./data.js");

assert(code.part1(data.part1.example) == data.part1.expectedOutput, "Part 1 failed");

console.log(`Part 1: ${code.part1(data.part1.input)}`);

assert(code.part2(data.part2.example) == data.part2.expectedOutput, "Part 2 failed");

console.log(`Part 2: ${code.part2(data.part2.input)}`);