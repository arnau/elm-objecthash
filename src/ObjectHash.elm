module Objecthash exposing (objecthash)

{-| Objecthash implementation.

Based on the implementation from Ben Laurie <https://github.com/benlaurie/objecthash>

@docs objecthash

-}

import Objecthash.Hash exposing (bytes, toHex)
import Objecthash.Json as Json
import Objecthash.Value exposing (Value(..))


{-| -}
objecthash : Value -> String
objecthash value =
    (toHex << bytes) value
