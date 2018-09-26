module Parser where

import qualified Data.Bifunctor                as B

data Parser a = Parser (String -> (a,String))|ParseError

instance Functor Parser where
    fmap f (Parser x) = Parser (\s->(B.first f . x) s)
    fmap _ ParseError = ParseError

instance Applicative Parser where
    pure x = Parser (\s->(x,s))

    Parser x  <*> Parser y       = Parser (\s->let (f,s)=x s in (B.first f . y) s)
    ParseError <*> _      = ParseError
    _ <*> ParseError      = ParseError

instance Monad Parser where
    Parser x >>= f = f x
    ParseError >>= _ =ParseError
