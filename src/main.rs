mod rational;
use rational::Rational;

fn main() {
    println!("Hello, world!");
}

#[derive(Debug)]
enum CalcError {
    Zero,
    Parse,
}
