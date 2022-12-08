use regex::Regex;
use std::{collections::HashMap, path::PathBuf};

pub fn part_1(input: String) -> String {
    let mut file_list: HashMap<PathBuf, u64> = HashMap::new();
    let mut current_dir: PathBuf = PathBuf::from("/");
    let mut last_command = "";

    for line in input.lines() {
        // Command mode
        if line.starts_with("$") {
            let args = line.split(" ").collect::<Vec<&str>>().as_slice()[1..].to_vec();
            last_command = args[0];

            if last_command == "cd" {
                if args[1] == ".." {
                    current_dir.pop();
                } else if args[1] == "/" {
                    current_dir = PathBuf::from("/");
                } else {
                    current_dir.push(args[1]);
                }
            }
        } else if last_command == "ls" {
            let re = Regex::new(r"(\d+) (.*)").unwrap();
            let captures = match re.captures(line) {
                Some(captures) => captures,
                None => continue,
            };

            let file_size = captures[1].parse::<u64>().unwrap();
            let mut path_clone = current_dir.clone();

            while path_clone != PathBuf::from("/") {
                let new_file_size = match file_list.get_mut(&path_clone) {
                    Some(size) => *size + file_size,
                    None => file_size,
                };

                file_list.insert(path_clone.clone(), new_file_size);
                path_clone.pop();
            }

            drop(path_clone);

            let new_file_size = match file_list.get_mut(&PathBuf::from("/")) {
                Some(size) => *size + file_size,
                None => file_size,
            };
            file_list.insert(PathBuf::from("/"), new_file_size);
        }
    }

    drop(last_command);
    drop(current_dir);

    let mut file_size: u64 = 0;
    for (_, size) in file_list {
        if size >= 100000 {
            continue;
        }
        file_size += size;
    }

    file_size.to_string()
}

pub fn part_2(input: String) -> String {
    let mut file_list: HashMap<PathBuf, u64> = HashMap::new();
    let mut current_dir: PathBuf = PathBuf::from("/");
    let mut last_command = "";

    for line in input.lines() {
        // Command mode
        if line.starts_with("$") {
            let args = line.split(" ").collect::<Vec<&str>>().as_slice()[1..].to_vec();
            last_command = args[0];

            if last_command == "cd" {
                if args[1] == ".." {
                    current_dir.pop();
                } else if args[1] == "/" {
                    current_dir = PathBuf::from("/");
                } else {
                    current_dir.push(args[1]);
                }
            }
        } else if last_command == "ls" {
            let re = Regex::new(r"(\d+) (.*)").unwrap();
            let captures = match re.captures(line) {
                Some(captures) => captures,
                None => continue,
            };

            let file_size = captures[1].parse::<u64>().unwrap();
            let mut path_clone = current_dir.clone();

            while path_clone != PathBuf::from("/") {
                let new_file_size = match file_list.get_mut(&path_clone) {
                    Some(size) => *size + file_size,
                    None => file_size,
                };

                file_list.insert(path_clone.clone(), new_file_size);
                path_clone.pop();
            }

            drop(path_clone);

            let new_file_size = match file_list.get_mut(&PathBuf::from("/")) {
                Some(size) => *size + file_size,
                None => file_size,
            };
            file_list.insert(PathBuf::from("/"), new_file_size);
        }
    }

    drop(last_command);
    drop(current_dir);

    let avaiable_space = 70000000 - file_list.get(&PathBuf::from("/")).unwrap();
    let mut smallest: u64 = 0;

    for (_, size) in file_list {
        if 30000000 > size + avaiable_space {
            continue;
        }

        if smallest != 0 && size >= smallest {
            continue;
        }

        smallest = size;
    }

    smallest.to_string()
}
