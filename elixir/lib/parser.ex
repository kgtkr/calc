require OK

# {:error,nil}|{:ok,{T,str}}
defmodule Parser do
  defp expect(<<x::bytes-size(1)>><>xs,f) do
    if f.(x) do
      {:ok,{x,xs}}
    else
      {:error,nil}
    end
  end

  defp expect(_,_),do: {:error,nil}

  defp char(s,c),do: expect(s,fn x -> x==c end)

  defp number("+"<>_),do: {:error,nil}
  defp number(s) do
    case Integer.parse(s) do
      :error -> {:error, nil}
      {x,s} -> {:ok, {Rational.from_int(x),s}}
    end
  end

  defp eof(""),do: {:ok,{nil,""}}
  defp eof(_),do: {:error,nil}

  defp expr(s) do
    OK.for do
      {x,s}<-term(s)
      res<-expr(s,x)
    after
      res
    end
  end
  defp expr("+"<>s,n) do
    OK.for do
      {x,s}<-term(s)
      res<-expr(s,Rational.add(n,x))
    after
      res
    end
  end
  defp expr("-"<>s,n) do
    OK.for do
      {x,s}<-term(s)
      res<-expr(s,Rational.sub(n,x))
    after
      res
    end
  end
  defp expr(s,n) do
    {:ok,{n,s}}
  end
  def parse(s) do
    OK.for do
      {x,s}<-expr(s)
      _<-eof(s)
    after
      x
    end
  end
  defp term(s) do
    OK.for do
      {x,s}<-factor(s)
      res<-term(s,x)
    after
      res
    end
  end
  defp term("*"<>s,n) do
    OK.for do
      {x,s}<-factor(s)
      res<-term(s,Rational.mul(n,x))
    after
      res
    end
  end
  defp term("/"<>s,n) do
    OK.for do
      {x,s}<-factor(s)
      res<-term(s,Rational.div(n,x))
    after
      res
    end
  end
  defp term(s,n),do: {:ok,{n,s}}
  defp factor("("<>s) do
    OK.for do
      {x,s}<-expr(s)
      {_,s}<-char(s,")")
    after
      {x,s}
    end
  end
  defp factor(s),do: number(s)
end