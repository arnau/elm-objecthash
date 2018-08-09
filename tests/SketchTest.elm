module SketchTest exposing (..)

import Crypto.Hash as Hash
import Dict exposing (Dict)
import Expect exposing (Expectation)
import Objecthash.Hash exposing (..)
import Test exposing (..)
import Word.Hex as Hex


suite : Test
suite =
    describe "Hash"
        [ test "id" <| \() -> testId
        , test "id pair" <| \() -> testIdPair
        , test "official" <| \() -> testOfficial
        , test "official pair" <| \() -> testOfficialPair
        , test "name" <| \() -> testName
        , test "name pair" <| \() -> testNamePair
        , test "citizen" <| \() -> testCitizen
        , test "citizen pair" <| \() -> testCitizenPair
        , test "item" <| \() -> testItem
        , test "entry" <| \() -> testEntry
        ]


item : Dict String (List Int)
item =
    Dict.fromList
        [ ( "id", unicode "GB" )
        , ( "official-name", unicode "The United Kingdom of Great Britain and Northern Ireland" )
        , ( "name", unicode "United Kingdom" )
        , ( "citizen-names", set [ unicode "Briton", unicode "British citizen" ] )
        ]


get : String -> Dict String (List Int) -> List Int
get key dict =
    Dict.get key dict |> Maybe.withDefault []


getPair : String -> Dict String (List Int) -> List Int
getPair key dict =
    pair ( key, get key dict )


testId : Expectation
testId =
    Expect.equal
        (toHex <| get "id" item)
        "fff7021c7df4426be0f9a3c83f236eb6f85d159e624b010d65e6dde267889c21"


testIdPair : Expectation
testIdPair =
    Expect.equal
        (toHex <| getPair "id" item)
        "17b788a70eeccbdc2fcb2d2d3db216c02fa88ac668beeb164bb2328c864bf3f4fff7021c7df4426be0f9a3c83f236eb6f85d159e624b010d65e6dde267889c21"


testOfficial : Expectation
testOfficial =
    Expect.equal
        (toHex <| get "official-name" item)
        "bf1860175c77869938cf9f4b37edb00f2f387be7b361f9c2c4a2ac202c1ba2e5"


testOfficialPair : Expectation
testOfficialPair =
    Expect.equal
        (toHex <| getPair "official-name" item)
        "cf09bea8c0107bd2150b073150d48db0a5b24c83defc7960ed698378d9f84b93bf1860175c77869938cf9f4b37edb00f2f387be7b361f9c2c4a2ac202c1ba2e5"


testName : Expectation
testName =
    Expect.equal
        (toHex <| get "name" item)
        "94099b1e0b9a1e673bafee513080197fa1980895ca27e091fdd4c54fab2bed24"


testNamePair : Expectation
testNamePair =
    Expect.equal
        (toHex <| getPair "name" item)
        "5c0be87ed7434d69005f8bbd84cad8ae6abfd49121b4aaeeb4c1f4a2e298771194099b1e0b9a1e673bafee513080197fa1980895ca27e091fdd4c54fab2bed24"


testCitizen : Expectation
testCitizen =
    Expect.equal
        (toHex <| get "citizen-names" item)
        "16897987a6ee59d9ffdb456ed02df34a79b05346498d4360172568101ae157c1"


testCitizenPair : Expectation
testCitizenPair =
    Expect.equal
        (toHex <| getPair "citizen-names" item)
        "bb3a7ac86d4f90c20d099992de0bd09bf3c4f27169c2cd873836762b01d5a2be16897987a6ee59d9ffdb456ed02df34a79b05346498d4360172568101ae157c1"


testItem : Expectation
testItem =
    Expect.equal
        (toHex <| dict item)
        "45d9392ad17cead3fa46501eba3e5ac237cb46a39f1e175905f00ef6a6667257"



-- Entry


timestamp : String -> ByteList
timestamp input =
    input
        |> String.cons 't'
        |> Hash.sha256
        |> Hex.toByteList


entry =
    Dict.fromList
        [ ( "number", int 6 )
        , ( "timestamp", timestamp "2016-04-05T13:23:05Z" )
        , ( "key", unicode "GB" )
        , ( "item-hash"
          , set
                [ raw
                    "6b18693874513ba13da54d61aafa7cad0c8f5573f3431d6f1c04b07ddb27d6bb"
                ]
          )
        ]


testEntry : Expectation
testEntry =
    let
        number =
            get "number" entry

        timestamp =
            get "timestamp" entry

        key =
            get "key" entry

        itemHash =
            get "item-hash" entry
    in
    Expect.equal
        [ toHex <| list [ number, key, timestamp, itemHash ]
        , toHex <| number
        , toHex <| key
        , toHex <| timestamp
        , toHex <| itemHash
        ]
        [ "51a02cd5692c6a03ba78330cb68f8e26e976c5933af0aa8d779589a1e6264e4b"
        , "396ee89382efc154e95d7875976cce373a797fe93687ca8a27589116644c4bcd"
        , "fff7021c7df4426be0f9a3c83f236eb6f85d159e624b010d65e6dde267889c21"
        , "f22ecc4464f22c8fee624769189665a0afd7ef10a2775a000082c47cbd9f6419"
        , "cff910f74878650a3cceb54039bdb62707de9d20e80d4385127732a4e444bd57"
        ]
