module Objecthash.Value exposing (Value(..), bool, dict, float, int, list, null, string, toJsonValue, toString)

{-| Value operations.

@docs Value

@docs toString, toJsonValue

@docs null, list, int, float, string, dict, bool

-}

import Dict exposing (Dict)
import Json.Encode as Json


{-| Objecthash Value.
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


{-| -}
toString : Value -> String
toString value =
    case value of
        VBool bool ->
            Basics.toString bool

        VDict dict ->
            dict
                |> Dict.toList
                |> List.map (\( key, value ) -> ( key, toString value ))
                |> Basics.toString

        VFloat float ->
            Basics.toString float

        VInteger int ->
            Basics.toString int

        VList list ->
            Basics.toString (List.map toString list)

        VNull ->
            ""

        VSet set ->
            Basics.toString (List.map toString set)

        VString string ->
            string


{-| -}
toJsonValue : Value -> Json.Value
toJsonValue value =
    case value of
        VBool bool ->
            Json.bool bool

        VDict dict ->
            dict
                |> Dict.toList
                |> List.map (\( key, value ) -> ( key, toJsonValue value ))
                |> Json.object

        VFloat float ->
            Json.float float

        VInteger int ->
            Json.int int

        VList list ->
            Json.list (List.map toJsonValue list)

        VNull ->
            Json.null

        VSet set ->
            Json.list (List.map toJsonValue set)

        VString string ->
            Json.string string


{-| -}
bool : Bool -> Value
bool value =
    VBool value


{-| -}
dict : Dict String Value -> Value
dict value =
    VDict value


{-| -}
float : Float -> Value
float value =
    VFloat value


{-| -}
int : Int -> Value
int value =
    VInteger value


{-| -}
list : List Value -> Value
list value =
    VList value


{-| -}
null : Value
null =
    VNull


{-| -}
set : List Value -> Value
set value =
    VSet value


{-| -}
string : String -> Value
string value =
    VString value
