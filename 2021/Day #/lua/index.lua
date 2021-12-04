local data = require("data")
local code = require("code")

assert(code:part1(data.part1.example) == data.part1.expectedOutput, "Part 1 failed")

print(string.format("Part 1: %s", code:part1(data.part1.input)))

assert(code:part2(data.part2.example) == data.part2.expectedOutput, "Part 2 failed")

print(string.format("Part 2: %s", code:part2(data.part2.input)))
