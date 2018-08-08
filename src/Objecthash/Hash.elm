module Objecthash.Hash exposing (..)

{-| Functions to operate hashes.


# Types

@docs ByteList


# Convertors

@docs bytes, toHex


# Primitives

@docs unicode, redacted, null, int, float, bool


# Collection primitives

@odcs list, set, dict

-}

import Crypto.SHA as SHA
import Crypto.SHA.Alg exposing (Alg(..))
import Dict exposing (Dict)
import Objecthash.Tag as Tag exposing (Tag)
import Objecthash.Value exposing (Value(..))
import Word.Bytes
import Word.Hex as Hex


{-| -}
type alias ByteList =
    List Int


sha256 : List Int -> String
sha256 bytes =
    bytes
        |> SHA.digest SHA256
        |> Hex.fromWordArray


{-| -}
toHex : ByteList -> String
toHex bytes =
    Hex.fromByteList bytes


{-| -}
bytes : Value -> ByteList
bytes value =
    case value of
        VBool raw ->
            bool raw

        VDict raw ->
            raw
                |> Dict.map (\k v -> bytes v)
                |> dict

        VFloat raw ->
            float raw

        VInteger raw ->
            int raw

        VList raw ->
            list (List.map bytes raw)

        VNull ->
            null

        VSet raw ->
            set (List.map bytes raw)

        VString raw ->
            if String.startsWith "**REDACTED**" raw then
                redacted raw
            else
                unicode raw



-- Helpers


{-| Hashes strings with the given tag
-}
primitive : Tag -> String -> ByteList
primitive tag input =
    input
        |> String.cons (Tag.toChar tag)
        |> Word.Bytes.fromUTF8
        |> sha256
        |> Hex.toByteList


{-| Hashes collections of bytes
-}
bag : Tag -> List ByteList -> ByteList
bag tag input =
    ([ Tag.toByte tag ] :: input)
        |> List.concat
        |> sha256
        |> Hex.toByteList


{-| -}
raw : String -> ByteList
raw input =
    Hex.toByteList input


{-| -}
bool : Bool -> ByteList
bool input =
    let
        input_ =
            case input of
                True ->
                    "1"

                False ->
                    "0"
    in
    primitive Tag.Bool input_


{-| -}
unicode : String -> ByteList
unicode input =
    primitive Tag.Unicode input


{-| -}
redacted : String -> ByteList
redacted input =
    input
        |> String.dropLeft 12
        |> Hex.toByteList


{-| -}
null : ByteList
null =
    primitive Tag.Null ""


{-| -}
int : Int -> ByteList
int input =
    primitive Tag.Integer (toString input)


{-| -}
list : List ByteList -> ByteList
list input =
    bag Tag.List input


{-| -}
set : List ByteList -> ByteList
set input =
    input
        |> List.foldr collectUnique []
        |> List.sort
        |> bag Tag.Set


collectUnique : ByteList -> List ByteList -> List ByteList
collectUnique bytes acc =
    if List.member bytes acc then
        acc
    else
        bytes :: acc


{-| -}
dict : Dict String ByteList -> ByteList
dict input =
    input
        |> Dict.toList
        |> List.map pair
        |> List.sort
        |> bag Tag.Dict


pair : ( String, ByteList ) -> ByteList
pair ( key, value ) =
    unicode key ++ value


{-| -}
float : Float -> ByteList
float input =
    if isNaN input || isInfinite input then
        primitive Tag.Float (toString input)
    else
        primitive Tag.Float (normaliseFloat input)


normaliseFloat : Float -> String
normaliseFloat n =
    case n of
        0 ->
            "+0:"

        _ ->
            let
                ( f, e ) =
                    ( abs n, 0 )
                        |> exponent
                        |> floatReduce

                ( _, s ) =
                    mantissa ( f, sign n ++ Basics.toString e ++ ":" )
            in
            s


sign : Float -> String
sign f =
    if f < 0 then
        "-"
    else
        "+"


exponent : ( Float, Int ) -> ( Float, Int )
exponent ( f, e ) =
    if f > 1 then
        exponent ( f / 2, e + 1 )
    else
        ( f, e )


floatReduce : ( Float, Int ) -> ( Float, Int )
floatReduce ( f, e ) =
    if f <= 0.5 then
        floatReduce ( f * 2, e - 1 )
    else
        ( f, e )


{-| TODO: Handle errors
<https://github.com/benlaurie/objecthash/blob/master/go/objecthash/objecthash.go#L133>
-}
mantissa : ( Float, String ) -> ( Float, String )
mantissa ( f, s ) =
    if String.length s >= 1000 then
        ( 0, "ERROR" )
    else if f /= 0 then
        if f >= 1 then
            mantissa ( (f - 1) * 2, s ++ "1" )
        else
            mantissa ( f * 2, s ++ "0" )
    else
        ( f, s )
