const commonList = (arr) => {
    const list = [];
    arr.forEach(bitData => {
        const bs = bitData.split('');
        for (let i = 0; i < bs.length; i++) {
            const bit = bs[i];
            if (!list[i]) {
                list[i] = {
                    one: 0,
                    zero: 0
                }
            }
            if (bit == '1') list[i].one++;
            else if (bit == "0") list[i].zero++;
        }
    });
    return list;
}

exports.part1 = (input) => {
    const bits = input.split('\n');
    const list = commonList(bits);
    const gammaRate = list.map(v => v.one > v.zero && "1" || "0").join('');
    const epsilonRate = list.map(v => v.one > v.zero && "0" || "1").join('');
    return parseInt(gammaRate, 2) * parseInt(epsilonRate, 2);
}

exports.part2 = (input) => {
    let generatorRate = input.split('\n');
    let scrubberRate = generatorRate;

    for (let l = 0; l < commonList(generatorRate).length; l++) {
        const generatorCommonList = commonList(generatorRate);
        const scrubberCommonList = commonList(scrubberRate);
        generatorRate = generatorRate.filter(bitData => generatorRate.length == 1 || bitData.split('')[l] == (generatorCommonList[l].one >= generatorCommonList[l].zero ? "1" : "0"));
        scrubberRate = scrubberRate.filter(bitData => scrubberRate.length == 1 || bitData.split('')[l] == (scrubberCommonList[l].one >= scrubberCommonList[l].zero ? "0" : "1"));
    }

    return parseInt(generatorRate[0], 2) * parseInt(scrubberRate[0], 2);
}
