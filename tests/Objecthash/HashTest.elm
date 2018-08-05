module Objecthash.HashTest exposing (..)

import Dict
import Expect exposing (Expectation)
import Objecthash.Hash exposing (..)
import Test exposing (..)


suite : Test
suite =
    describe "Hash"
        [ test "null" <| \() -> testNull
        , describe "bool"
            [ test "true" <| \() -> testBoolTrue
            , test "false" <| \() -> testBoolFalse
            ]
        , describe "integer"
            [ test "0" <| \() -> testInteger0
            , test "42" <| \() -> testInteger42
            ]
        , describe "string"
            [ test "unicode" <| \() -> testUnicode ]
        , describe "redacted"
            [ test "string" <| \() -> testRedacted
            ]
        , describe "list"
            [ test "empty" <| \() -> testEmptyList
            , test "string" <| \() -> testStringLists
            ]
        , describe "set"
            [ test "empty" <| \() -> testEmptySet
            , test "mixed" <| \() -> testMixedSet
            ]
        , describe "dict"
            [ test "empty" <| \() -> testEmptyDict
            ]
        , describe "float"
            [ test "0.0" <| \() -> testFloat0
            , test "other" <| \() -> testFloats
            ]
        ]


testNull : Expectation
testNull =
    Expect.equal (toHex null) "1b16b1df538ba12dc3f97edbb85caa7050d46c148134290feba80f8236c83db9"



-- Unicode


testUnicode : Expectation
testUnicode =
    Expect.equal
        [ toHex (unicode "ԱԲաբ")
        , toHex (unicode "ϓ")
        , toHex (unicode "foo")
        ]
        [ "2a2a4485a4e338d8df683971956b1090d2f5d33955a81ecaad1a75125f7a316c"
        , "f72826713a01881404f34975447bd6edcb8de40b191dc57097ebf4f5417a554d"
        , "a6a6e5e783c363cd95693ec189c2682315d956869397738679b56305f2095038"
        ]



-- Redaction


testRedacted : Expectation
testRedacted =
    Expect.equal
        (toHex <| redacted "**REDACTED**96e2aab962831956c80b542f056454be411f870055d37805feb3007c855bd823")
        "96e2aab962831956c80b542f056454be411f870055d37805feb3007c855bd823"



-- Bool


testBoolTrue : Expectation
testBoolTrue =
    Expect.equal (toHex <| bool True) "7dc96f776c8423e57a2785489a3f9c43fb6e756876d6ad9a9cac4aa4e72ec193"


testBoolFalse : Expectation
testBoolFalse =
    Expect.equal (toHex <| bool False) "c02c0b965e023abee808f2b548d8d5193a8b5229be6f3121a6f16e2d41a449b3"



-- Integer


testInteger0 : Expectation
testInteger0 =
    Expect.equal (toHex (int 0)) "a4e167a76a05add8a8654c169b07b0447a916035aef602df103e8ae0fe2ff390"


testInteger42 : Expectation
testInteger42 =
    Expect.equal (toHex (int 42)) "ebc35dc1b8e2602b72beb8d8e5bcdb2babe90f57bcb54ad7282ec798659d2196"



-- Float


testFloat0 : Expectation
testFloat0 =
    Expect.equal
        [ toHex <| float 0.0
        , toHex <| float -0.0
        ]
        [ "60101d8c9cb988411468e38909571f357daa67bff5a7b0a3f9ae295cd4aba33d"
        , "60101d8c9cb988411468e38909571f357daa67bff5a7b0a3f9ae295cd4aba33d"
        ]


testFloats : Expectation
testFloats =
    Expect.equal
        [ toHex <| float -0.1
        , toHex <| float 1.2345
        , toHex <| float -10.1234
        ]
        [ "55ab03db6fbb5e6de473a612d7e462ca8fd2387266080980e87f021a5c7bde9f"
        , "844e08b1195a93563db4e5d4faa59759ba0e0397caf065f3b6bc0825499754e0"
        , "59b49ae24998519925833e3ff56727e5d4868aba4ecf4c53653638ebff53c366"
        ]



-- List


testEmptyList : Expectation
testEmptyList =
    Expect.equal
        (toHex <| list [])
        "acac86c0e609ca906f632b0e2dacccb2b77d22b0621f20ebece1a4835b93f6f0"


testStringLists : Expectation
testStringLists =
    Expect.equal
        [ toHex (list [ unicode "foo" ])
        , toHex (list [ unicode "foo", unicode "bar" ])
        ]
        [ "268bc27d4974d9d576222e4cdbb8f7c6bd6791894098645a19eeca9c102d0964"
        , "32ae896c413cfdc79eec68be9139c86ded8b279238467c216cf2bec4d5f1e4a2"
        ]



