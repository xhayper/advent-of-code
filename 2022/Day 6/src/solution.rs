use std::collections::HashSet;

pub fn part_1(input: String) -> String {
    for i in 0..input.len() - 4 {
        let chunks: String = input.chars().collect::<Vec<char>>()[i..i + 4]
            .to_vec()
            .iter()
            .collect();

        if chunks
            .chars()
            .collect::<Vec<char>>()
            .iter()
            .collect::<HashSet<&char>>()
            .len()
            != 4
        {
            continue;
        }

        return (i + 4).to_string();
    }

    "".to_string()
}

pub fn part_2(input: String) -> String {
    for i in 0..input.len() - 14 {
        let chunks: String = input.chars().collect::<Vec<char>>()[i..i + 14]
            .to_vec()
            .iter()
            .collect();

        if chunks
            .chars()
            .collect::<Vec<char>>()
            .iter()
            .collect::<HashSet<&char>>()
            .len()
            != 14
        {
            continue;
        }

        return (i + 14).to_string();
    }

    "".to_string()
}
