use rational::Rational;

pub struct Source {
  s: Vec<char>,
  pos: usize,
}

impl Source {
  pub fn new(s: String) -> Source {
    Source {
      s: s.chars().collect(),
      pos: 0,
    }
  }

  pub fn peek(&self) -> Option<char> {
    self.s.get(self.pos).cloned()
  }

  pub fn next(&mut self) -> Option<char> {
    let val = self.peek();
    self.pos += 1;
    val
  }

  pub fn number(&mut self) -> Option<Rational> {
    let mut s = String::new();
    if self.peek() == Some('-') {
      self.next();
      s.push('-');
    }

    while let Some(c) = self.peek() {
      if c.is_digit(10) {
        s.push(c);
        self.next();
      } else {
        break;
      }
    }

    s.parse::<i64>().ok().map(Rational::from)
  }

  pub fn expr(&mut self) -> Option<Rational> {
    let mut x = self.term()?;
    while let Some(c) = self.peek() {
      match c {
        '+' => {
          self.next();
          x += self.term()?;
        }
        '-' => {
          self.next();
          x -= self.term()?;
        }
        _ => {
          break;
        }
      }
    }
    Some(x)
  }

  pub fn term(&mut self) -> Option<Rational> {
    let mut x = self.factor()?;
    while let Some(c) = self.peek() {
      match c {
        '*' => {
          self.next();
          x *= self.factor()?;
        }
        '/' => {
          self.next();
          x /= self.factor()?;
        }
        _ => {
          break;
        }
      }
    }
    Some(x)
  }

  pub fn factor(&mut self) -> Option<Rational> {
    if self.peek() == Some('(') {
      self.next();
      let ret = self.expr();
      if self.peek() == Some(')') {
        self.next();
      }
      ret
    } else {
      self.number()
    }
  }
}
