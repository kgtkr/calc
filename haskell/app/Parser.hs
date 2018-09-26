module Parser where

import qualified Data.Bifunctor                as B

data Parser a = Parser (String -> Maybe (a,String))

instance Functor Parser where
    fmap f (Parser x) = Parser $ \s->(fmap (B.first f) . x) s

instance Applicative Parser where
    pure x = Parser (\s->Just (x,s))

    Parser x  <*> Parser y       = Parser $ \s->case x s of
        Just (f,s)->fmap (B.first f) (y s)
        Nothing->Nothing

instance Monad Parser where
    Parser x >>= f = Parser $ \s->case x s of
        Just (a,s)->let Parser g=f a in g s
        Nothing->Nothing
