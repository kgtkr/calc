package net.kgtkr.calc

import cats.kernel.Eq
import cats.implicits._
import cats.kernel.Monoid
import IntUtils._
import cats.kernel.Order
import cats.Show

object IntUtils {
  implicit class Gcd(a: Int) {
    def gcd(b: Int): Int = {
      if (b == 0) {
        a
      } else {
        b.gcd(a % b)
      }
    }
  }
}

final case class Rational(n: Int, d: Int) {
  assert(d > 0)
  assert(n.gcd(d) === 1)

  def unary_- : Rational = Rational.fromNotZero(-this.n, this.d)

  def unary_+ : Rational = this

  def recip: Option[Rational] = Rational.from(this.d, this.n)

  def +(other: Rational): Rational =
    Rational.fromNotZero(this.n * other.d + other.n * this.d, this.d * other.d)

  def -(other: Rational): Rational = this + (-other)

  def *(other: Rational): Rational =
    Rational.fromNotZero(this.n * other.n, this.d * other.d)

  def /(other: Rational): Option[Rational] = other.recip.map(this * _)

  override def toString =
    if (this.d =!= 1) f"${this.n}/${this.d}" else { this.n.toString() }
}

object Rational {
  def from(n: Int, d: Int): Option[Rational] = {
    if (d === 0) {
      None
    } else {
      Some(Rational.fromNotZero(n, d))
    }
  }

  def fromNotZero(n: Int, d: Int): Rational = {
    assert(d =!= 0)
    val g = d.sign * n.abs.gcd(d.abs);
    Rational(n / g, d / g);
  }

  def fromInt(n: Int): Rational = {
    Rational(n, 1)
  }

  implicit val eq: Eq[Rational] = Eq.fromUniversalEquals;
  implicit val monoid: Monoid[Rational] = new Monoid[Rational] {
    def empty: Rational = Rational.fromInt(0)
    def combine(a: Rational, b: Rational): Rational = a + b
  }

  implicit val show: Show[Rational] = Show.fromToString

  implicit val order: Order[Rational] = new Order[Rational] {
    def compare(x: Rational, y: Rational): Int = {
      val a = x.n * y.d;
      val b = y.n * x.d;
      a compare b
    }
  }
}
