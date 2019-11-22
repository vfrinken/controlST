module Data.Fuel

||| Fuel for running total operations potentially indefinitely.
public export
data Fuel = Dry | More (Lazy Fuel)

||| Provide `n` units of fuel.
export
limit : Nat -> Fuel
limit Z = Dry
limit (S n) = More (limit n)

||| Provide fuel indefinitely.
||| This function is fundamentally partial.
export partial
forever : Fuel
forever = More forever
