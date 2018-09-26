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

parseError :: Parser a
parseError = Parser $ \_ -> Nothing

parseOr :: Parser a -> Parser a -> Parser a
parseOr (Parser a) (Parser b) = Parser parseOr'
  where
    parseOr' s = case a s of
        Just x  -> Just x
        Nothing -> b s

parsePeak :: Parser Char
parsePeak = Parser parsePeak'
  where
    parsePeak' []        = Nothing
    parsePeak' s@(x : _) = Just (x, s)

parseNext :: Parser Char
parseNext = Parser parseNext'
  where
    parseNext' []       = Nothing
    parseNext' (x : xs) = Just (x, xs)


parseExpect :: (Char -> Bool) -> Parser Char
parseExpect f = do
    v <- parsePeak
    if f v
        then do
            parseNext
            return v
        else parseError
