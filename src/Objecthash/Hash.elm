module Objecthash.Hash
    exposing
        ( ByteList
        , bool
        , bytes
        , dict
        , float
        , int
        , list
        , null
        , pair
        , raw
        , redacted
        , set
        , toHex
        , unicode
        )

{-| Functions to hash values.


# Types

@docs ByteList


# Convert from and to lists of bytes.

@docs bytes, toHex


# Primitives

@docs unicode, redacted, null, int, float, bool, raw, pair


# Collection primitives

@docs list, set, dict

-}

import Crypto.SHA as SHA
import Crypto.SHA.Alg exposing (Alg(..))
import Dict exposing (Dict)
import Objecthash.Tag as Tag exposing (Tag)
import Objecthash.Value exposing (Value(..))
import Word.Bytes
import Word.Hex as Hex


{-| A list of bytes.
-}
type alias ByteList =
    List Int


sha256 : List Int -> String
sha256 bytes =
    bytes
        |> SHA.digest SHA256
        |> Hex.fromWordArray


{-| Transform a list of bytes into its hexadecimal string representation.

    (toHex [27,22,177,223,83,139,161,45,195,249,126,219,184,92,170,112,80,212,108,20,129,52,41,15,235,168,15,130,54,200,61,185]) == "1b16b1df538ba12dc3f97edbb85caa7050d46c148134290feba80f8236c83db9"

-}
toHex : ByteList -> String
toHex bytes =
    Hex.fromByteList bytes


{-| Hash an Objecthash Value.

    bytes VNull == [27,22,177,223,83,139,161,45,195,249,126,219,184,92,170,112,80,212,108,20,129,52,41,15,235,168,15,130,54,200,61,185]

-}
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



-- Primitives


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


{-| Hashes a raw hash.

    toHex (raw "7dc96f776c8423e57a2785489a3f9c43fb6e756876d6ad9a9cac4aa4e72ec193") == "72e68c48e6e01b3d898bf9d907938459cb80d6abec2078df7f19271ff9eb19e4"

-}
raw : String -> ByteList
raw input =
    Tag.toByte Tag.Raw
        :: Hex.toByteList input
        |> sha256
        |> Hex.toByteList


{-| Hashes a boolean.

    toHex (bool True) == "7dc96f776c8423e57a2785489a3f9c43fb6e756876d6ad9a9cac4aa4e72ec193"

-}
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


{-| Hashes a unicode string.

    toHex (unicode "foo") == "a6a6e5e783c363cd95693ec189c2682315d956869397738679b56305f2095038"

-}
unicode : String -> ByteList
unicode input =
    primitive Tag.Unicode input


{-| Hashes a redacted stringified list of bytes.

    toHex (redacted "**REDACTED**480499ec4efe0e177793c217c8227d4096d2352beee2d6816ba8f4e8a421a138") == "480499ec4efe0e177793c217c8227d4096d2352beee2d6816ba8f4e8a421a138"

-}
redacted : String -> ByteList
redacted input =
    input
        |> String.dropLeft 12
        |> Hex.toByteList


{-| Hashes a null value.

    toHex null == "1b16b1df538ba12dc3f97edbb85caa7050d46c148134290feba80f8236c83db9"

-}
null : ByteList
null =
    primitive Tag.Null ""


{-| Hashes an integer.

    toHex (int 6) == "396ee89382efc154e95d7875976cce373a797fe93687ca8a27589116644c4bcd"

-}
int : Int -> ByteList
int input =
    primitive Tag.Integer (toString input)


{-| Hashes a list of ByteList.

    [unicode "foo", int 6]
        |> list
        |> toHex
    == "28dbb78890fb7b0462c62de04bcf165c69bd65b9f992f2edd89ae7369afa7005"

-}
list : List ByteList -> ByteList
list input =
    bag Tag.List input


{-| Hashes a set of ByteList. Note that this function receives a `List` but
treats it as a Set (i.e. removes duplicates).

    [unicode "foo", int 6]
        |> set
        |> toHex
    == "cf38664185ed5377fee384d0a37bdb36681a16d72480f21336e38a493a8851b9"

-}
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


{-| Hahes a dictionary of ByteList.

    Dict.fromList [("foo", int 1)]
        |> dict
        |> toHex
    == "bf4c58f5e308e31e2cd64bdbf7a01b9b595a13602438be5e912c7d94f6d8177a"

-}
dict : Dict String ByteList -> ByteList
dict input =
    input
        |> Dict.toList
        |> List.map pair
        |> List.sort
        |> bag Tag.Dict


{-| -}
pair : ( String, ByteList ) -> ByteList
pair ( key, value ) =
    unicode key ++ value


{-| Hashes a float number. Note this function normalises values following the
same algorithm implemented in the original Objecthash implementation.

    toHex (float 6.1) == "43f5ebd1617989a69b819ed3a246c9e59468d6db90c29abdd3c8c1f17ffc365a"

-}
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
