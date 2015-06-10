module Main where
import System.Environment
import System.FilePath.Glob
import Data.Aeson
import Data.ByteString.Lazy as BS (readFile, ByteString)
import Data.HashMap as M (lookup, Map)
-- import Data.ByteString.Lazy.UTF8 as BS (fromString, toString)


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

process' :: String -> FilePath -> IO ()
process' field filename = do
  contents <- BS.readFile filename
  -- let contents = BS.fromString "{\"test\": \"x\"}"
  let json = parseJson contents
  print $ getFieldValue json field

parseJson :: ByteString -> Object
parseJson src = case (decode src :: Maybe Object) of
  Just v -> v
  Nothing -> error "Malformed JSON"

getFieldValue :: M.Map String Value -> String -> String
getFieldValue json field =
  case (M.lookup field json :: Maybe Value) of
  -- case (json .: field :: Parser Maybe String) of
    Nothing -> error "Field is missing"
    Just f -> case fromJSON f of
      Error err -> error err
      Success x -> x :: String

    -- Just _ -> error "Field is not a string"
    -- Nothing -> error "Field is missing"
