use std::cmp::max;

// oh no
// i am not even gonna optimize this

use regex::Regex;

pub fn part_1(input: String) -> String {
    let mut block_list: Vec<Vec<char>> = Vec::new();
    let mut is_at_number = false;

    for line in input.lines() {
        if !is_at_number {
            let chunks = line
                .chars()
                .collect::<Vec<char>>()
                .chunks(4)
                .map(|c| c[0..3].iter().collect::<String>())
                .collect::<Vec<String>>();

            for (i, block) in chunks.iter().enumerate() {
                if i + 1 > block_list.len() {
                    block_list.push(Vec::new());
                }

                if block.starts_with("[") && block.ends_with("]") {
                    // Add element to the fornt
                    block_list
                        .get_mut(i)
                        .unwrap()
                        .splice(0..0, [block.chars().nth(1).unwrap()]);
                } else if block.chars().nth(1).unwrap().is_numeric() {
                    is_at_number = true;
                    break;
                }
            }
        }

        let re = Regex::new(r"move (\d+) from (\d+) to (\d+)").unwrap();
        for cap in re.captures_iter(line) {
            let amount = cap[1].parse::<usize>().unwrap();
            let from = cap[2].parse::<usize>().unwrap();
            let to = cap[3].parse::<usize>().unwrap();

            for _ in 0..amount {
                if block_list.get_mut(from - 1).unwrap().is_empty() {
                    break;
                }

                let ch_clone = block_list.get_mut(from - 1).unwrap().pop().clone();
                block_list.get_mut(to - 1).unwrap().push(ch_clone.unwrap());
                drop(ch_clone);
            }
        }
    }

    drop(is_at_number);

    let mut result = String::new();
    for box_ in block_list {
        result.push(box_.last().unwrap().clone());
    }

    result.to_string()
}

pub fn part_2(input: String) -> String {
    let mut block_list: Vec<Vec<char>> = Vec::new();
    let mut is_at_number = false;

    for line in input.lines() {
        if !is_at_number {
            let chunks = line
                .chars()
                .collect::<Vec<char>>()
                .chunks(4)
                .map(|c| c[0..3].iter().collect::<String>())
                .collect::<Vec<String>>();

            for (i, block) in chunks.iter().enumerate() {
                if i + 1 > block_list.len() {
                    block_list.push(Vec::new());
                }

                if block.starts_with("[") && block.ends_with("]") {
                    // Add element to the fornt
                    block_list
                        .get_mut(i)
                        .unwrap()
                        .splice(0..0, [block.chars().nth(1).unwrap()]);
                } else if block.chars().nth(1).unwrap().is_numeric() {
                    is_at_number = true;
                    break;
                }
            }
        }

        let re = Regex::new(r"move (\d+) from (\d+) to (\d+)").unwrap();
        for cap in re.captures_iter(line) {
            let amount = cap[1].parse::<usize>().unwrap();
            let from = cap[2].parse::<usize>().unwrap();
            let to = cap[3].parse::<usize>().unwrap();

            let char_list = block_list.get_mut(from - 1).unwrap();
            let start = (max((char_list.len() as i32) - (amount as i32), 0)) as usize;
            let ch_clone = &char_list[start..char_list.len()]
                .iter()
                .cloned()
                .collect::<Vec<char>>();

            block_list
                .get_mut(to - 1)
                .unwrap()
                .extend(ch_clone.iter().cloned());
            block_list.get_mut(from - 1).unwrap().truncate(start);
        }
    }

    drop(is_at_number);

    let mut result = String::new();
    for box_ in block_list {
        result.push(box_.last().unwrap().clone());
    }

    result.to_string()
}
