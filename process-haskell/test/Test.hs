import Test.Hspec
import Process (process)

main = hspec $ do
    describe "process-haskell" $ do
      it "works" $ do
        -- (process "Name1" "../test-data") `shouldThrow` (anyErrorCall)
        (process "Name" "../test-data") `shouldReturn` ()
