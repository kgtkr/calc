require OK

defmodule Calc do
  def main() do
    OK.try do
      s<-case List.first System.argv do
        nil->{:error,nil}
        x->{:ok,x}
      end
      x<-Parser.parse s
      x|>Rational.to_string|>IO.puts
    after
      nil
    rescue
      _->IO.puts("Error")
    end
  end
end
