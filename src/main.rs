mod rational;
use rational::Rational;
mod source;

fn main() {
    println!(
        "{}",
        source::Source::new(std::env::args().nth(1).unwrap())
            .expr()
            .unwrap()
    );
}
