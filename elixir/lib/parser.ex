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
      {x,s} -> {:ok, {Rational.from_int(x),s}}
    end
  end

  def eof(""),do: {:ok,{nil,""}}
  def eof(_),do: {:error,nil}

  def expr(s) do
    OK.for do
      {x,s}<-term(s)
      res<-expr(s,x)
    after
      res
    end
  end
  def expr("+"<>s,n) do
    OK.for do
      {x,s}<-term(s)
      res<-expr(s,Rational.add(n,x))
    after
      res
    end
  end
  def expr("-"<>s,n) do
    OK.for do
      {x,s}<-term(s)
      res<-expr(s,Rational.sub(n,x))
    after
      res
    end
  end
  def expr(s,n) do
    OK.for do
      {_,s}=eof(s)
    after
      {n,s}
    end
  end
  def term(s) do
    OK.for do
      {x,s}<-factor(s)
      res<-term(s,x)
    after
      res
    end
  end
  def term("*"<>s,n) do
    OK.for do
      {x,s}<-factor(s)
      res<-term(s,Rational.mul(n,x))
    after
      res
    end
  end
  def term("/"<>s,n) do
    OK.for do
      {x,s}<-factor(s)
      res<-term(s,Rational.div(n,x))
    after
      res
    end
  end
  def term(s,n),do: {:ok,{n,s}}
  def factor("("<>s) do
    OK.for do
      {x,s}<-expr(s)
      char(s,")")
    after
      x
    end
  end
  def factor(s),do: number(s)
end