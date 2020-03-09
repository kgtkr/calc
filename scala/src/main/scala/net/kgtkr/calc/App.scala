package net.kgtkr.calc;

object App {
  def main(args: Array[String]): Unit = {
    while (true) {
      print("input:");
      val input = io.StdIn.readLine();
      if (input == ":q") {
        return;
      }
      println((for {
        expr <- ExprParser.parser
          .parseString(input)
          .map(Right(_))
          .getOrElse(Left("parse error"))
        x <- Expr.eval(expr).map(Right(_)).getOrElse(Left("eval error"))
      } yield x.toString()).fold(x => x, x => x))
    }
  }

}
