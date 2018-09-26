module Parser where

import qualified Data.Bifunctor                as B

data Parser a = Parser (String -> Maybe (a,String))

instance Functor Parser where
    fmap f (Parser x) = Parser $ \s->(fmap (B.first f) . x) s

instance Applicative Parser where
    pure x = Parser (\s->Just (x,s))

    Parser x  <*> Parser y       = Parser $ \s->x s >>= (\(f,s)->(fmap (B.first f) . y) s)

instance Monad Parser where
    Parser x >>= f = Parser $ \s->x s >>= (\(a,s)->let Parser g=f a in g s)

runParser :: Parser a -> String -> Maybe a
runParser (Parser x) = fmap fst . x
