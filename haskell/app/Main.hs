module Main where

import           System.Environment
import           Ratio
import           Parser

main :: IO ()
main = do
    args <- getArgs
    putStrLn $ case args of
        (s : _) -> (maybe "Error" show) (runParser parseCalc s)
        []      -> "Error"
