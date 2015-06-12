module Main where
import System.Environment
import System.FilePath.Glob
import Data.Aeson
import Data.Aeson.Types
import Data.Text (pack, unpack, Text)
import Data.ByteString.Lazy as B (readFile, ByteString)
-- import Data.HashMap as M (lookup, Map)

main :: IO ()
main = do
    args <- getArgs
    case args of
        field:folder:_ -> process field folder
        _ -> error "Args are: <field name> <folder>"

process :: String -> String -> IO ()
process field folder = do
    -- putStrLn ("Processing field '" ++ field ++ "' in " ++ folder)
    files <- globDir1 (compile "*.json") folder
    mapM_ (process' field) files
  where
    process' field filename = do
        contents <- B.readFile filename
        let json = parseJson contents
        let value = getFieldValue json field
        putStrLn value

parseJson :: ByteString -> Object
parseJson src = case (decode src :: Maybe Object) of
    Just v -> v
    Nothing -> error "Malformed JSON"

getFieldValue :: Object -> String -> String
getFieldValue json field =
    case parse f json of
        Error e -> error "Field is not a string"
        Success Nothing -> error "Field is missing"
        Success (Just x) -> unpack x
      where f obj = obj .:? pack field :: Parser (Maybe Text)
