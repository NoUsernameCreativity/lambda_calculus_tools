-- | Utilities for working with lambda calculus terms: free-variable
-- calculation and single-step rightmost-innermost beta reduction.
module LambdaTools where

-- | To be run in GHCi or used in a 'main' program.
import qualified Data.Set as Set

-- | Lambda calculus terms: variables, abstractions (lambda) and applications.
data Term = Var Char | Abs Char Term | App Term Term

-- | Return the list of free variables in a 'Term'.
freeVars :: Term -> [Char]
freeVars term = Set.toList $ freeVarsSet term

-- | Return the set of free variables in a 'Term'.
freeVarsSet :: Term -> Set.Set Char
freeVarsSet (Var x) = Set.singleton x
freeVarsSet (Abs name exp) = Set.delete name (freeVarsSet exp)
freeVarsSet (App t1 t2) = Set.union (freeVarsSet t1) (freeVarsSet t2)

-- | Alpha-equivalence helpers (rename bound variables to avoid clashes).
-- (Not implemented in this module; placeholder for related utilities.)


-- | Perform a single rightmost-innermost beta-reduction step on a 'Term'.
-- This evaluates the outer expression once using rightmost-innermost strategy.
rightBetaReduction :: Term -> Term
rightBetaReduction (Var x) = Var x
rightBetaReduction (Abs name exp) = Abs name (rightBetaReduction exp) -- ^ continue finding innermost redex
rightBetaReduction (App left right) = case left of
    Var _ -> App left (rightBetaReduction right) -- ^ as var, move evaluation to rightmost
    Abs name exp
        | hasRedexes right -> App left (rightBetaReduction right)  -- ^ keep finding innermost redex
        | hasRedexes exp -> App (Abs name (rightBetaReduction exp)) right -- ^ keep finding innermost redex
        | otherwise -> betaReduceHelper name right exp -- ^ found the single rightmost redex; reduce it
    App _ _
        | hasRedexes right -> App left (rightBetaReduction right) -- ^ keep finding rightmost innermost redex
        | hasRedexes left -> App (rightBetaReduction left) right -- ^ keep finding rightmost innermost redex
        | otherwise -> App left right -- ^ found no redexes; return expression unchanged

-- | Substitute all free occurrences of a variable (given by 'Char') with a
-- replacement 'Term' inside an expression, avoiding substitution into
-- abstractions that shadow the variable.
--
-- Arguments: variable name to replace, replacement term, target expression.
betaReduceHelper :: Char -> Term -> Terms -> Term
betaReduceHelper term repl (Var x) = if x == term then repl else Var x
betaReduceHelper term repl (App left right) = App (betaReduceHelper term repl left) (betaReduceHelper term repl right)
betaReduceHelper term rep1 (Abs name exp) =
    if name == term then -- ^ inner shadowing: do not substitute under this binder
        Abs name exp
    else
        Abs name (betaReduceHelper term repl exp)

-- | Return 'True' if the given 'Term' contains any redex (reducible expression).
hasRedexes :: Term -> Bool
hasRedexes (Var x) = False
hasRedexes (Abs name exp) = hasRedexes exp
hasRedexes (App left right) = case left of
    Var x -> hasRedexes right
    Abs name exp -> True
    App a b -> hasRedexes (App a b) || hasRedexes right
