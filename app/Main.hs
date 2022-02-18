module Main where

import qualified FooBar (fooBar)

main :: IO ()
main = do
  putStrLn $ FooBar.fooBar "Haskell"
