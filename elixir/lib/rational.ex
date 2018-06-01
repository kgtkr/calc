defmodule Rational do
  defstruct [:n, :d]

  def new(n,0),do:nil
  def new(n,d) do
    g = gcd abs(n) abs(d)
    g = if
      d < 0
    do
      -g
    else
      g
    end

    %Rational{n: n/g, d:d/g}
  end

  def fromInt(n),do:new n 1

  def gcd(a,0),do:a
  def gcd(a,b),do:gcd(b, a % b)
end