pub fn get_calories_list<'a, I>(input: I) -> Vec<u32>
where
    I: IntoIterator<Item = &'a str>,
{
    let mut number_vec: Vec<u32> = Vec::new();
    let mut current_value: u32 = 0;
    for line in input {
        if line == "" {
            number_vec.push(current_value);
            current_value = 0;
            continue;
        }

        let number = match line.parse::<u32>() {
            Ok(number) => number,
            Err(_) => continue,
        };

        current_value += number;
    }

    if current_value != 0 {
        number_vec.push(current_value);
    }

    drop(current_value);

    number_vec
}

pub fn part_1(input: String) -> String {
    let calries_list = get_calories_list(input.lines().into_iter());

    let largest = calries_list
        .iter()
        .fold(0, |acc, &x| if x > acc { x } else { acc });
    largest.to_string()
}

pub fn part_2(input: String) -> String {
    let mut calries_list = get_calories_list(input.lines().into_iter());
    calries_list.sort_by(|a, b| b.cmp(a));

    (calries_list[0] + calries_list[1] + calries_list[2]).to_string()
}
