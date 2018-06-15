export type Rational = {
  n: number, d: number
} | null;

function gcd(a: number, b: number): number {
  if (b === 0) {
    return a;
  } else {
    return gcd(b, a % b)
  }
}

export function rational(n: number, d: number) {
  if (d == 0) {
    return null;
  } else {
    let g = gcd(Math.abs(n), Math.abs(d));
    g = d < 0 ? -g : g;
    return {
      n: n / g | 0,
      d: d / g | 0
    };
  }
}


export function toString(self: Rational) {
  if (self === null) {
    return "NaN";
  } else {
    if (self.d === 1) {
      return self.n.toString();
    } else {
      return `${self.n}/${self.d}`;
    }
  }
}

export function add(a: Rational, b: Rational) {
  if (a !== null && b !== null) {
    return rational(a.n * b.d + b.n * a.d, a.d * b.d);
  } else {
    return null;
  }
}

export function sub(a: Rational, b: Rational) {
  if (a !== null && b !== null) {
    return rational(a.n * b.d - b.n * a.d, a.d * b.d);
  } else {
    return null;
  }
}

export function mul(a: Rational, b: Rational) {
  if (a !== null && b !== null) {
    return rational(a.n * b.n, a.d * b.d);
  } else {
    return null;
  }
}

export function div(a: Rational, b: Rational) {
  if (a !== null && b !== null) {
    return rational(a.n * b.d, a.d * b.n);
  } else {
    return null;
  }
}