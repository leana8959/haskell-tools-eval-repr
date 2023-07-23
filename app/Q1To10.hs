module Q1To10 where

-- 1
-- Read as: "head of the reverse"
myLast :: [a] -> a
myLast = head . reverse

-- -- Using foldr and id function
-- -- Keeps the last element, discarding the rest of the list.
-- --
-- -- foldr1 throws an error when there's no element in the list:
-- -- "A variant of  `foldr` that has no base case,
-- -- and thus may only be applied to non-empty structures."
-- myLast :: [a] -> a
-- myLast = foldr1 (const id)

-- -- Recursive solution
-- -- Note the syntax to throw an error
-- myLast :: [a] -> a
-- myLast [] = error "No end for empty lists!"
-- myLast [x] = x
-- myLast (_ : xs) = myLast xs

-- -- `curry` and `snd`
-- --
-- -- `curry` "makes a uncurried function curried":
-- -- (a, b) -> c will become a -> b -> c
-- --
-- -- `snd` takes the second element of a pair.
-- -- This is the equivalent of taking the second argument of a function.
-- myLast :: [a] -> a
-- myLast = foldl1 (curry snd)

-- 2
myButLast :: [a] -> a
myButLast = last . init

-- -- Generic type constraint:
-- -- Since `fold` takes anything that's `Foldable`, we could use a generic type constraint
-- -- to gain more flexibility over `[]`.
-- -- `f` here is not a function, it is a type parameter of the container's concret type
-- --
-- -- This solution shifts the content of the accumulator (in this case, the tuple) to the left.
-- --
-- myButLast :: (Foldable f) => f a -> a
-- myButLast = fst . foldl (\(_, b) x -> (b, x)) (err1, err2)
--   where
--     err1 = error "Empty list"
--     err2 = error "Singleton"

-- Safe version (Maybe monad)
-- Put Nothing in the accumulator first.
-- Essentially the same comparing to the method above, but doesn't throw an error.
myButLastSafe :: (Foldable f) => f a -> Maybe a
myButLastSafe = fst . foldl (\(_, b) x -> (b, Just x)) (Nothing, Nothing)

-- 3
-- NOTE: use 1-based index
--
-- Haskell uses `Int` to index linked lists
-- https://stackoverflow.com/questions/12432154/int-vs-word-in-common-use#comment16715337_12432154
-- elementAt :: [a] -> Int -> a
-- elementAt xs i = xs !! (i - 1)

-- -- Recursive solution
-- elementAt :: [a] -> Int -> a
-- elementAt (x : xs) k
--   | k == 1 = x
--   | k < 1 = error "Index out of bounds"
--   | otherwise = elementAt xs (k - 1)
-- elementAt _ _ = error "Index out of bounds"

-- -- `zip`
-- -- `zip` truncates the longer list
-- elementAt :: [a] -> Int -> a
-- elementAt xs n
--   | length xs < n = error "Index out of bounds"
--   | otherwise = fst . last $ zip xs [1 .. n]

-- Partial application of the composition function:
-- Only supplying the first argument of the composition function,
-- and then compose the partial composed function to the rest.
elementAt :: [a] -> Int -> a
elementAt = (last .) . flip take

-- -- "blackbird operator"
-- -- https://drewboardman.github.io/jekyll/update/2020/01/14/blackbird-operator.html
-- -- VERY terse syntax. Learn it but don't use it.
-- (.:) :: (c -> d) -> (a -> b -> c) -> a -> b -> d
-- (.:) = (.) . (.)
--
-- elementAt :: [a] -> Int -> a
-- elementAt = last .: flip take

-- 4
-- Recursive
-- myLength :: [a] -> Int
-- myLength [] = 0
-- myLength (x : xs) = 1 + myLength xs

-- -- `fold` with the accumulator a counter `c`
-- myLength :: [a] -> Int
-- myLength = foldl (\c _ -> c + 1) 0

-- Using partial application, consume the first argument (accumulator) and increment it,
-- and then consume the second one without doing (element of the list).
-- This is a pointless notation, i.e. has no explicit parameter.
myLength :: [a] -> Int
myLength = foldl (const . (+ 1)) 0

-- -- Interesting solution
-- -- Map all content to 1 and sum the list
-- myLength :: [a] -> Int
-- myLength = sum . map (const 1)

-- -- 5
-- -- More efficient as it pushes to the front of the list
-- myReverse :: [a] -> [a]
-- myReverse = foldl (flip (:)) []

-- Recursive method
-- We can only match on the left side of the list
-- which means we can only construct the list from the right (reversed).
-- This is less efficient because Haskell's lists are linked lists.
myReverse :: [a] -> [a]
myReverse [] = []
myReverse (x : xs) = myReverse xs ++ [x]

-- 6
-- -- A palindrome is equal to the reverse of itself.
-- isPalindrome :: (Eq a) => [a] -> Bool
-- isPalindrome xs = xs == reverse xs

-- -- Using >>=
-- -- `>>=` has (is) an instance `Monad ((->) r)`
-- -- It has a type signature: `(>>=) :: (r -> a) -> (a -> r -> b) -> r -> b`
-- --
-- -- `>>=` is infix 1: `reverse` is (r -> a). `==` is (a -> r -> b).
-- -- With `a == b`.
-- --
-- -- `a` in the type signatrue is never truely aquired.
-- isPalindrome :: (Eq a) => [a] -> Bool
-- isPalindrome = reverse >>= (==)

-- -- 7
-- NOTE: We have to define a new data type, because lists in Haskell are homogeneous.
data NestedList a = Elem a | List [NestedList a]

--
-- flatten :: NestedList a -> [a]
-- flatten (Elem x) = [x]
-- flatten (List []) = []
-- flatten (List (x : xs)) = flatten x ++ flatten (List xs)

-- -- `concatMap`
-- -- `map` all elements of xs with the function flatten, and then concat all of the results
-- flatten :: NestedList a -> [a]
-- flatten (Elem x) = [x]
-- flatten (List xs) = concatMap flatten xs

-- `>>=`
-- `>>=` applies the function on the rhs to the monoid on the lhs.
-- flatten :: NestedList a -> [a]
-- flatten (Elem x) = return x
-- flatten (List xs) = xs >>= flatten

-- Map each element of the structure into a monoid, and combine the results with  `( <> )`.
-- This fold is right-associative (i.e. `foldr`) and lazy in the accumulator.
flatten :: NestedList a -> [a]
flatten (Elem x) = [x]
flatten (List xs) = foldMap flatten xs
