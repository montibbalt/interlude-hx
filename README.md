# interlude
A library of helpful static extensions for Haxe

## Usage

## Common Extension Matrix

|                  | Either              | Iterable (Array, Map, etc)             | Array1 / Iterable1                                         | Option             | Outcome                               | Lazy               | Task               |
| ---------------- | ------------------- | -------------------------------------- | ---------------------------------------------------------- | ------------------ | ------------------------------------- | ------------------ | ------------------ |
| all              | :x:                 | :heavy_check_mark:                     | `toIterable`                                               | :heavy_check_mark: | :heavy_check_mark:                    | :x:                | :x:                |
| any              | :x:                 | :heavy_check_mark:                     | (always true)                                              | :heavy_check_mark: | :heavy_check_mark:                    | :heavy_check_mark: | :heavy_check_mark: |
| anyMatch         | :x:                 | :heavy_check_mark:                     | `toIterable`                                               | :heavy_check_mark: | :heavy_check_mark:                    | :x:                | :x:                |
| ap               | :heavy_check_mark:  | :heavy_check_mark:                     | `toIterable`                                               | :heavy_check_mark: | :heavy_check_mark:                    | :heavy_check_mark: | :heavy_check_mark: |
| contains         | :x:                 | :heavy_check_mark:                     | `toIterable`                                               | :heavy_check_mark: | :heavy_check_mark:                    | :x:                | :x:                |
| filter           | :x:                 | `filterL` (lazy)                       | `toIterable`                                               | :heavy_check_mark: | :heavy_check_mark:                    | :x:                | :heavy_check_mark: |
| filterMap        | :x:                 | :heavy_check_mark:                     | `toIterable`                                               | :heavy_check_mark: | :heavy_check_mark:                    | :x:                | :heavy_check_mark: |
| filterFMap       | :x:                 | :heavy_check_mark:                     | `toIterable`                                               | :heavy_check_mark: | :heavy_check_mark:                    | :x:                | :heavy_check_mark: |
| flatMap          | :heavy_check_mark:  | `flatMap` (lazy), `flatMapS` (strict)  | `toIterable`, also `flatMap1`                              | :heavy_check_mark: | :heavy_check_mark:                    | :heavy_check_mark: | :heavy_check_mark: |
| flatten          | :x:                 | :heavy_check_mark:                     | `toIterable`                                               | :heavy_check_mark: | :heavy_check_mark:                    | :heavy_check_mark: | :heavy_check_mark: |
| fold             | :x:                 | `foldl`, `foldr`                       | `toIterable`                                               | :heavy_check_mark: | :heavy_check_mark:                    | :x:                | :x:                |
| "lift" a value   | `asLeft`, `asRight` | `asIterable`                           | `asArray1` / `array1With`, `asIterable1` / `iterable1With` | `asOption`         | `asOutcome`, `asSuccess`, `asFailure` | `asLazy`           | `asTask`           |
| map              | :heavy_check_mark:  | `mapL` (lazy), `mapS` (strict)         | `toIterable`, also `map1`                                  | :heavy_check_mark: | :heavy_check_mark:                    | :heavy_check_mark: | :heavy_check_mark: |
| match            | :heavy_check_mark:  | :x:                                    | :x:                                                        | :heavy_check_mark: | :heavy_check_mark:                    | :x:                | :x:                |
| mutate / mutate_ | :heavy_check_mark:  | :heavy_check_mark:, also `mutatei`     | `toIterable`                                               | :heavy_check_mark: | :heavy_check_mark:                    | :heavy_check_mark: | :heavy_check_mark: |
| orDefault        | :x:                 | :heavy_check_mark:, also `orDefault1`  | `toIterable`                                               | :heavy_check_mark: | :heavy_check_mark:                    | :x:                | :x:                |
| orElse           | :x:                 | :heavy_check_mark:                     | :x: (technically `toIterable`)                             | :heavy_check_mark: | :heavy_check_mark:                    | :x:                | :x:                |
| toArray          | :x:                 | :heavy_check_mark:                     | :heavy_check_mark:, also `toArray1`                        | :heavy_check_mark: | :heavy_check_mark:                    | :heavy_check_mark: | :x:                |
| toEither         |                     | :x:                                    | :x:                                                        | :heavy_check_mark: | :heavy_check_mark:                    | :x:                | :x:                |
| toIterable       | :x:                 |                                        | :heavy_check_mark:, also `toIterable1`                     | :heavy_check_mark: | :heavy_check_mark:                    | :heavy_check_mark: | :x:                |
| toNullable       | :heavy_check_mark:  | :x:                                    | :x:                                                        | :heavy_check_mark: | :heavy_check_mark:                    | :x:                | :x:                |
| toOption         | :heavy_check_mark:  | `elementAt`, `maybeFirst`, `maybeLast` | `toIterable`                                               |                    | :heavy_check_mark:                    | :x:                | :x:                |
| toOutcome        | :heavy_check_mark:  | :x:                                    | :x:                                                        | :heavy_check_mark: |                                       | :x:                | :x:                |
| zip              | :heavy_check_mark:  | :heavy_check_mark:                     | `toIterable`                                               | :heavy_check_mark: | :heavy_check_mark:                    | :heavy_check_mark: | :heavy_check_mark: |
| zipWith          | :heavy_check_mark:  | :heavy_check_mark:                     | `toIterable`                                               | :heavy_check_mark: | :heavy_check_mark:                    | :heavy_check_mark: | :heavy_check_mark: |

## Type-Specific Extensions
### [`T`](https://github.com/montibbalt/interlude-hx/tree/default/src/interlude/func) (any value)
### [`Function`](https://github.com/montibbalt/interlude-hx/tree/default/src/interlude/func)
### [`Either`](https://github.com/montibbalt/interlude-hx/blob/default/src/interlude/ds/EitherTools.hx)
### [`Iterable`](https://github.com/montibbalt/interlude-hx/blob/default/src/interlude/iter/IterableTools.hx)
### [`Array1`](https://github.com/montibbalt/interlude-hx/blob/default/src/interlude/ds/Array1.hx) / [`Iterable1`](https://github.com/montibbalt/interlude-hx/blob/default/src/interlude/ds/Iterable1.hx)
### [`Map`](https://github.com/montibbalt/interlude-hx/blob/default/src/interlude/ds/MapTools.hx)
### [`Option`](https://github.com/montibbalt/interlude-hx/blob/default/src/interlude/ds/OptionTools.hx)
### [`Outcome`](https://github.com/montibbalt/interlude-hx/blob/default/src/interlude/ds/OutcomeTools.hx)
### [`Pair` / `Trio`](https://github.com/montibbalt/interlude-hx/blob/default/src/interlude/ds/PairTools.hx)
### [`Lazy`](https://github.com/montibbalt/interlude-hx/blob/default/src/interlude/ds/Lazy.hx)