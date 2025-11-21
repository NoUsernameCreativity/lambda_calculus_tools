module LambdaTools where

-- to be run in ghci or used in main.
import qualified Data.Set as Set

data Term = Var Char | Abs Char Term | App Term Term

-- Returns a tuple of the free and bound chars of a lambda calc expression
freeVars :: Term -> [Char]
freeVars term = Set.toList $ freeVarsSet term

freeVarsSet :: Term -> Set.Set Char
freeVarsSet (Var x) = Set.singleton x
freeVarsSet (Abs name exp) = Set.delete name (freeVarsSet exp)
freeVarsSet (App t1 t2) = Set.union (freeVarsSet t1) (freeVarsSet t2)




