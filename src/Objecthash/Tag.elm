module Objecthash.Tag exposing (..)


type Tag
    = Bool
    | Dict
    | Float
    | Integer
    | List
    | Null
    | Set
    | Unicode


toChar : Tag -> Char
toChar tag =
    case tag of
        Bool ->
            'b'

        Dict ->
            'd'

        Float ->
            'f'

        Integer ->
            'i'

        List ->
            'l'

        Null ->
            'n'

        Set ->
            's'

        Unicode ->
            'u'
