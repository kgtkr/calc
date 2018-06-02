require OK

# {:error,nil}|{:ok,{T,str}}
defmodule Parser do
  def expect(<<x::bytes-size(1)>><>xs,f) do
    if f.(x) do
      {:ok,{x,xs}}
    else
      {:error,nil}
    end
  end

  def char(s,c),do: expect(s,fn x -> x==c end)

  def number("+"<>_),do: {:error,nil}
  def number(s) do
    case Integer.parse(s) do
      :error -> {:error, nil}
      x -> {:ok, Rational.from_int(x)}
    end
  end

  def eof(""),do: {:ok,{nil,""}}
  def eof(_),do: {:error,nil}

  def expr(_),do: nil
  def term(s) do
    OK.with do
      {x,s}<-factor(s)
      term(s,x)
    end
  end
  def term("*"<>s,n) do
    OK.with do
      {x,s}<-factor(s)
      term(s,Rational.mul(n,x))
    end
  end
  def term("/"<>s,n) do
    OK.with do
      {x,s}<-factor(s)
      term(s,Rational.div(n,x))
    end
  end
  def term(s,n),do: {:ok,{n,s}}
  def factor("("<>s) do
    OK.with do
      {x,s}<-expr(s)
      char(s,")")
      x
    end
  end
  def factor(s),do: number(s)
end