require OK

defmodule Calc do
  def main() do
    OK.with do
      s<-case List.first System.argv do
        nil->{:error,nil}
        x->{:ok,x}
      end
      s|>Parser.expr|>Rational.to_string|>IO.puts
    else
      _->IO.puts("Error")
    end
  end
end
