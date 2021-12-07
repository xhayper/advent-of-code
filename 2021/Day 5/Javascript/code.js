// Including this because it's pretty :)
function visualize(map, toString) {
    map = Array.from(map);
    const maxLength = Math.max(...map.map(a => (a || []).length || 0).filter(a => a >= 0));
    for (y = 0; y < map.length; y++) {
        for (x = 0; x < maxLength; x++) {
            map[y] = map[y] || [];
            map[y][x] = map[y][x] || 0;
        }
        if (toString) map[y] = map[y].join(", ");
    }
    if (toString) console.log(map.join("\n"));
    else console.table(map);
}

exports.part1 = (input) => {
    const point = input.split('\n');
    const map = [];
    for (let raw of point) {
        let [origin, destination] = raw.split(" -> ").map(x => x.split(",").map(Number));

        function addPoint(x, y) {
            map[y] = map[y] || [];
            map[y][x] = map[y][x] || 0;
            map[y][x]++;
        }

        if (origin[0] != destination[0] && origin[1] != destination[1]) continue;

        if (origin[0] == destination[0]) {
            for (let i = origin[1]; i <= destination[1]; i++) addPoint(origin[0], i);

            for (let i = origin[1]; i >= destination[1]; i--) addPoint(origin[0], i);
        }

        if (origin[1] == destination[1]) {
            for (let i = origin[0]; i <= destination[0]; i++) addPoint(i, origin[1]);

            for (let i = origin[0]; i >= destination[0]; i--) addPoint(i, origin[1]);
        }
    }
    return map.map(m => m.filter(x => x > 1)).reduce((p, v) => p += v.filter(x => (Number(x) != null) && x > 1).length, 0);
}

exports.part2 = (input) => {
    const point = input.split('\n');
    const map = [];
    for (let raw of point) {
        let [origin, destination] = raw.split(" -> ").map(x => x.split(",").map(Number));

        function addPoint(x, y) {
            map[y] = map[y] || [];
            map[y][x] = map[y][x] || 0;
            map[y][x]++;
        }

        if (origin[0] != destination[0] && origin[1] != destination[1]) {
            for (let x = origin[0]; x <= destination[0]; x++) addPoint(x, origin[1] > destination[1] ? origin[1] - Math.abs(x - origin[0]) : origin[1] + Math.abs(x - origin[0]));

            for (let x = origin[0]; x >= destination[0]; x--) addPoint(x, origin[1] > destination[1] ? origin[1] - Math.abs(x - origin[0]) : origin[1] + Math.abs(x - origin[0]));
        } else {
            if (origin[1] == destination[1]) {
                for (let i = origin[0]; i <= destination[0]; i++) addPoint(i, origin[1]);

                for (let i = origin[0]; i >= destination[0]; i--) addPoint(i, origin[1]);
            }

            if (origin[0] == destination[0]) {
                for (let i = origin[1]; i <= destination[1]; i++) addPoint(origin[0], i);

                for (let i = origin[1]; i >= destination[1]; i--) addPoint(origin[0], i);
            }
        }
    }
    return map.map(m => m.filter(x => x > 1)).reduce((p, v) => p += v.filter(x => (Number(x) != null) && x > 1).length, 0);
}