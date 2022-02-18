module Main (main) where

import FooBar (fooBar)
import Test.QuickCheck

prop_fooBar :: String -> Bool
prop_fooBar x = fooBar x == "Hello " ++ x

main :: IO ()
main = do
  quickCheck prop_fooBar
