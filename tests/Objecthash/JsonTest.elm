module Objecthash.JsonTest exposing (..)

import Dict
import Expect exposing (Expectation)
import Objecthash.Json exposing (..)
import Objecthash.Value exposing (Value(..))
import Test exposing (..)


suite : Test
suite =
    describe "Json decoder"
        [ test "null" <| \() -> testNull
        , test "bool" <| \() -> testBool
        , test "int" <| \() -> testInt
        , test "float" <| \() -> testFloat
        , test "string" <| \() -> testString
        , test "list" <| \() -> testList
        , test "set" <| \() -> testSet
        , test "dict" <| \() -> testDict
        ]


testNull : Expectation
testNull =
    Expect.equal (decodeWith null "null") (Ok VNull)


testBool : Expectation
testBool =
    Expect.equal
        [ decodeWith bool "true", decodeWith bool "false" ]
        [ Ok (VBool True), Ok (VBool False) ]


testInt : Expectation
testInt =
    Expect.equal
        [ decodeWith int "1"
        , decodeWith int "42"
        , decodeWith int "0"
        ]
        [ Ok (VInteger 1)
        , Ok (VInteger 42)
        , Ok (VInteger 0)
        ]


testFloat : Expectation
testFloat =
    Expect.equal
        [ decodeWith float "1.0"
        , decodeWith float "42.0"
        , decodeWith float "0.0"
        , decodeWith float "-0.0"
        ]
        [ Ok (VFloat 1.0)
        , Ok (VFloat 42.0)
        , Ok (VFloat 0.0)
        , Ok (VFloat 0.0)
        ]


testString : Expectation
testString =
    Expect.equal
        [ decodeWith string "\"foo\""
        , decodeWith string "\"42\""
        ]
        [ Ok (VString "foo")
        , Ok (VString "42")
        ]


testList : Expectation
testList =
    Expect.equal
        [ decodeWith list """["foo"]"""
        , decodeWith list """[42.0, "foo"]"""
        ]
        [ Ok (VList [ VString "foo" ])
        , Ok (VList [ VFloat 42.0, VString "foo" ])
        ]


testSet : Expectation
testSet =
    Expect.equal
        [ decodeWith set """["foo"]"""
        , decodeWith set """[42.0, "foo"]"""
        , decodeWith set """["foo", "foo"]"""
        ]
        [ Ok (VSet [ VString "foo" ])
        , Ok (VSet [ VFloat 42.0, VString "foo" ])
        , Ok (VSet [ VString "foo" ])
        ]


testDict : Expectation
testDict =
    Expect.equal
        [ decodeWith dict """{"foo": "bar"}"""
        , decodeWith dict """{"x": 42.0}"""
        ]
        [ Ok (VDict <| Dict.fromList [ ( "foo", VString "bar" ) ])
        , Ok (VDict <| Dict.fromList [ ( "x", VFloat 42.0 ) ])
        ]
