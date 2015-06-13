module Main where
import System.Environment
import Process

main :: IO ()
main = do
    args <- getArgs
    case args of
        field:folder:_ -> process field folder
        _ -> error "Args are: <field name> <folder>"
