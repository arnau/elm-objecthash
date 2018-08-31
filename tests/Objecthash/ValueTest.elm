module Objecthash.ValueTest exposing (suite, testNull)

import Dict
import Expect exposing (Expectation)
import Objecthash.Value as Value exposing (..)
import Test exposing (..)


suite : Test
suite =
    describe "Value"
        [ test "null" <| \() -> testNull

        -- , describe "toString"
        --     [ test "null" <| \() -> testNullToString
        --     ]
        ]


testNull : Expectation
testNull =
    Expect.equal null VNull



-- testNullToString : Expectation
-- testNullToString =
--     Expect.equal (Value.toString VNull) ""
