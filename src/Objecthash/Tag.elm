module Objecthash.Tag exposing
    ( Tag(..)
    , toChar, toByte
    )

{-| Functions to operate Tags.


# Types

@docs Tag


# Transformers

@docs toChar, toByte

-}

import Char exposing (fromCode)


{-| -}
type Tag
    = Bool
    | Dict
    | Float
    | Integer
    | List
    | Null
    | Set
    | Unicode
    | Raw
    | Custom Int


{-| -}
toChar : Tag -> Char
toChar tag =
    fromCode (toByte tag)


{-| -}
toByte : Tag -> Int
toByte tag =
    case tag of
        Bool ->
            0x62

        Dict ->
            0x64

        Float ->
            0x66

        Integer ->
            0x69

        List ->
            0x6C

        Null ->
            0x6E

        Set ->
            0x73

        Unicode ->
            0x75

        Raw ->
            0x72

        Custom int ->
            int
