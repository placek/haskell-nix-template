module Main where

import qualified FooBar (fooBar)

main :: IO ()
main = do
  putStrLn "Hello, Haskell!"
  putStrLn FooBar.fooBar
