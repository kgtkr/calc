module Parser where

data Parser a = Parser String a|ParseError

instance Functor Parser where
    fmap f (Parser s x) = Parser s (f x)
    fmap _ ParseError = ParseError

instance Applicative Parser where
    pure = Parser ""

    Parser _ f  <*> m       = fmap f m
    ParseError <*> _      = ParseError

instance Monad Parser where
    Parser _ x >>= f = f x
    ParseError >>= _ =ParseError
