module Ratio where

data Ratio= Ratio Int Int|NaN

ratio :: Int -> Int -> Ratio
ratio _ 0 = NaN
ratio n d = Ratio (n `div` g) (d `div` g)
    where g = signum d * gcd (abs n) (abs d)

instance Show Ratio where
    show NaN="NaN"
    show (Ratio n 1)=show n
    show (Ratio n d)=(show n)++"/"++(show d)
