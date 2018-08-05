-- Copyright (c) 2017 Kevin Tonon <kevin@betweenconcepts.com>
--
-- Licensed under the MIT license <LICENSE or http://opensource.org/licenses/MIT>,
-- at your option. This file may not be copied, modified, or distributed except
-- according to those terms.
--
-- This file is a copy from https://github.com/ktonon/elm-crypto
-- It has been modified to avoid namespace collisions with the original
-- library.


module Crypton.SHA exposing (digest)

import Array exposing (Array)
import Crypton.SHA.Alg as Alg exposing (Alg(..))
import Crypton.SHA.Preprocess
import Crypton.SHA.Process
import Word exposing (Word)


digest : Alg -> List Int -> Array Word
digest alg =
    Crypton.SHA.Preprocess.preprocess alg
        >> Word.fromBytes (Alg.wordSize alg)
        >> Crypton.SHA.Process.chunks alg
