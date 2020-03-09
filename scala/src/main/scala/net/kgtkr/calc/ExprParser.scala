package net.kgtkr.calc

import cats.implicits._

object ExprParser {
  def number: Parser[Int] =
    Parser
      .satisfy(_.isDigit)
      .many1
      .map(_.mkString("").toInt)

  def literal: Parser[Expr] = number.map(Expr.Literal)

  def parser: Parser[Expr] = expr <* Parser.eof

  def expr: Parser[Expr] =
    term.chainl1(
      Parser
        .char('+')
        .as(Expr.Add((_: Expr), (_: Expr)): Expr)
        .or(
          Parser
            .char('-')
            .as(Expr.Sub((_: Expr), (_: Expr)): Expr)
        )
    )

  def term: Parser[Expr] = prefixedFactor.chainl1(
    Parser
      .char('*')
      .map(_ => Expr.Mul((_: Expr), (_: Expr)): Expr)
      .or(
        Parser
          .char('/')
          .map(_ => Expr.Div((_: Expr), (_: Expr)): Expr)
      )
  )

  def prefixedFactor: Parser[Expr] =
    (Parser.char('+').flatMap(_ => prefixedFactor.map(Expr.Plus(_): Expr)))
      .or(Parser.char('-').flatMap(_ => prefixedFactor.map(Expr.Minus(_): Expr)))
      .or(factor)

  def factor: Parser[Expr] =
    literal.or(Parser.char('(') *> expr <* Parser.char(')'))
}
