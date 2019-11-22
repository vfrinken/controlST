module Example

import Control.ST
import Data.Vect

increment : (x : Var) -> STrans m () [x ::: State Integer]
                                     (const [x ::: State Integer])
increment x = do num <- read x
                 write {ty=State Integer} x (num + 1)



makeAndIncrement : Integer -> STrans m Integer [] (const [])
makeAndIncrement init = do var <- new init
                           increment var
                           x <- read var
                           delete {st=Integer} var
                           pure x


addElement : (vec : Var) -> (item : a) ->
             STrans m () [vec ::: State (Vect n a)]
                  (const [vec ::: State (Vect (S n) a)])
addElement vec item = do xs <- read vec
                         write {ty=State (Vect n a)} vec (item :: xs)


readAndAdd : ConsoleIO io => (vec : Var) ->
             STrans io Bool [vec ::: State (Vect n Integer)]
                   (\res => [vec ::: State (if res then Vect (S n) Integer
                                                   else Vect n Integer)])
readAndAdd vec = do putStr "Enter a number: "
                    num <- getStr
                    if all isDigit (unpack num)
                       then do
                         update {ty=Vect n Integer} vec ((cast num) ::)
                         pure True     -- added an item, so return True
                       else pure False -- didn't add, so return False

{-
This next section doesn't work:

1. Have to bind `m` as an implicit in the defn of login, which we shouldn't have to do
2. Even if we do, get an error:

Example.idr:52:3--57:3:While processing right hand side of Example.login at Example.idr:52:3--57:3:
Can't solve constraint between:
	case result of { OK => LoggedIn ; BadPassword => LoggedOut }
and
	case result of { OK => LoggedIn ; BadPassword => LoggedOut }
-}

{-
data Access = LoggedOut | LoggedIn

data LoginResult = OK | BadPassword

interface DataStore (m : Type -> Type) where
  Store : Access -> Type

  connect : ST m Var [add (Store LoggedOut)]
  disconnect : (store : Var) -> ST m () [remove store (Store LoggedOut)]

  readSecret : (store : Var) -> ST m String [store ::: Store LoggedIn]
  login : {m : Type -> Type} -> (store : Var) ->
          ST m LoginResult [store ::: Store LoggedOut :->
                             (\res : LoginResult => Store (case res of
                                                             OK => LoggedIn
                                                             BadPassword => LoggedOut))]
  logout : (store : Var) -> ST m () [store ::: Store LoggedIn :-> Store LoggedOut]
-}
