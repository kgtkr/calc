module Parser where

import           Ratio
import qualified Data.Bifunctor                as B
import           Data.Char
import           Safe

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

parseErrorIf :: Bool -> Parser ()
parseErrorIf True  = parseError
parseErrorIf False = return ()

parseOK :: Parser a -> Parser Bool
parseOK p = parseOr
    (do
        p
        return True
    )
    (return False)

parseOr :: Parser a -> Parser a -> Parser a
parseOr (Parser a) (Parser b) = Parser parseOr'
  where
    parseOr' s = case a s of
        Just x  -> Just x
        Nothing -> b s

parseTry :: Parser a -> Parser (Maybe a)
parseTry p = parseOr ((fmap Just) p) (return Nothing)

parseUnTry :: Parser (Maybe a) -> Parser a
parseUnTry p = do
    x <- p
    case x of
        Just x  -> return x
        Nothing -> parseError

parseTryWhile :: Parser a -> Parser [a]
parseTryWhile p = do
    x <- parseTry p
    case x of
        Just x -> do
            xs <- parseTryWhile p
            return $ x : xs
        Nothing -> return []

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

parseChar :: Char -> Parser Char
parseChar c = parseExpect (== c)

parseNumber :: Parser Ratio
parseNumber = do
    g <- parseOr
        (do
            parseChar '-'
            return (-1)
        )
        (return 1)
    ns <- parseTryWhile $ parseExpect isDigit
    case ns of
        '0' : _ : _ -> parseError
        _           -> return ()
    n <- (parseUnTry . return . readMay) ns
    return $ ratio (n * g) 1

parseEof :: Parser ()
parseEof = Parser parseEof'
  where
    parseEof' [] = Just ((), [])
    parseEof' _  = Nothing

parseFactor :: Parser Ratio
parseFactor = do
    isExpr <- parseOK $ parseChar '('
    if isExpr
        then do
            x <- parseExpr
            parseChar ')'
            return x
        else parseNumber

parseTerm :: Parser Ratio
parseTerm = do
    x <- parseFactor
    parseTerm' x
  where
    parseTerm' x = do
        op <- parseTry (parseExpect (\c -> c == '*' || c == '/'))
        case op of
            Just '*' -> do
                y <- parseFactor
                parseTerm' $ x * y
            Just '/' -> do
                y <- parseFactor
                parseTerm' $ x / y
            Nothing -> return x


parseExpr :: Parser Ratio
parseExpr = do
    x <- parseTerm
    parseExpr' x
  where
    parseExpr' x = do
        op <- parseTry (parseExpect (\c -> c == '+' || c == '-'))
        case op of
            Just '+' -> do
                y <- parseTerm
                parseExpr' $ x + y
            Just '-' -> do
                y <- parseTerm
                parseExpr' $ x - y
            Nothing -> return x

