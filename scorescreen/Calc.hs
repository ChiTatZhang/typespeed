module Calc where

import qualified Data.ByteString.Char8 as B
import           Data.List
import           Data.Time.Clock.POSIX
import           Math.Statistics

-- Calls words on all lines of a list
-- Used to create 2d array out of list of scores
wordsLines :: [B.ByteString] -> [[B.ByteString]]
wordsLines [] = []
wordsLines (x:xs) = (B.words x) : (wordsLines xs)


-- Converts list of list into a String for easy printing
unWordsLines :: [[B.ByteString]] -> String
unWordsLines [] = []
unWordsLines x = B.unpack $ B.unlines $ unworded x
    where unworded [] = []
          unworded (x':xs') = (B.unwords x') : (unworded xs')



-- Gets top 10 scores
top10 :: [[B.ByteString]] -> [[B.ByteString]]
top10 x = take 10 $ sortBy order x
    where order bs1 bs2
              | num1 < num2 = GT
              | num1 == num2 = EQ
              | otherwise = LT
              where num1 = read (B.unpack $ head bs1) :: Int
                    num2 = read (B.unpack $ head bs2) :: Int


-- Returns a list of Floats to pass to statistics functions
getScore :: [[B.ByteString]] -> [Float]
getScore [] = []
getScore (x:xs) = (read (B.unpack (x !! 0)) :: Float) : getScore xs


-- Generic function for filtering list of score entries by certain groups
filterGroup :: [String] -> [[B.ByteString]] -> [[B.ByteString]]
-- filterGroup gs [] = []
filterGroup gs bss = filter (elemGroup) bss
    where elemGroup bs = getUser bs `elem` gs


-- Returns the user as a B.Bytestring from single score entry
getUserBS :: [B.ByteString] -> B.ByteString
getUserBS [] = B.empty
getUserBS x = x !! 3


-- Returns the user as a String from single score entry
getUser :: [B.ByteString] -> String
getUser = B.unpack . getUserBS


-- Returns the 10 users who have played the most games, along with # of games played
top10Addicts :: [[B.ByteString]] -> [[B.ByteString]]
top10Addicts x = take 10 $ reverse $ sort $ count $ map getUserBS x
    

-- Counts the number of times an item appears in a list
instances :: (Eq a) => a -> [a] -> Int
instances _ [] = 0
instances x (y:ys)
    | x == y = 1 + instances x ys
    | otherwise = instances x ys
    

-- Returns a list tuples of each member of a list along with the number of times
-- it appears in that list, i.e. counts number of times each item appears in list
count :: [B.ByteString] -> [[B.ByteString]]
count [] = []
count (x:xs) = [(B.pack $ show totalNum), x] : count filtered_xs
    where filtered_xs = filter (/= x) xs
          totalNum = 1 + instances x xs


-- Returns the time that the score was recorded from a single entry
getTime :: [B.ByteString] -> Int
getTime [] = 0
getTime x = read (B.unpack (x !! 7)) :: Int


-- Returns the scores that were recorded within the given period
filterTime :: Int -> Int -> [[B.ByteString]] -> [[B.ByteString]]
filterTime _ _ [] = []
filterTime period current x = filter (group) x
    where group x' = getTime x' > (current - period)
