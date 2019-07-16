module ObjectHash exposing (objecthash, fromJson)

{-| Objecthash implementation.

Based on the implementation from Ben Laurie <https://github.com/benlaurie/objecthash>

@docs objecthash, fromJson

-}

import Json.Decode as Decode
import Objecthash.Hash exposing (bytes, toHex)
import Objecthash.Json as Json
import Objecthash.Value exposing (Value(..))


{-| Hash an `Objecthash.Value` and return it as a hexadecimal string
representation.

If you need more control over the hash, `Objecthash.Hash` offers a range of
functions to operate on elm values and lists of bytes.

-}
objecthash : Value -> String
objecthash value =
    (toHex << bytes) value


{-| Hash a Common JSON blob and return it as a hexadecimal string
representation.

If you need more control over the JSON decoder, check the `Objecthash.Json`
module.

-}
fromJson : String -> Result Decode.Error String
fromJson input =
    input
        |> Json.decode
        |> Result.map objecthash
