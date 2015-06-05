module Main where
import System.Environment

main :: IO ()
main = do
  args <- getArgs
  case args of
    field:folder:_ -> process field folder
    _ -> error "Args are: <field name> <folder>"


process :: String -> String -> IO ()
process field folder = do
  putStrLn ("Processing field '" ++ field ++ "' in " ++ folder)
