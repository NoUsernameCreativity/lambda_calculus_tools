import LambdaTools

main :: IO ()
main = print (freeVars (Abs 'x' (App (Var 'x') (Var 'y'))))
