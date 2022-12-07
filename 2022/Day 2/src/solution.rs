use std::collections::HashMap;

#[derive(Debug, PartialEq, Eq, Hash, Clone, Copy)]
pub enum Play {
    Rock,
    Paper,
    Scissors,
}

pub fn get_win_map() -> HashMap<Play, Play> {
    HashMap::from([
        (Play::Rock, Play::Scissors),
        (Play::Paper, Play::Rock),
        (Play::Scissors, Play::Paper),
    ])
}

pub fn get_play(input: &char) -> Play {
    match input {
        'A' => Play::Rock,
        'B' => Play::Paper,
        'C' => Play::Scissors,
        'X' => Play::Rock,
        'Y' => Play::Paper,
        'Z' => Play::Scissors,
        _ => panic!("Invalid input"),
    }
}

pub fn calculate_score(win_map: &HashMap<Play, Play>, elf_play: &Play, our_play: &Play) -> u32 {
    let mut score: u32 = 0;

    if our_play == &Play::Scissors {
        score += 3;
    } else if our_play == &Play::Paper {
        score += 2;
    } else if our_play == &Play::Rock {
        score += 1;
    }

    if elf_play == our_play {
        score += 3;
    } else if win_map.get(&our_play) == Some(&elf_play) {
        score += 6;
    }

    score
}

pub fn part_1(input: String) -> String {
    let mut score: u32 = 0;
    let win_map = get_win_map();

    for line in input.lines() {
        let parsed = line.split_whitespace().collect::<Vec<&str>>();

        let elf_play = get_play(&parsed[0].chars().nth(0).unwrap());
        let our_play = get_play(&parsed[1].chars().nth(0).unwrap());

        score += calculate_score(&win_map, &elf_play, &our_play);
    }

    drop(win_map);

    score.to_string()
}

pub fn part_2(input: String) -> String {
    let mut score: u32 = 0;
    let win_map = get_win_map();

    for line in input.lines() {
        let parsed = line.split_whitespace().collect::<Vec<&str>>();
        let our_choice = &parsed[1].chars().nth(0).unwrap();

        let elf_play = get_play(&parsed[0].chars().nth(0).unwrap());
        let mut our_play = elf_play;

        if our_choice == &'X' {
            // We need to lost
            our_play = win_map.get(&elf_play).unwrap().to_owned();
        } else if our_choice == &'Z' {
            // We need to win
            for (key, value) in win_map.iter() {
                if value == &elf_play {
                    our_play = *key;
                }
            }
        }

        score += calculate_score(&win_map, &elf_play, &our_play);
    }

    drop(win_map);

    score.to_string()
}
