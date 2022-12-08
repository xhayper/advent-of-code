// oh no

use regex::Regex;

#[derive(Debug, Clone)]
struct Block {
    content: Vec<char>,
}

impl Block {
    fn new() -> Block {
        Block {
            content: Vec::new(),
        }
    }

    fn add(&mut self, c: char) {
        self.content.push(c);
    }

    fn move_to(&mut self, other: &mut Block, amount: usize) {
        for _ in 0..amount {
            if self.content.is_empty() {
                break;
            }
            other.content.push(self.content.pop().unwrap());
        }
    }
}

pub fn part_1(input: String) -> String {
    let mut block_list: Vec<Block> = Vec::new();
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
                    block_list.push(Block::new());
                }

                if block.starts_with("[") && block.ends_with("]") {
                    block_list[i].add(block.chars().nth(1).unwrap());
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
        }
    }

    drop(is_at_number);

    let mut result = String::new();
    for box_ in block_list {
        result.push(box_.content.last().unwrap().clone());
    }

    result.to_string()
}

pub fn part_2(input: String) -> String {
    "".to_string()
}
