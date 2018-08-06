-- Copyright (c) 2017 Kevin Tonon <kevin@betweenconcepts.com>
--
-- Licensed under the MIT license <LICENSE or http://opensource.org/licenses/MIT>,
-- at your option. This file may not be copied, modified, or distributed except
-- according to those terms.
--
-- This file is a copy from https://github.com/ktonon/elm-crypto


module Crypto.SHA exposing (digest)

import Array exposing (Array)
import Crypto.SHA.Alg as Alg exposing (Alg(..))
import Crypto.SHA.Preprocess
import Crypto.SHA.Process
import Word exposing (Word)


digest : Alg -> List Int -> Array Word
digest alg =
    Crypto.SHA.Preprocess.preprocess alg
        >> Word.fromBytes (Alg.wordSize alg)
        >> Crypto.SHA.Process.chunks alg
