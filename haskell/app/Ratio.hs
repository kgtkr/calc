module Ratio where

data Ratio= Ratio Int Int|NaN

ratio :: Int -> Int -> Ratio
ratio _ 0 = NaN
ratio n d = Ratio (n `div` g) (d `div` g)
    where g = signum d * gcd (abs n) (abs d)


