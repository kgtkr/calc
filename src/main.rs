mod rational;
mod source;

fn main() {
    println!(
        "{}",
        std::env::args()
            .nth(1)
            .and_then(|s| source::Source::new(s).expr())
            .map(|r| format!("{}", r))
            .unwrap_or("Error".to_string())
    );
}
