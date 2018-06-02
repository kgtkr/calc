defmodule Parser do
  def expect(<<x::bytes-size(1)>><>xs,f) do
    if f.(x) do
      {:ok,xs}
    else
      {:error,nil}
    end
  end

  def char(s,c),do: expect(s,fn x -> x==c end)

  def number("+"<>_),do: {:error,nil}
  def number(s) do
    case Integer.parse(s) do
      :error -> {:error, nil}
      x -> {:ok, x}
    end
  end
end