pub struct Source {
  s: Vec<char>,
  pos: usize,
}

impl Source {
  fn new(s: String) -> Source {
    Source {
      s: s.chars().collect(),
      pos: 0,
    }
  }

  fn peek(&self) -> Option<char> {
    self.s.get(self.pos).cloned()
  }

  fn next(&mut self) -> Option<char> {
    let val = self.peek();
    self.pos += 1;
    val
  }

  fn num(&mut self) -> Option<i64> {
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

    s.parse().ok()
  }
}
