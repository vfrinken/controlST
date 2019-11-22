module ErrorExample

public export
data STransLoop : (ty : Type) ->
                 rs -> (ty -> rs) -> Type where
    Pure : {out_fn: ty -> rs} -> (result : ty) -> STransLoop ty (out_fn result) out_fn

runSTLoop : STransLoop a invars out_fn -> a
runSTLoop (Pure {out_fn} result) = result


{-
Example error

While processing left hand side of Test.runSTLoop at Test.idr:14:1--15:1:
Can't solve constraint between:
	?out_fn ?k
and
	?_

-}
