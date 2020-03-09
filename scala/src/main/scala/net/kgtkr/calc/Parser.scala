package net.kgtkr.calc

import cats.data.`package`.StateT
import cats.implicits._
import cats.Monad

final case class Parser[A](run: StateT[Option, List[Char], A]) {
  def parse(xs: List[Char]): Option[(List[Char], A)] = this.run.run(xs)

  def parseString(s: String): Option[A] = this.parse(s.toList).map(_._2)

  def many1: Parser[List[A]] = {
    for {
      x <- this
      xs <- this.many
    } yield (x :: xs)
  }

  def many: Parser[List[A]] = Parser { s => Some(this._many(s)) }

  private def _many(s: List[Char]): (List[Char], List[A]) = {
    this.parse(s) match {
      case Some((s, x)) => {
        val (s2, xs) = this._many(s);
        (s2, x :: xs)
      }
      case None => (s, List())
    }
  }

  def orEither[B](pb: => Parser[B]): Parser[Either[A, B]] = Parser { s =>
    this.parse(s) match {
      case Some((s, a)) => Some((s, Left(a)))
      case None => {
        pb.parse(s) match {
          case Some((s, b)) => Some((s, Right(b)))
          case None         => None
        }
      }
    }
  }

  def or(other: => Parser[A]): Parser[A] =
    this.orEither(other).map(_.fold(x => x, x => x))

  def and[B](pb: => Parser[B]): Parser[(A, B)] = {
    for {
      a <- this
      b <- pb
    } yield (a, b)
  }

  def chainl1(op: => Parser[(A, A) => A]): Parser[A] = {
    Parser { s =>
      this.parse(s) match {
        case Some((s, x)) => Some(this._chainl1(x, s, op))
        case None         => None
      }
    }
  }

  private def _chainl1(
      x: A,
      s: List[Char],
      op: => Parser[(A, A) => A]
  ): (List[Char], A) = {
    op.and(this).parse(s) match {
      case Some((s, (f, y))) => this._chainl1(f(x, y), s, op)
      case None              => (s, x)
    }
  }
}

object Parser {
  implicit val monad: Monad[Parser] = new Monad[Parser] {
    def pure[A](x: A): Parser[A] =
      Parser(Monad[StateT[Option, List[Char], *]].pure(x))
    def flatMap[A, B](fa: Parser[A])(f: A => Parser[B]): Parser[B] =
      Parser(
        Monad[StateT[Option, List[Char], *]].flatMap(fa.run)(a => f(a).run)
      )

    def tailRecM[A, B](a: A)(f: A => Parser[Either[A, B]]): Parser[B] =
      Parser(
        Monad[StateT[Option, List[Char], *]].tailRecM[A, B](a)(a => f(a).run)
      )
  }

  def apply[A](f: (List[Char]) => Option[(List[Char], A)]): Parser[A] =
    Parser(StateT(f))

  def any: Parser[Char] = satisfy(_ => true)

  def raise[A]: Parser[A] = Parser(_ => None)

  def satisfy(f: (Char) => Boolean): Parser[Char] = Parser { s =>
    s match {
      case x :: xs if f(x) => Some((xs, x))
      case _               => None
    }
  }

  def char(c: Char): Parser[Char] = satisfy(_ === c)

  def eof: Parser[Unit] = Parser { s =>
    s match {
      case Nil => Some((s, ()))
      case _   => None
    }
  }
}
