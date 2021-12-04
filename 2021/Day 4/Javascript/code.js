// This might be the worst way to do it, Jesus fucking christ, 1 hours to do this.
exports.part1 = (input) => {
    input = input.split('\n').filter(x => x != "");

    const drawableNumber = input[0].split(",").map(Number);

    input.shift();

    const boardList = [];
    for (let currentLine = 0; currentLine < input.length / 5; currentLine++) {
        let board = [];
        for (let x = 0; x < 5; x++) {
            board.push(input[(currentLine * 5) + x].trim().replaceAll("  ", " ").split(" ").filter(n => n != "").map(Number));
        }
        boardList.push(board);
    }

    const playedNumber = [];

    let bingo = false;
    let firstBingoBoard = 0;
    let bingoNumber = 0;

    drawableNumber.forEach(currentNum => {
        if (bingo) return;
        playedNumber.push(currentNum);
        for (let board = 0; board < boardList.length; board++) {
            const arr = [];
            for (let y = 0; y < 5; y++) {
                arr[y] = []
                for (let x = 0; x < 5; x++) {
                    arr[y][x] = playedNumber.includes(boardList[board][y][x]);
                    if ((arr[0] && arr[0][x]) && (arr[1] && arr[1][x]) && (arr[2] && arr[2][x]) && (arr[3] && arr[3][x]) && (arr[4] && arr[4][x])) {
                        bingo = true;
                        firstBingoBoard = board;
                        bingoNumber = currentNum;
                        break;
                    }
                }
                if (bingo) break;
                if ((arr[y] && arr[y][0]) && (arr[y] && arr[y][1]) && (arr[y] && arr[y][2]) && (arr[y] && arr[y][3]) && (arr[y] && arr[y][4])) {
                    bingo = true;
                    firstBingoBoard = board;
                    bingoNumber = currentNum;
                }
            }
            if (bingo) break;
        }
    });

    return boardList[firstBingoBoard].map((v) => v.filter((v2) => !playedNumber.includes(v2)).reduce((p, c) => p + c, 0)).reduce((p, c) => p + c, 0) * bingoNumber;
}

exports.part2 = (input) => {
    input = input.split('\n').filter(x => x != "");

    const drawableNumber = input[0].split(",").map(Number);

    input.shift();

    const boardList = [];
    for (let currentLine = 0; currentLine < input.length / 5; currentLine++) {
        let board = [];
        for (let x = 0; x < 5; x++) {
            board.push(input[(currentLine * 5) + x].trim().replaceAll("  ", " ").split(" ").filter(n => n != "").map(Number));
        }
        boardList.push(board);
    }

    const playedNumber = [];

    let bingoNumber = 0;
    let bingoBoardList = [];

    drawableNumber.forEach(currentNum => {
        if (bingoBoardList.length >= boardList.length) return;
        playedNumber.push(currentNum);
        for (let board = 0; board < boardList.length; board++) {
            if (bingoBoardList.includes(board)) continue;
            const arr = [];
            for (let y = 0; y < 5; y++) {
                arr[y] = []
                for (let x = 0; x < 5; x++) {
                    arr[y][x] = playedNumber.includes(boardList[board][y][x]);
                    if ((arr[0] && arr[0][x]) && (arr[1] && arr[1][x]) && (arr[2] && arr[2][x]) && (arr[3] && arr[3][x]) && (arr[4] && arr[4][x])) {
                        bingoNumber = currentNum;
                        bingoBoardList.push(board);
                        break;
                    }
                }
                if (bingoBoardList.includes(board)) break;
                if ((arr[y] && arr[y][0]) && (arr[y] && arr[y][1]) && (arr[y] && arr[y][2]) && (arr[y] && arr[y][3]) && (arr[y] && arr[y][4])) {
                    bingoNumber = currentNum;
                    bingoBoardList.push(board);
                    break;
                }
            }
        }
    });
    return boardList[bingoBoardList[bingoBoardList.length - 1]].map((v) => v.filter((v2) => !playedNumber.includes(v2)).reduce((p, c) => p + c, 0)).reduce((p, c) => p + c, 0) * bingoNumber;
}