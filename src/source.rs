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
}
