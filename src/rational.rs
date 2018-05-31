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
    if let &Rational::Value {
      n: self_n,
      d: self_d,
    } = self
    {
      if self_d == 1 {
        write!(f, "{}", self_n)
      } else {
        write!(f, "{}/{}", self_n, self_d)
      }
    } else {
      write!(f, "NaN")
    }
  }
}

impl Add for Rational {
  type Output = Rational;

  fn add(self, other: Rational) -> Rational {
    if let (
      Rational::Value {
        n: self_n,
        d: self_d,
      },
      Rational::Value {
        n: other_n,
        d: other_d,
      },
    ) = (self, other)
    {
      Rational::new(self_n * other_d + other_n * self_d, self_d * other_d)
    } else {
      Rational::NaN
    }
  }
}

impl AddAssign for Rational {
  fn add_assign(&mut self, other: Rational) {
    *self = *self + other;
  }
}

impl Sub for Rational {
  type Output = Rational;

  fn sub(self, other: Rational) -> Rational {
    if let (
      Rational::Value {
        n: self_n,
        d: self_d,
      },
      Rational::Value {
        n: other_n,
        d: other_d,
      },
    ) = (self, other)
    {
      Rational::new(self_n * other_d - other_n * self_d, self_d * other_d)
    } else {
      Rational::NaN
    }
  }
}

impl SubAssign for Rational {
  fn sub_assign(&mut self, other: Rational) {
    *self = *self - other;
  }
}

impl Mul for Rational {
  type Output = Rational;

  fn mul(self, other: Rational) -> Rational {
    if let (
      Rational::Value {
        n: self_n,
        d: self_d,
      },
      Rational::Value {
        n: other_n,
        d: other_d,
      },
    ) = (self, other)
    {
      Rational::new(self_n * other_n, self_d * other_d)
    } else {
      Rational::NaN
    }
  }
}

impl MulAssign for Rational {
  fn mul_assign(&mut self, other: Rational) {
    *self = *self * other;
  }
}

impl Div for Rational {
  type Output = Rational;

  fn div(self, other: Rational) -> Rational {
    if let (
      Rational::Value {
        n: self_n,
        d: self_d,
      },
      Rational::Value {
        n: other_n,
        d: other_d,
      },
    ) = (self, other)
    {
      Rational::new(self_n * other_d, self_d * other_n)
    } else {
      Rational::NaN
    }
  }
}

impl DivAssign for Rational {
  fn div_assign(&mut self, other: Rational) {
    *self = *self / other;
  }
}
