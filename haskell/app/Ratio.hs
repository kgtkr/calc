module Ratio where

import qualified Data.Ratio                    as R

data Ratio= Ratio Int Int|NaN deriving (Eq)

ratio :: Int -> Int -> Ratio
ratio _ 0 = NaN
ratio n d = Ratio (n `div` g) (d `div` g)
    where g = signum d * gcd (abs n) (abs d)

instance Show Ratio where
    show NaN="NaN"
    show (Ratio n 1)=show n
    show (Ratio n d)=(show n)++"/"++(show d)

instance Num Ratio where
    NaN + _ = NaN
    _ + NaN = NaN
    (Ratio an ad) + (Ratio bn bd)=ratio (an * bd + bn * ad) (ad*bd)

    NaN * _ = NaN
    _ * NaN = NaN
    (Ratio an ad) * (Ratio bn bd)=ratio (an * bn) (ad*bd)

    negate NaN=NaN
    negate (Ratio n d) = ratio (negate n) d

    abs NaN=NaN
    abs (Ratio n d)=ratio (abs n) d

    fromInteger x=ratio (fromInteger x) 1

    signum NaN=NaN
    signum (Ratio n _)=ratio (signum n) 1


instance Fractional Ratio where
    recip NaN=NaN
    recip (Ratio n d)=ratio d n

    fromRational x=ratio ((fromInteger . R.numerator) x) ((fromInteger . R.denominator) x)
