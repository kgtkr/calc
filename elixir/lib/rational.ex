defmodule Rational do
  defstruct [:n, :d]

  def new(_,0) , do: nil
  def new(n,d) do
    g = gcd abs(n), abs(d)
    g=if d < 0 do
      -g
    else
      g
    end

    %Rational{n: n/g, d: d/g}
  end

  def from_int(n), do: new n,1

  def gcd(a,0), do: a
  def gcd(a,b), do: gcd b, rem(a,b)

  def to_string(nil),do: "NaN"
  def to_string(%Rational{n: n, d: 1}), do: Kernel.to_string n

  def add(%Rational{n: a_n, d: a_d},%Rational{n: b_n, d: b_d}), do: new(a_n * b_d + b_n * a_d, a_d * b_d)
  def add(_,_), do: nil
end