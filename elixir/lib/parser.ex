defmodule Parser do
  def expect([x|xs],f) do
    if f.(x) do
      {:ok,xs}
    else
      {:error}
    end
  end

  def char(s,c),do: expect(s,fn x -> x==c end)
end