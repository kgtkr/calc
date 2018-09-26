module Parser where

import           Ratio
import qualified Data.Bifunctor                as B
import           Data.Char
import           Safe
import           Control.Monad.State

type Parser = StateT String Maybe

runParser :: Parser a -> String -> Maybe a
runParser = evalStateT

parseError :: Parser a
parseError = StateT $ const Nothing

parseErrorIf :: Bool -> Parser ()
parseErrorIf True  = parseError
parseErrorIf False = return ()

parseOK :: Parser a -> Parser Bool
parseOK p = parseOr [parseValue p True, return False]

parseOr :: [Parser a] -> Parser a
parseOr x = StateT $ parseOr' x
  where
    parseOr' (StateT p : ps) s = case p s of
        Just x  -> Just x
        Nothing -> parseOr' ps s
    parseOr' [] _ = Nothing

parseTry :: Parser a -> Parser (Maybe a)
parseTry p = parseOr [(fmap Just) p, return Nothing]

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
parsePeak = StateT parsePeak'
  where
    parsePeak' []        = Nothing
    parsePeak' s@(x : _) = Just (x, s)

parseNext :: Parser Char
parseNext = StateT parseNext'
  where
    parseNext' []       = Nothing
    parseNext' (x : xs) = Just (x, xs)


parseExpect :: (Char -> Bool) -> Parser Char
parseExpect f = do
    v <- parsePeak
    if f v then parseValue parseNext v else parseError

parseValue :: Parser a -> b -> Parser b
parseValue p x = do
    p
    return x

parseChar :: Char -> Parser Char
parseChar c = parseExpect (== c)

parseNumber :: Parser Ratio
parseNumber = do
    g  <- parseOr [parseValue (parseChar '-') (-1), return 1]
    ns <- parseTryWhile $ parseExpect isDigit
    case ns of
        '0' : _ : _ -> parseError
        _           -> return ()
    n <- (parseUnTry . return . readMay) ns
    return $ ratio (n * g) 1

parseEof :: Parser ()
parseEof = StateT parseEof'
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
        op <- parseTry $ parseOr
            [parseValue (parseChar '*') (*), parseValue (parseChar '/') (/)]
        case op of
            Just op -> do
                y <- parseFactor
                parseTerm' $ x `op` y
            Nothing -> return x


parseExpr :: Parser Ratio
parseExpr = do
    x <- parseTerm
    parseExpr' x
  where
    parseExpr' x = do
        op <- parseTry $ parseOr
            [parseValue (parseChar '+') (+), parseValue (parseChar '-') (-)]
        case op of
            Just op -> do
                y <- parseTerm
                parseExpr' $ x `op` y
            Nothing -> return x


parseCalc :: Parser Ratio
parseCalc = do
    x <- parseExpr
    parseEof
    return x
