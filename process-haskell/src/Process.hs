module Process (process) where
import Control.Exception (evaluate)
import System.FilePath.Glob
import Data.Aeson (decode)
import Data.Aeson.Types
import Data.Csv as CSV (encode)
import Data.List (sortBy)
import Data.Maybe (fromMaybe)
import Data.Ord (comparing)
import Data.Text (Text, pack, unpack)
import Data.ByteString.Lazy as B (ByteString, readFile, writeFile)
import qualified Data.Map as M (Map, fromListWith, toList)

-- | Do actual processing
-- >>> process "Name" "../test_data/"
--
process :: String -> String -> IO ()
process field folder = do
    files <- globDir1 (compile "*.json") folder
    values <- mapM (processFile field) files
    let notEmpty = [x | x <- values, x /= ""]
    let result = sortedFrequencies notEmpty
    let csv = CSV.encode result
    B.writeFile "output.csv" csv

sortedFrequencies :: [String] -> [(String, Int)]
sortedFrequencies m = sortBy (flip (comparing snd)) freq
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
parseJson src = fromMaybe (error "Malformed JSON") (decode src :: Maybe Object)

getFieldValue :: Object -> String -> String
getFieldValue json field =
    case parse f json of
        Error _          -> error "Field is not a string"
        Success Nothing  -> error "Field is missing"
        Success (Just x) -> unpack x
      where f obj = obj .:? pack field :: Parser (Maybe Text)
