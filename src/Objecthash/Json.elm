module Objecthash.Json exposing
    ( decode, decodeWith
    , dict, list, bool, float, int, null, set, string
    )

{-| Helper functions to transform JSON to the Objecthash values.

@docs decode, decodeWith


# Decoders

@docs dict, list, bool, float, int, null, set, string

-}

import Json.Decode as Decode exposing (Decoder, decodeString)
import Objecthash.Value exposing (Value(..))


{-| Expects a JSON string and returns the result of attempting to decode it
into an AST of `Objecthash.Value`.
-}
decode : String -> Result Decode.Error Value
decode input =
    decodeString decoder input


{-| Decodes a JSON string with the given decoder.
-}
decodeWith : Decoder Value -> String -> Result Decode.Error Value
decodeWith decoder_ input =
    decodeString decoder_ input


{-| Default decoder. Common JSON.

TODO: Handle raw values (e.g. `VRaw`)

-}
decoder : Decoder Value
decoder =
    Decode.oneOf
        [ Decode.lazy (\() -> dict)
        , Decode.lazy (\() -> list)
        , bool
        , null
        , string

        -- , int
        , float
        ]


{-| TODO: Parametrise internal decoder
-}
dict : Decoder Value
dict =
    Decode.lazy (\() -> decoder)
        |> Decode.dict
        |> Decode.map VDict


{-| TODO: Parametrise internal decoder
-}
list : Decoder Value
list =
    Decode.lazy (\() -> decoder)
        |> Decode.list
        |> Decode.map VList


{-| TODO: Parametrise internal decoder
-}
set : Decoder Value
set =
    Decode.lazy (\() -> decoder)
        |> Decode.list
        |> Decode.map collectSet


collectSet : List Value -> Value
collectSet xs =
    VSet
        (xs
            |> List.foldr
                (\x xs_ ->
                    if List.member x xs_ then
                        xs_

                    else
                        x :: xs_
                )
                []
        )


{-| -}
string : Decoder Value
string =
    Decode.map VString Decode.string


{-| -}
float : Decoder Value
float =
    Decode.map VFloat Decode.float


{-| -}
int : Decoder Value
int =
    Decode.map VInteger Decode.int


{-| -}
bool : Decoder Value
bool =
    Decode.map VBool Decode.bool


{-| -}
null : Decoder Value
null =
    Decode.null VNull
