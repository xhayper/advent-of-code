pub fn calculate_priority(input: &Vec<char>) -> u32 {
    let mut priority: u32 = 0;

    for item in input {
        let ascii_num = *item as u32;

        if item.is_uppercase() {
            priority += ascii_num - 38;
        } else {
            priority += ascii_num - 96;
        }
    }

    priority
}

pub fn part_1(input: String) -> String {
    let mut common_item: Vec<char> = Vec::new();

    for line in input.lines() {
        let (first, second) = line.split_at(line.len() / 2);

        let common_chars = first
            .chars()
            .filter(|c| second.contains(*c))
            .collect::<Vec<char>>()[0];
        common_item.push(common_chars);
    }

    calculate_priority(&common_item).to_string()
}

pub fn part_2(input: String) -> String {
    let mut common_item: Vec<char> = Vec::new();
    let mut i: u32 = 0;

    let mut temp_str: Vec<String> = Vec::new();
    for line in input.lines() {
        i += 1;

        temp_str.push(line.to_string());

        if (i % 3) != 0 {
            continue;
        }

        let common_chars = temp_str[0]
            .chars()
            .filter(|c| temp_str[1].contains(*c))
            .filter(|c| temp_str[2].contains(*c))
            .collect::<Vec<char>>()[0];
        common_item.push(common_chars);

        temp_str.clear();
    }

    drop(temp_str);

    calculate_priority(&common_item).to_string()
}
