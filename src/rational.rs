use std::ops::{Add, AddAssign, Div, DivAssign, Mul, MulAssign, Sub, SubAssign};
use std::fmt;

fn gcd(a: i64, b: i64) -> i64 {
  if b == 0 {
    a
  } else {
    gcd(b, a % b)
  }
}

pub enum Rational {
  Value { n: i64, d: i64 },
  NaN,
}

impl Rational {
  pub fn new(n: i64, d: i64) -> Rational {
    if d == 0 {
      Rational::NaN
    } else {
      let g = gcd(n.abs(), d.abs());
      let g = if d < 0 { -g } else { g };
      Rational::Value { n: n / g, d: d / g }
    }
  }
}

impl From<i64> for Rational {
  fn from(n: i64) -> Rational {
    Rational::new(n, 1)
  }
}

impl fmt::Display for Rational {
  fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
    if let &Rational::Value(ref value) = self {
      if value.d == 1 {
        write!(f, "{}", value.n)
      } else {
        write!(f, "{}/{}", value.n, value.d)
      }
    } else {
      write!(f, "NaN")
    }
  }
}

impl Add for Rational {
  type Output = Rational;

  fn add(self, other: Rational) -> Rational {
    if let (Rational::Value(value), Rational::Value(other)) = (self, other) {
      Rational::new(value.n * other.d + other.n * value.d, value.d * other.d)
    } else {
      Rational::NaN
    }
  }
}

impl Sub for Rational {
  type Output = Rational;

  fn sub(self, other: Rational) -> Rational {
    if let (Rational::Value(value), Rational::Value(other)) = (self, other) {
      Rational::new(value.n * other.d - other.n * value.d, value.d * other.d)
    } else {
      Rational::NaN
    }
  }
}

impl Mul for Rational {
  type Output = Rational;

  fn mul(self, other: Rational) -> Rational {
    if let (Rational::Value(value), Rational::Value(other)) = (self, other) {
      Rational::new(value.n * other.n, value.d * other.d)
    } else {
      Rational::NaN
    }
  }
}

impl Div for Rational {
  type Output = Rational;

  fn div(self, other: Rational) -> Rational {
    if let (Rational::Value(value), Rational::Value(other)) = (self, other) {
      Rational::new(value.n * other.d, value.d * other.n)
    } else {
      Rational::NaN
    }
  }
}