-- Set


testEmptySet : Expectation
testEmptySet =
    Expect.equal
        (toHex <| set [])
        "043a718774c572bd8a25adbeb1bfcd5c0256ae11cecf9f9c3f925d0e52beaf89"


testMixedSet : Expectation
testMixedSet =
    Expect.equal
        (toHex <| set [ int 1, int 2, unicode "foo" ])
        "7b0bde44f8fa6fb6e1f56f5290b1815766c16a06d70258dc3ad501b27f59741d"



-- Dict


testEmptyDict : Expectation
testEmptyDict =
    Expect.equal
        (toHex <| dict (Dict.fromList []))
        "18ac3e7343f016890c510e93f935261169d9e3f565436429830faf0934f4f8e4"


testStringDict : Expectation
testStringDict =
    Expect.equal
        (toHex <| dict (Dict.fromList [ ( "foo", unicode "bar" ) ]))
        "7ef5237c3027d6c58100afadf37796b3d351025cf28038280147d42fdc53b960"



-- testListDict : Expectation
-- testListDict =
--     let
--         dict =
--             Dict.fromList
--                 [ ( "foo", VList [ VString "bar", VString "baz" ] )
--                 , ( "qux", VList [ VString "norf" ] )
--                 ]
--     in
--     Expect.equal (objecthash (VDict dict)) "f1a9389f27558538a064f3cc250f8686a0cebb85f1cab7f4d4dcc416ceda3c92"
-- testDictOrder : Expectation
-- testDictOrder =
--     let
--         dict1 =
--             Dict.fromList
--                 [ ( "k1", VString "v1" )
--                 , ( "k2", VString "v2" )
--                 , ( "k3", VString "v3" )
--                 ]
--         dict2 =
--             Dict.fromList
--                 [ ( "k2", VString "v2" )
--                 , ( "k1", VString "v1" )
--                 , ( "k3", VString "v3" )
--                 ]
--     in
--     Expect.equal (objecthash (VDict dict1)) (objecthash (VDict dict2))
-- testMix : Expectation
-- testMix =
--     let
--         raw =
--             VList
--                 [ VString "foo"
--                 , VDict
--                     (Dict.fromList
--                         [ ( "bar"
--                           , VList
--                                 [ VString "baz"
--                                 , VUnknown
--                                 , VNumber 1.0
--                                 , VNumber 1.5
--                                 , VNumber 0.0001
--                                 , VNumber 1000.0
--                                 , VNumber
--                                     2.0
--                                 , VNumber -23.1234
--                                 , VNumber 2.0
--                                 ]
--                           )
--                         ]
--                     )
--                 ]
--     in
--     Expect.equal (objecthash raw) "783a423b094307bcb28d005bc2f026ff44204442ef3513585e7e73b66e3c2213"
-- testRedactedList : Expectation
-- testRedactedList =
--     Expect.equal
--         (objecthash <|
--             VList
--                 [ VString "foo"
--                 , VString "**REDACTED**96e2aab962831956c80b542f056454be411f870055d37805feb3007c855bd823"
--                 ]
--         )
--         "783a423b094307bcb28d005bc2f026ff44204442ef3513585e7e73b66e3c2213"
-- testRedactedMix : Expectation
-- testRedactedMix =
--     Expect.equal
--         (objecthash <|
--             VList
--                 [ VString "foo"
--                 , VDict <|
--                     Dict.fromList
--                         [ ( "bar"
--                           , VList
--                                 [ VString "**REDACTED**82f70430fa7b78951b3c4634d228756a165634df977aa1fada051d6828e78f30"
--                                 , VUnknown
--                                 , VNumber 1.0
--                                 , VNumber 1.5
--                                 , VString "**REDACTED**1195afc7f0b70bb9d7960c3615668e072a1cbfbbb001f84871fd2e222a87be1d"
--                                 , VNumber 1000.0
--                                 , VNumber 2.0
--                                 , VNumber -23.1234
--                                 , VNumber 2.0
--                                 ]
--                           )
--                         ]
--                 ]
--         )
--         "783a423b094307bcb28d005bc2f026ff44204442ef3513585e7e73b66e3c2213"
-- testItem : Expectation
-- testItem =
--     Expect.equal
--         (objecthash <|
--             VDict <|
--                 Dict.fromList
--                     [ ( "id", VString "GB" )
--                     , ( "official-name", VString "The United Kingdom of Great Britain and Northern Ireland" )
--                     , ( "name", VString "United Kingdom" )
--                     , ( "citizen-names", VSet [ VString "Briton", VString "British citizen" ] )
--                     ]
--         )
--         "45d9392ad17cead3fa46501eba3e5ac237cb46a39f1e175905f00ef6a6667257"
