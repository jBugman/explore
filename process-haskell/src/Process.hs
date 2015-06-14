module Process (process) where
import Control.Exception (evaluate, throw)
import System.FilePath.Glob
import Data.Aeson (decode)
import Data.Aeson.Types
import Data.List (sortBy)
import Data.Ord (comparing)
import Data.Text (Text, pack, unpack)
import Data.ByteString.Lazy as B (ByteString, readFile)
import qualified Data.Map as M (Map, fromListWith, toList)

-- | Do actual processing
-- >>> process "Name" "../test_data/"
-- "ok"
process :: String -> String -> IO ()
process field folder = do
    files <- globDir1 (compile "*.json") folder
    values <- mapM (processFile field) files
    let notEmpty = [x | x <- values, x /= ""]
    let result = sortedFrequencies notEmpty
    -- flip mapM_ result $ \(k, v) -> putStrLn (k ++ " " ++ show v)
    print "ok"

sortedFrequencies :: [String] -> [(String, Int)]
sortedFrequencies m = reverse $ sortBy (comparing snd) freq
  where freq = M.toList $ frequencies m

frequencies :: [String] -> M.Map String Int
frequencies items = M.fromListWith (+) (map (\i -> (i, 1)) items)

processFile :: String -> String -> IO String
processFile field filename = do
    contents <- B.readFile filename
    let json = parseJson contents
    let value = getFieldValue json field
    evaluate value

parseJson :: ByteString -> Object
parseJson src = case (decode src :: Maybe Object) of
    Just v  -> v
    Nothing -> error "Malformed JSON"

getFieldValue :: Object -> String -> String
getFieldValue json field =
    case parse f json of
        Error e          -> error "Field is not a string"
        Success Nothing  -> error "Field is missing"
        Success (Just x) -> unpack x
      where f obj = obj .:? pack field :: Parser (Maybe Text)
