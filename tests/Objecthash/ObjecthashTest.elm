module Objecthash.ObjecthashTest exposing (..)

import Dict
import Expect exposing (Expectation)
import Objecthash exposing (objecthash)
import Objecthash.Hash exposing (..)
import Objecthash.Value exposing (Value(..))
import Test exposing (..)


suite : Test
suite =
    describe "Objecthash"
        [ test "null" <| \() -> testNull
        ]


testNull : Expectation
testNull =
    Expect.equal (objecthash VNull) "1b16b1df538ba12dc3f97edbb85caa7050d46c148134290feba80f8236c83db9"
