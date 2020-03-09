package net.kgtkr.calc

sealed trait Expr;

object Expr {
  final case class Literal(x: Int) extends Expr;
  final case class Plus(expr: Expr) extends Expr;
  final case class Minus(expr: Expr) extends Expr;
  final case class Add(a: Expr, b: Expr) extends Expr;
  final case class Sub(a: Expr, b: Expr) extends Expr;
  final case class Mul(a: Expr, b: Expr) extends Expr;
  final case class Div(a: Expr, b: Expr) extends Expr;

  def eval(expr: Expr): Option[Rational] = {
    expr match {
      case Literal(x)  => Some(Rational.fromInt(x))
      case Plus(expr)  => eval(expr).map(+_)
      case Minus(expr) => eval(expr).map(-_)
      case Add(a, b)   => eval(a).flatMap(a => eval(b).map(b => a + b))
      case Sub(a, b)   => eval(a).flatMap(a => eval(b).map(b => a - b))
      case Mul(a, b)   => eval(a).flatMap(a => eval(b).map(b => a * b))
      case Div(a, b)   => eval(a).flatMap(a => eval(b).flatMap(b => a / b))
    }
  }

}
