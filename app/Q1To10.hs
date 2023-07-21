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
-- myButLast :: [a] -> a
-- myButLast = last . init

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
