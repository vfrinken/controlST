module InterfaceExample

import Control.ST

data TinySMStates = StateA | StateB



interface TinySM (m:Type -> Type) where
    TinySMResource : TinySMStates -> Type
    TinySMResource2 : TinySMStates2 -> Type


    -- this one doesn't work even though it should
    --transAtoB  : ST m ()  [lblx ::: (TinySMResource StateA) -> (TinySMResource StateB)]

    -- literally just replacing the parts accoring to the defintion in Control.ST works
    transAtoB  : ST m () [Trans lblx (TinySMResource StateA) (const (TinySMResource StateB))]
