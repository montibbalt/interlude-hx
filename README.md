# interlude
A library of helpful static extensions for Haxe

## Usage

## Common Extension Matrix

|                  | Either              | Iterable (Array, Map, etc)             | Array1 / Iterable1            | Option     | Outcome                               |
| ---------------- | ------------------- | -------------------------------------- | ----------------------------- | ---------- | ------------------------------------- |
| all              | - [ ]               | - [x]                                  | `toIterable`                  | - [ ]      | - [ ]                                 |
| any              | - [ ]               | - [x]                                  | (always true)                 | - [x]      | - [x]                                 |
| anyMatch         | - [ ]               | - [x]                                  | `toIterable`                  | - [x]      | - [x]                                 |
| ap               | - [x]               | - [x]                                  |                               | - [x]      | - [x]                                 |
| contains         | - [ ]               | - [x]                                  | `toIterable`                  | - [x]      | - [x]                                 |
| filter           | - [ ]               | `filterL` (lazy)                       | `toIterable`                  | - [x]      | - [x]                                 |
| filterMap        | - [ ]               | - [x]                                  | `toIterable`                  | - [x]      | - [x]                                 |
| filterFMap       | - [ ]               | - [x]                                  | `toIterable`                  | - [x]      | - [x]                                 |
| flatMap          | - [x]               | `flatMap` (lazy), `flatMapS` (strict)  | `toIterable`, also `flatMap1` | - [x]      | - [x]                                 |
| flatten          | - [ ]               | - [x]                                  | `toIterable`                  | - [x]      | - [x]                                 |
| fold             | - [ ]               | `foldl`, `foldr`                       | `toIterable`                  | - [x]      | - [x]                                 |
| "lift"           | `asLeft`, `asRight` | `asIterable`                           |                               | `asOption` | `asOutcome`, `asSuccess`, `asFailure` |
| map              | - [x]               | `mapL` (lazy), `mapS` (strict)         | `toIterable`, also `map1`     | - [x]      | - [x]                                 |
| match            | - [x]               | - [ ]                                  |                               | - [x]      | - [x]                                 |
| mutate / mutate_ | - [x]               | - [x], also `mutatei`                  | `toIterable`                  | - [x]      | - [x]                                 |
| orDefault        | - [ ]               | - [x], also `orDefault1`               | `toIterable`                  | - [x]      | - [x]                                 |
| orElse           | - [ ]               | - [ ]                                  |                               | - [x]      | - [x]                                 |
| toArray          | - [ ]               | - [x]                                  | - [x], also `toArray1`        | - [x]      | - [x]                                 |
| toEither         |                     | - [ ]                                  |                               | - [x]      | - [x]                                 |
| toIterable       | - [ ]               |                                        | - [x], also`toIterable1`      | - [ ]      | - [ ]                                 |
| toNullable       | - [x]               | - [ ]                                  |                               | - [x]      | - [x]                                 |
| toOption         | - [x]               | `elementAt`, `maybeFirst`, `maybeLast` |                               |            | - [x]                                 |
| toOutcome        | - [x]               | - [ ]                                  |                               | - [x]      |                                       |
| zip              | - [x]               | - [x]                                  | `toIterable`                  | - [x]      | - [x]                                 |
| zipWith          | - [x]               | - [x]                                  | `toIterable`                  | - [x]      | - [x]                                 |

## Type-Specific Extensions
### [`T`](https://github.com/montibbalt/interlude-hx/tree/default/src/interlude/func) (any value)
### [`Function`](https://github.com/montibbalt/interlude-hx/tree/default/src/interlude/func)
### [`Either`](https://github.com/montibbalt/interlude-hx/blob/default/src/interlude/ds/EitherTools.hx)
### [`Iterable`](https://github.com/montibbalt/interlude-hx/blob/default/src/interlude/iter/IterableTools.hx)
### [`Array1`](https://github.com/montibbalt/interlude-hx/blob/default/src/interlude/ds/Array1.hx) / [`Iterable1`](https://github.com/montibbalt/interlude-hx/blob/default/src/interlude/ds/Iterable1.hx)
### [`Option`](https://github.com/montibbalt/interlude-hx/blob/default/src/interlude/ds/OptionTools.hx)
### [`Outcome`](https://github.com/montibbalt/interlude-hx/blob/default/src/interlude/ds/OutcomeTools.hx)
### [`Lazy`](https://github.com/montibbalt/interlude-hx/blob/default/src/interlude/ds/Lazy.hx)