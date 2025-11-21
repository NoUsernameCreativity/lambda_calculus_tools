-- doctest

import LambdaTools

-- Tests for finding free variables
-- >>> freeVars (Var 'x')
-- "x"
-- >>> freeVars (Abs 'x' (Var 'x'))
-- ""
-- >>> freeVars (Abs 'x' (Var 'y'))
-- "y"

-- Tests for Beta Reduction
-- >>> rightBetaReduction (App (Abs 'x' (Var 'x')) (Var 'y'))
-- Var 'y'
-- >>> rightBetaReduction (App (Abs 'x' (App (Var 'x') (Var 'x'))) (Var 'y'))
-- App (Var 'y') (Var 'y')
-- >>> rightBetaReduction (App (Abs 'x' (Abs 'y' (App (Var 'x') (Var 'y')))) (Var 'z'))
-- Abs 'y' (App (Var 'z') (Var 'y'))
-- >>> rightBetaReduction (App (Var 'x') (Var 'y'))
-- App (Var 'x') (Var 'y')

-- Both
-- >>> freeVars (rightBetaReduction (App (Abs 'x' (Var 'x')) (Var 'y')))
-- "y"
-- >>> freeVars (rightBetaReduction (Var 'x'))
-- "x"
-- >>> freeVars (rightBetaReduction (App (Abs 'x' (Abs 'y' (App (Var 'x') (Var 'y')))) (Var 'z')))
-- "z"
