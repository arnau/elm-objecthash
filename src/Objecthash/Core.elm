module Objecthash.Core exposing (..)

{-| Core types.

@docs Value

-}

import Dict exposing (Dict)


{-| Algebraic Value

Note that the original objecthash implementation(s) don't have the value type
`Timestamp`.

-}
type Value
    = VBool Bool
    | VDict (Dict String Value)
    | VFloat Float
    | VInteger Int
    | VList (List Value)
    | VNull
    | VSet (List Value)
    | VString String
