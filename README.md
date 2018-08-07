# Objecthash in Elm

Implementation of [Ben Laurie's
objecthash](https://github.com/benlaurie/objecthash) in Elm.

## Install

Not yet published as an Elm Package.

## Usage

Not ready to be used.

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
