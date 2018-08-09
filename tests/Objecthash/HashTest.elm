module Objecthash.HashTest exposing (..)

import Dict
import Expect exposing (Expectation)
import Objecthash.Hash exposing (..)
import Test exposing (..)


suite : Test
suite =
    describe "Hash"
        [ test "null" <| \() -> testNull
        , test "raw" <| \() -> testRaw
        , describe "bool"
            [ test "true" <| \() -> testBoolTrue
            , test "false" <| \() -> testBoolFalse
            ]
        , describe "integer"
            [ test "0" <| \() -> testInteger0
            , test "42" <| \() -> testInteger42
            , test "dangerous" <| \() -> testIntDangerous
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
            , test "dangerous" <| \() -> testFloatDangerous
            , test "special" <| \() -> testFloatSpecialValues
            ]
        ]


testNull : Expectation
testNull =
    Expect.equal (toHex null) "1b16b1df538ba12dc3f97edbb85caa7050d46c148134290feba80f8236c83db9"


testRaw : Expectation
testRaw =
    Expect.equal
        (toHex <| raw "6b18693874513ba13da54d61aafa7cad0c8f5573f3431d6f1c04b07ddb27d6bb")
        "e318859db4d2acc89c0d503ddbcf8331625125a79018d19cf8f8d1336b7eb39e"



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


testIntDangerous : Expectation
testIntDangerous =
    Expect.equal
        [ toHex <| int 9007199254740992
        , toHex <| int (9007199254740992 + 1)
        ]
        [ "e9fadd567195d7d1f02ce276b4758f74419cf8e135386bf7d181c44b97239c08"
        , "e9fadd567195d7d1f02ce276b4758f74419cf8e135386bf7d181c44b97239c08"
        ]



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


testFloatDangerous : Expectation
testFloatDangerous =
    Expect.equal
        [ toHex <| float 9007199254740992
        , toHex <| float (9007199254740992 + 1)
        ]
        [ "9e7d7d02dacab24905c2dc23391bd61d4081a9d541dfafd2469c881cc6c748e4"
        , "9e7d7d02dacab24905c2dc23391bd61d4081a9d541dfafd2469c881cc6c748e4"
        ]


testFloatSpecialValues : Expectation
testFloatSpecialValues =
    Expect.equal
        [ toHex <| float (0 / 0) -- NaN
        , toHex <| float (1 / 0) -- Infinity
        , toHex <| float (-1 / 0) -- -Infinity
        ]
        [ "5d6c301a98d835732d459d7018a8d546872f7ba3c39a45ba481746d2c6d566d9"
        , "e0309b2362dc6aaf595338cd9e116761640f74927bcdc4f76e8e6433738f25c7"
        , "1167518d5554ba86d9b176af0a57f29d425bedaa9847c245cc397b37533228f7"
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
