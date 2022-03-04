module Main (main) where

import FooBar (fooBar)
import Test.QuickCheck

prop_fooBar :: Property
prop_fooBar = property $ do
  x <- listOf1 (chooseAny :: Gen Char)
  return $ fooBar x === "Hello " ++ x

main :: IO ()
main = do
  quickCheck prop_fooBar
