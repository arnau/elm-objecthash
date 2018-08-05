module Objecthash.Hash exposing (..)

{-| Functions to operate hashes.

@docs objecthash, bytes, toHex

@docs ByteList

@docs unicode, redacted, null, int

-}

import Crypto.Hash as Hash
import Crypton.SHA as SHA
import Crypton.SHA.Alg exposing (Alg(..))
import Objecthash.Tag as Tag exposing (Tag)
import Objecthash.Value exposing (Value(..))
import Word.Hex as Hex


{-| -}
type alias ByteList =
    List Int


sha256 : List Int -> String
sha256 bytes =
    bytes
        |> SHA.digest SHA256
        |> Hex.fromWordArray


{-| Hashes strings with the given tag
-}
primitive : Tag -> String -> ByteList
primitive tag input =
    input
        |> String.cons (Tag.toChar tag)
        |> Hash.sha256
        |> Hex.toByteList


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
    let
        tag =
            [ 108 ]

        -- Tag.toChar Tag.List |> String.fromChar |> Bytes.fromUTF8
    in
    (tag :: input)
        |> List.concat
        |> sha256
        |> Hex.toByteList


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

        VInteger raw ->
            int raw

        VList raw ->
            list (List.map bytes raw)

        VNull ->
            null

        VString raw ->
            if String.startsWith "**REDACTED**" raw then
                redacted raw
            else
                unicode raw

        _ ->
            null



--         VList xs ->
--             bytesList (Bytes.fromHex << objecthash) xs
--         VDict dict ->
--             bytesDict (Bytes.fromHex << objecthash) dict
--         VSet set ->
--             bytesSet (Bytes.fromHex << objecthash) set
-- bytesConcat : Bytes -> Bytes -> Bytes
-- bytesConcat a b =
--     Bytes.toList a
--         ++ Bytes.toList b
--         |> Bytes.fromList
--         |> Result.withDefault Bytes.empty
-- bytesString : String -> Bytes
-- bytesString s =
--     Bytes.fromUTF8 (String.cons 'u' s)
-- bytesRedacted : String -> Bytes
-- bytesRedacted s =
--     Bytes.fromHex (String.dropLeft 12 s)
-- bytesList : (a -> Bytes) -> List a -> Bytes
-- bytesList fn xs =
--     case xs of
--         [] ->
--             Bytes.fromUTF8 "l"
--         _ ->
--             let
--                 prefix =
--                     Bytes.fromUTF8 "l"
--                         |> Bytes.toList
--                 buffer =
--                     xs
--                         |> List.map (Bytes.toList << fn)
--                         |> List.concat
--             in
--             (prefix ++ buffer)
--                 |> Bytes.fromList
--                 |> Result.withDefault Bytes.empty
-- bytesSet : (a -> Bytes) -> List a -> Bytes
-- bytesSet fn xs =
--     case xs of
--         [] ->
--             Bytes.fromUTF8 "s"
--         _ ->
--             let
--                 prefix =
--                     Bytes.fromUTF8 "s"
--                         |> Bytes.toList
--                 buffer =
--                     xs
--                         |> List.map (Bytes.toList << fn)
--                         |> List.sort
--                         |> List.concat
--             in
--             (prefix ++ buffer)
--                 |> Bytes.fromList
--                 |> Result.withDefault Bytes.empty
-- bytesDict : (a -> Bytes) -> Dict String a -> Bytes
-- bytesDict fn dict =
--     let
--         prefix =
--             Bytes.fromUTF8 "d"
--                 |> Bytes.toList
--         buffer =
--             dict
--                 |> Dict.toList
--                 |> List.map
--                     (\( k, v ) ->
--                         Bytes.toList (Bytes.fromHex (hash (bytesString k)))
--                             ++ Bytes.toList (fn v)
--                     )
--                 |> List.sort
--                 |> List.concat
--     in
--     (prefix ++ buffer)
--         |> Bytes.fromList
--         |> Result.withDefault Bytes.empty
-- normaliseFloat : Float -> String
-- normaliseFloat n =
--     case n of
--         0 ->
--             "+0:"
--         _ ->
--             let
--                 ( f, e ) =
--                     ( abs n, 0 )
--                         |> exponent
--                         |> float
--                 ( _, s ) =
--                     mantissa ( f, sign n ++ Basics.toString e ++ ":" )
--             in
--             s
-- sign : Float -> String
-- sign f =
--     if f < 0 then
--         "-"
--     else
--         "+"
-- exponent : ( Float, Int ) -> ( Float, Int )
-- exponent ( f, e ) =
--     if f > 1 then
--         exponent ( f / 2, e + 1 )
--     else
--         ( f, e )
-- float : ( Float, Int ) -> ( Float, Int )
-- float ( f, e ) =
--     if f <= 0.5 then
--         float ( f * 2, e - 1 )
--     else
--         ( f, e )
-- {-| TODO: Handle errors
-- <https://github.com/benlaurie/objecthash/blob/master/go/objecthash/objecthash.go#L133>
-- -}
-- mantissa : ( Float, String ) -> ( Float, String )
-- mantissa ( f, s ) =
--     if String.length s >= 1000 then
--         ( 0, "ERROR" )
--     else if f /= 0 then
--         if f >= 1 then
--             mantissa ( (f - 1) * 2, s ++ "1" )
--         else
--             mantissa ( f * 2, s ++ "0" )
--     else
--         ( f, s )
