defmodule Parser do
  def expect(<<x::bytes-size(1)>><>xs,f) do
    if f.(x) do
      xs
    else
      throw v
    end
  end

  def char(s,c),do: expect(s,fn x -> x==c end)

  def number
end