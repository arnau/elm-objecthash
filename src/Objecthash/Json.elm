module Objecthash.Json
    exposing
        ( bool
        , decode
        , decodeWith
        , dict
        , float
        , int
        , list
        , null
        , set
        , string
        )

{-| Helper functions to transform JSON to the Objecthash AST.

Based on the implementation from Ben Laurie <https://github.com/benlaurie/objecthash>

@docs decode, decodeWith


# Decoders

@docs dict, list, bool, float, int, null, set, string

-}

import Json.Decode as Decode exposing (Decoder, decodeString)
import Objecthash.Value exposing (Value(..))


{-| Expects a JSON string and returns the result of attempting to decode it
into an AST of `Objecthash.Value`.
-}
decode : String -> Result String Value
decode input =
    decodeString decoder input


decodeWith : Decoder Value -> String -> Result String Value
decodeWith decoder input =
    decodeString decoder input


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
                (\x xs ->
                    if List.member x xs then
                        xs
                    else
                        x :: xs
                )
                []
        )


string : Decoder Value
string =
    Decode.map VString Decode.string


float : Decoder Value
float =
    Decode.map VFloat Decode.float


{-| TODO: Handle "1.0" as float
-}
int : Decoder Value
int =
    Decode.map VInteger Decode.int


bool : Decoder Value
bool =
    Decode.map VBool Decode.bool


null : Decoder Value
null =
    Decode.null VNull
