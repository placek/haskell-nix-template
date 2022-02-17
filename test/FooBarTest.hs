module Main (main) where

import FooBar (fooBar)
import Test.QuickCheck

prop_reverse :: [Int] -> Bool
prop_reverse xs = reverse (reverse xs) == xs

main :: IO ()
main = do
  quickCheck (withMaxSuccess 10000 prop_reverse)
