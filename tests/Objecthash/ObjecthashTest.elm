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
        ]



-- [ test "null" <| \() -> testNull
-- , test "boolean: true" <| \() -> testBoolTrue
-- , test "boolean: false" <| \() -> testBoolFalse
-- , describe "number"
--     [ test "0" <| \() -> testNumber0
--     , test "other" <| \() -> testNumbers
--     ]
-- , describe "string"
--     [ test "unicode" <| \() -> testUnicode ]
-- , describe "list"
--     [ test "empty" <| \() -> testEmptyList
--     , test "string" <| \() -> testStringLists
--     , test "number" <| \() -> testNumberLists
--     ]
-- , describe "dict"
--     [ test "empty" <| \() -> testEmptyDict
--     , test "string" <| \() -> testStringDict
--     , test "list" <| \() -> testListDict
--     , test "order" <| \() -> testDictOrder
--     ]
-- , describe "set"
--     [ test "basic" <| \() -> testSet ]
-- , test "mix" <| \() -> testMix
-- , test "item" <| \() -> testItem
-- , describe "redacted"
--     [ test "list" <| \() -> testRedactedList
--     -- , test "string" <| \() -> testRedacted
--     ]
-- ]


testNull : Expectation
testNull =
    Expect.equal (objecthash VNull) "1b16b1df538ba12dc3f97edbb85caa7050d46c148134290feba80f8236c83db9"



-- testBoolTrue : Expectation
-- testBoolTrue =
--     Expect.equal (objecthash (VBool True)) "7dc96f776c8423e57a2785489a3f9c43fb6e756876d6ad9a9cac4aa4e72ec193"
-- testBoolFalse : Expectation
-- testBoolFalse =
--     Expect.equal (objecthash (VBool False)) "c02c0b965e023abee808f2b548d8d5193a8b5229be6f3121a6f16e2d41a449b3"
-- testNumber0 : Expectation
-- testNumber0 =
--     Expect.equal (objecthash (VNumber 0)) "60101d8c9cb988411468e38909571f357daa67bff5a7b0a3f9ae295cd4aba33d"
-- testNumbers : Expectation
-- testNumbers =
--     Expect.equal
--         [ objecthash (VNumber -0.1)
--         , objecthash (VNumber 1.2345)
--         , objecthash (VNumber -10.1234)
--         ]
--         [ "55ab03db6fbb5e6de473a612d7e462ca8fd2387266080980e87f021a5c7bde9f"
--         , "844e08b1195a93563db4e5d4faa59759ba0e0397caf065f3b6bc0825499754e0"
--         , "59b49ae24998519925833e3ff56727e5d4868aba4ecf4c53653638ebff53c366"
--         ]
-- testUnicode : Expectation
-- testUnicode =
--     Expect.equal
--         [ objecthash (VString "ԱԲաբ")
--         , objecthash (VString "ϓ")
--         , objecthash (VString "foo")
--         ]
--         [ "2a2a4485a4e338d8df683971956b1090d2f5d33955a81ecaad1a75125f7a316c"
--         , "f72826713a01881404f34975447bd6edcb8de40b191dc57097ebf4f5417a554d"
--         , "a6a6e5e783c363cd95693ec189c2682315d956869397738679b56305f2095038"
--         ]
-- testEmptyList : Expectation
-- testEmptyList =
--     Expect.equal
--         (objecthash (VList []))
--         "acac86c0e609ca906f632b0e2dacccb2b77d22b0621f20ebece1a4835b93f6f0"
-- testStringLists : Expectation
-- testStringLists =
--     Expect.equal
--         [ objecthash (VList [ VString "foo" ])
--         , objecthash (VList [ VString "foo", VString "bar" ])
--         ]
--         [ "268bc27d4974d9d576222e4cdbb8f7c6bd6791894098645a19eeca9c102d0964"
--         , "32ae896c413cfdc79eec68be9139c86ded8b279238467c216cf2bec4d5f1e4a2"
--         ]
-- testNumberLists : Expectation
-- testNumberLists =
--     Expect.equal
--         [ objecthash (VList [ VNumber 123 ])
--         , objecthash (VList [ VNumber 1, VNumber 2, VNumber 3 ])
--         , objecthash (VList [ VNumber 123456789012345 ])
--         ]
--         [ "2e72db006266ed9cdaa353aa22b9213e8a3c69c838349437c06896b1b34cee36"
--         , "925d474ac71f6e8cb35dd951d123944f7cabc5cda9a043cf38cd638cc0158db0"
--         , "f446de5475e2f24c0a2b0cd87350927f0a2870d1bb9cbaa794e789806e4c0836"
--         ]
-- testEmptyDict : Expectation
-- testEmptyDict =
--     Expect.equal (objecthash (VDict Dict.empty)) "18ac3e7343f016890c510e93f935261169d9e3f565436429830faf0934f4f8e4"
-- testStringDict : Expectation
-- testStringDict =
--     let
--         dict =
--             Dict.fromList [ ( "foo", VString "bar" ) ]
--     in
--     Expect.equal (objecthash (VDict dict)) "7ef5237c3027d6c58100afadf37796b3d351025cf28038280147d42fdc53b960"
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
-- testRedacted : Expectation
-- testRedacted =
--     Expect.equal
--         (objecthash <|
--             VString "**REDACTED**96e2aab962831956c80b542f056454be411f870055d37805feb3007c855bd823"
--         )
--         ""
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
-- testSet : Expectation
-- testSet =
--     Expect.equal
--         (objecthash <| VSet [ VString "Briton", VString "British citizen" ])
--         "16897987a6ee59d9ffdb456ed02df34a79b05346498d4360172568101ae157c1"
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
