module Objecthash.ObjecthashTest exposing (..)

import Dict
import Expect exposing (Expectation)
import Objecthash exposing (objecthash)
import Objecthash.Value exposing (Value(..))
import Test exposing (..)


suite : Test
suite =
    describe "Objecthash"
        [ test "null" <| \() -> testNull
        , test "dict of lists" <| \() -> testListDict
        , test "dict ordering" <| \() -> testDictOrder
        , test "mix" <| \() -> testMix
        , describe "redaction"
            [ test "redacted list" <| \() -> testRedactedList
            , test "redacted mix" <| \() -> testRedactedMix
            ]
        , describe "sets"
            [ test "set" <| \() -> testSet
            , test "complex set" <| \() -> testComplexSet
            , test "complex set repeated" <| \() -> testComplexSetRepeated
            ]
        ]


testNull : Expectation
testNull =
    Expect.equal (objecthash VNull) "1b16b1df538ba12dc3f97edbb85caa7050d46c148134290feba80f8236c83db9"


testListDict : Expectation
testListDict =
    let
        dict =
            Dict.fromList
                [ ( "foo", VList [ VString "bar", VString "baz" ] )
                , ( "qux", VList [ VString "norf" ] )
                ]
    in
    Expect.equal (objecthash (VDict dict)) "f1a9389f27558538a064f3cc250f8686a0cebb85f1cab7f4d4dcc416ceda3c92"


testDictOrder : Expectation
testDictOrder =
    let
        dict1 =
            Dict.fromList
                [ ( "k1", VString "v1" )
                , ( "k2", VString "v2" )
                , ( "k3", VString "v3" )
                ]

        dict2 =
            Dict.fromList
                [ ( "k2", VString "v2" )
                , ( "k1", VString "v1" )
                , ( "k3", VString "v3" )
                ]
    in
    Expect.equal (objecthash (VDict dict1)) (objecthash (VDict dict2))


testMix : Expectation
testMix =
    let
        raw =
            VList
                [ VString "foo"
                , VDict
                    (Dict.fromList
                        [ ( "bar"
                          , VList
                                [ VString "baz"
                                , VNull
                                , VFloat 1.0
                                , VFloat 1.5
                                , VFloat 0.0001
                                , VFloat 1000.0
                                , VFloat 2.0
                                , VFloat -23.1234
                                , VFloat 2.0
                                ]
                          )
                        ]
                    )
                ]
    in
    Expect.equal (objecthash raw) "783a423b094307bcb28d005bc2f026ff44204442ef3513585e7e73b66e3c2213"


testRedactedList : Expectation
testRedactedList =
    Expect.equal
        (objecthash <|
            VList
                [ VString "foo"
                , VString "**REDACTED**96e2aab962831956c80b542f056454be411f870055d37805feb3007c855bd823"
                ]
        )
        "783a423b094307bcb28d005bc2f026ff44204442ef3513585e7e73b66e3c2213"


testRedactedMix : Expectation
testRedactedMix =
    Expect.equal
        (objecthash <|
            VList
                [ VString "foo"
                , VDict <|
                    Dict.fromList
                        [ ( "bar"
                          , VList
                                [ VString "**REDACTED**82f70430fa7b78951b3c4634d228756a165634df977aa1fada051d6828e78f30"
                                , VNull
                                , VFloat 1.0
                                , VFloat 1.5
                                , VString "**REDACTED**1195afc7f0b70bb9d7960c3615668e072a1cbfbbb001f84871fd2e222a87be1d"
                                , VFloat 1000.0
                                , VFloat 2.0
                                , VFloat -23.1234
                                , VFloat 2.0
                                ]
                          )
                        ]
                ]
        )
        "783a423b094307bcb28d005bc2f026ff44204442ef3513585e7e73b66e3c2213"


testSet : Expectation
testSet =
    Expect.equal
        (objecthash <|
            VDict <|
                Dict.fromList
                    [ ( "thing1"
                      , VDict <|
                            Dict.fromList
                                [ ( "thing2"
                                  , VSet
                                        [ VInteger 1
                                        , VInteger 2
                                        , VString "s"
                                        ]
                                  )
                                ]
                      )
                    , ( "thing3", VFloat 1234.567 )
                    ]
        )
        "618cf0582d2e716a70e99c2f3079d74892fec335e3982eb926835967cb0c246c"


testComplexSet : Expectation
testComplexSet =
    Expect.equal
        (objecthash <|
            VSet
                [ VString "foo"
                , VFloat 23.6
                , VSet [ VSet [] ]
                , VSet [ VSet [ VInteger 1 ] ]
                ]
        )
        "3773b0a5283f91243a304d2bb0adb653564573bc5301aa8bb63156266ea5d398"


testComplexSetRepeated : Expectation
testComplexSetRepeated =
    Expect.equal
        (objecthash <|
            VSet
                [ VString "foo"
                , VFloat 23.6
                , VSet [ VSet [] ]
                , VSet [ VSet [ VInteger 1 ] ]
                , VSet [ VSet [] ]
                ]
        )
        "3773b0a5283f91243a304d2bb0adb653564573bc5301aa8bb63156266ea5d398"
