use std::ops::Range;

pub fn get_range(input: &str) -> Range<u32> {
    let range = input.split("-").collect::<Vec<&str>>();

    Range {
        start: range[0].parse::<u32>().unwrap(),
        end: range[1].parse::<u32>().unwrap(),
    }
}

pub fn part_1(input: String) -> String {
    let mut overlap: u32 = 0;

    for line in input.lines() {
        let pair = line.split(",").collect::<Vec<&str>>();

        let first_range = get_range(pair[0]);
        let second_range = get_range(pair[1]);

        if first_range.start <= second_range.start && first_range.end >= second_range.end {
            overlap += 1;
        } else if second_range.start <= first_range.start && second_range.end >= first_range.end {
            overlap += 1;
        }
    }

    overlap.to_string()
}

pub fn part_2(input: String) -> String {
    let mut overlap: u32 = 0;

    for line in input.lines() {
        let pair = line.split(",").collect::<Vec<&str>>();

        let first_range = get_range(pair[0]);
        let second_range = get_range(pair[1]);

        if first_range.start <= second_range.end && first_range.end >= second_range.start {
            overlap += 1;
        } else if second_range.start <= first_range.end && second_range.end >= first_range.start {
            overlap += 1;
        }
    }

    overlap.to_string()
}
