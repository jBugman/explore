module Main where
import System.Environment
import Process

main :: IO ()
main = do
    args <- getArgs
    case args of
        field:folder:_ -> process field folder
        _              -> error "Args are: <field name> <folder>"

-- -- Benchmark
-- main :: IO ()
-- main = main' 100 where
--   main' :: Integer -> IO ()
--   main' 0 = return ()
--   main' n = do
--     process "Name" "../test_data"
--     main' (n - 1)
