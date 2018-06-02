defmodule Rational do
  defstruct [:n, :d]

  def new(_,0) , do: :nan
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

  def to_string(:nan),do: "NaN"
  def to_string(%Rational{n: n, d: 1}), do: Kernel.to_string n
  def to_string(%Rational{n: n, d: d}), do: Kernel.to_string n <> "/" <> Kernel.to_string d

  def add(%Rational{n: a_n, d: a_d},%Rational{n: b_n, d: b_d}), do: new(a_n * b_d + b_n * a_d, a_d * b_d)
  def add(_,_), do: :nan

  def sub(%Rational{n: a_n, d: a_d},%Rational{n: b_n, d: b_d}), do: new(a_n * b_d - b_n * a_d, a_d * b_d)
  def sub(_,_), do: :nan

  def mul(%Rational{n: a_n, d: a_d},%Rational{n: b_n, d: b_d}), do: new(a_n*b_n,a_d*b_d)
  def mul(_,_), do: :nan

  def div(%Rational{n: a_n, d: a_d},%Rational{n: b_n, d: b_d}), do: new(a_n*b_d,a_d*b_n)
  def div(_,_), do: :nan
end