module Objecthash.Value exposing
    ( Value(..)
    , toJsonValue
    , null, list, int, float, string, dict, bool
    )

{-| Value operations.

@docs Value

@docs toJsonValue

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



-- {-| -}
-- toString : Value -> String
-- toString value =
--     case value of
--         VBool inner ->
--             case inner of
--                 True ->
--                     "true"
--                 False ->
--                     "false"
--         VDict inner ->
--             inner
--                 |> Dict.toList
--                 |> List.map (\( key, val ) -> ( key, toString val ))
--                 |> Debug.toString
--         VFloat inner ->
--             String.fromFloat inner
--         VInteger inner ->
--             String.fromInt inner
--         VList inner ->
--             Debug.toString (List.map toString inner)
--         VNull ->
--             ""
--         VSet inner ->
--             Debug.toString (List.map toString inner)
--         VString inner ->
--             inner


{-| -}
toJsonValue : Value -> Json.Value
toJsonValue value =
    case value of
        VBool inner ->
            Json.bool inner

        VDict inner ->
            inner
                |> Dict.toList
                |> List.map (\( key, val ) -> ( key, toJsonValue val ))
                |> Json.object

        VFloat inner ->
            Json.float inner

        VInteger inner ->
            Json.int inner

        VList inner ->
            Json.list toJsonValue inner

        VNull ->
            Json.null

        VSet inner ->
            Json.list toJsonValue inner

        VString inner ->
            Json.string inner


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
