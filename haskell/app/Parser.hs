module Parser where

data Parser a = Parser String a|ParseError

instance Functor Parser where
    fmap f (Parser s x) = Parser s (f x)
    fmap _ ParseError = ParseError
