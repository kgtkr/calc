use std::ops::{Add, Sub};
use std::fmt;

fn main() {
    println!("Hello, world!");
}

#[derive(Debug)]
enum CalcError {
    Zero,
    Parse,
}

struct Rational {
    n: i64,
    d: i64,
}

impl Rational {
    fn new(n: i64, d: i64) -> Result<Rational, CalcError> {
        if d == 0 {
            Err(CalcError::Zero)
        } else {
            Ok(Rational { n: n, d: d })
        }
    }
}

impl From<i64> for Rational {
    fn from(n: i64) -> Rational {
        Rational::new(n, 1).unwrap()
    }
}

impl fmt::Display for Rational {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        if self.d == 1 {
            write!(f, "{}", self.n)
        } else {
            write!(f, "{}/{}", self.n, self.d)
        }
    }
}
