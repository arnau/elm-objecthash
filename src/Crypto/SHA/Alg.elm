-- Copyright (c) 2017 Kevin Tonon <kevin@betweenconcepts.com>
--
-- Licensed under the MIT license <LICENSE or http://opensource.org/licenses/MIT>,
-- at your option. This file may not be copied, modified, or distributed except
-- according to those terms.
--
-- This file is a copy from https://github.com/ktonon/elm-crypto


module Crypto.SHA.Alg exposing (Alg(..), wordSize)

import Word exposing (Size(..))


type Alg
    = SHA224
    | SHA256
    | SHA384
    | SHA512
    | SHA512_224
    | SHA512_256


wordSize : Alg -> Size
wordSize alg =
    case alg of
        SHA224 ->
            wordSize SHA256

        SHA256 ->
            Bit32

        SHA384 ->
            wordSize SHA512

        SHA512 ->
            Bit64

        SHA512_224 ->
            wordSize SHA512

        SHA512_256 ->
            wordSize SHA512
