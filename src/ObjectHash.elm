module Objecthash exposing (fromJson, objecthash)

{-| Objecthash implementation.

Based on the implementation from Ben Laurie <https://github.com/benlaurie/objecthash>

@docs objecthash, fromJson

-}

import Objecthash.Hash exposing (bytes, toHex)
import Objecthash.Json as Json
import Objecthash.Value exposing (Value(..))


{-| -}
objecthash : Value -> String
objecthash value =
    (toHex << bytes) value


{-| Common JSON
-}
fromJson : String -> Result String String
fromJson input =
    input
        |> Json.decode
        |> Result.map objecthash
