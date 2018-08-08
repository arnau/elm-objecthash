# Objecthash in Elm

Implementation of [Ben Laurie's
objecthash](https://github.com/benlaurie/objecthash) in Elm.

## Install

Not yet published as an Elm Package.

## Usage

There are a few interfaces available.

From JSON:

```elm
import Objecthash exposing (fromJson)

fromJson """{"k1":"v1","k2":"v2","k3":"v3"}"""
-- Ok "ddd65f1f7568269a30df7cafc26044537dc2f02a1a0d830da61762fc3e687057"
```

From `Objecthash.Value`:

```elm
import Objecthash exposing (objecthash)
import Objecthash.Value exposing (Value(..))

objecthash <| VSet [VInteger 1, VInteger 2]
-- "ee104c03e5465735a9fb3fa5d0f19199297a135486fa76930c69cec825f8dac8"
```

From `Objecthash.Hash`:

```elm
import Objecthash.Hash exposing (..)

toHex <| dict (Dict.fromList [ ( "foo", unicode "bar" ) ])
-- "7ef5237c3027d6c58100afadf37796b3d351025cf28038280147d42fdc53b960"
```


## Known issues

* JSON numbers are casted as integers when there is no remainder (e.g. `"42"`
  and `"42.0"` are `42 : Int`) when using `Json.decode`.


## Contribute

To run a clone of this project locally, you need
[Yarn](https://yarnpkg.com/) (and nodejs):

```sh
yarn install
```

To run the test suite:

```sh
yarn test
```

Note that the elm tooling is installed local to the project so as long as you
use commands via `yarn` you should be fine.


## License

Every file inside `src/Crypto` is a copy from
https://github.com/ktonon/elm-crypto and has the following copyright and
license: Copyright (c) 2017 Kevin Tonon <kevin@betweenconcepts.com> licensed
under MIT.


The rest has the following copyright and
license:

Copyright (c) 2018 elm-objecthash contributors licensed under [BSD-3-clause](LICENSE).
