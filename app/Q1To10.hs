module Q1To10 where

-- Recursive method
-- We can only match on the left side of the list
-- which means we can only construct the list from the right (reversed).
-- This is less efficient because Haskell's lists are linked lists.
myReverse :: [a] -> [a]
myReverse [] = []
myReverse (x : xs) = myReverse xs ++ [x]

-- 8
-- >>> head [1,2,3]
compress :: (Eq a) => [a] -> [a]
compress [] = []
compress (x : xs) = x : compress (dropWhile (== x) xs)
