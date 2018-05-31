pub struct Source {
  s: Vec<char>,
  pos: usize,
}

impl Source {
  fn new(s: String, pos: usize) -> Source {
    Source {
      s: s.chars().collect(),
      pos: pos,
    }
  }

  fn peek(&self) -> Option<char> {
    self.s.get(self.pos).cloned()
  }

  fn next(&mut self) {
    self.pos += 1;
  }
}
