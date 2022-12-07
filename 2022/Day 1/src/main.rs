use crate::input::{example_input, first_example_answer, input, second_example_answer};
use crate::solution::{part_1, part_2};

mod input;
mod solution;

fn main() {
    assert_eq!(part_1(example_input()), first_example_answer());
    assert_eq!(part_2(example_input()), second_example_answer());

    println!("Day 1 Part 1's answer: {}", part_1(input()));
    println!("Day 1 Part 2's answer: {}", part_2(input()));
}
