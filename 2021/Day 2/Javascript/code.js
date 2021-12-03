exports.part1 = (input) => {
    let horizontalPosition = 0;
    let depth = 0;

    let instruction = {
        "forward": (n) => {
            horizontalPosition += n;
        },
        "down": (n) => {
            depth += n;
        },
        "up": (n) => {
            depth -= n;
        }
    }

    input.split("\n").map(c => {
        let [i, v] = c.split(" ");
        v = parseInt(v);
        instruction[i](v);
    });

    return depth * horizontalPosition;
}

exports.part2 = (input) => {
    let horizontalPosition = 0;
    let depth = 0;
    let aim = 0;

    instruction = {
        "forward": (n) => {
            horizontalPosition += n;
            depth += aim * n;
        },
        "down": (n) => {
            aim += n;
        },
        "up": (n) => {
            aim -= n;
        }
    }

    input.split("\n").map(c => {
        let [i, v] = c.split(" ");
        v = parseInt(v);
        instruction[i](v);
    });

    return horizontalPosition * depth;
}