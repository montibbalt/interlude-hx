# interlude
A library of helpful static extensions for Haxe

## Usage

## Common Extension Matrix

|                  | Either              | Iterable (Array, Map, etc)             | Array1 / Iterable1                                         | Option             | Outcome                               | Lazy               |
| ---------------- | ------------------- | -------------------------------------- | ---------------------------------------------------------- | ------------------ | ------------------------------------- | ------------------ |
| all              | :x:                 | :heavy_check_mark:                     | `toIterable`                                               | :heavy_check_mark: | :heavy_check_mark:                    | :x:                |
| any              | :x:                 | :heavy_check_mark:                     | (always true)                                              | :heavy_check_mark: | :heavy_check_mark:                    | :heavy_check_mark: |
| anyMatch         | :x:                 | :heavy_check_mark:                     | `toIterable`                                               | :heavy_check_mark: | :heavy_check_mark:                    | :x:                |
| ap               | :heavy_check_mark:  | :heavy_check_mark:                     | `toIterable`                                               | :heavy_check_mark: | :heavy_check_mark:                    | :heavy_check_mark: |
| contains         | :x:                 | :heavy_check_mark:                     | `toIterable`                                               | :heavy_check_mark: | :heavy_check_mark:                    | :x:                |
| filter           | :x:                 | `filterL` (lazy)                       | `toIterable`                                               | :heavy_check_mark: | :heavy_check_mark:                    | :x:                |
| filterMap        | :x:                 | :heavy_check_mark:                     | `toIterable`                                               | :heavy_check_mark: | :heavy_check_mark:                    | :x:                |
| filterFMap       | :x:                 | :heavy_check_mark:                     | `toIterable`                                               | :heavy_check_mark: | :heavy_check_mark:                    | :x:                |
| flatMap          | :heavy_check_mark:  | `flatMap` (lazy), `flatMapS` (strict)  | `toIterable`, also `flatMap1`                              | :heavy_check_mark: | :heavy_check_mark:                    | :heavy_check_mark: |
| flatten          | :x:                 | :heavy_check_mark:                     | `toIterable`                                               | :heavy_check_mark: | :heavy_check_mark:                    | :heavy_check_mark: |
| fold             | :x:                 | `foldl`, `foldr`                       | `toIterable`                                               | :heavy_check_mark: | :heavy_check_mark:                    | :x:                |
| "lift" a value   | `asLeft`, `asRight` | `asIterable`                           | `asArray1` / `array1With`, `asIterable1` / `iterable1With` | `asOption`         | `asOutcome`, `asSuccess`, `asFailure` | `asLazy`           |
| map              | :heavy_check_mark:  | `mapL` (lazy), `mapS` (strict)         | `toIterable`, also `map1`                                  | :heavy_check_mark: | :heavy_check_mark:                    | :heavy_check_mark: |
| match            | :heavy_check_mark:  | :x:                                    | :x:                                                        | :heavy_check_mark: | :heavy_check_mark:                    | :x:                |
| mutate / mutate_ | :heavy_check_mark:  | :heavy_check_mark:, also `mutatei`     | `toIterable`                                               | :heavy_check_mark: | :heavy_check_mark:                    | :heavy_check_mark: |
| orDefault        | :x:                 | :heavy_check_mark:, also `orDefault1`  | `toIterable`                                               | :heavy_check_mark: | :heavy_check_mark:                    | :x:                |
| orElse           | :x:                 | :heavy_check_mark:                     | :x: (technically `toIterable`)                             | :heavy_check_mark: | :heavy_check_mark:                    | :x:                |
| toArray          | :x:                 | :heavy_check_mark:                     | :heavy_check_mark:, also `toArray1`                        | :heavy_check_mark: | :heavy_check_mark:                    | :heavy_check_mark: |
| toEither         |                     | :x:                                    | :x:                                                        | :heavy_check_mark: | :heavy_check_mark:                    | :x:                |
| toIterable       | :x:                 |                                        | :heavy_check_mark:, also `toIterable1`                     | :heavy_check_mark: | :heavy_check_mark:                    | :heavy_check_mark: |
| toNullable       | :heavy_check_mark:  | :x:                                    | :x:                                                        | :heavy_check_mark: | :heavy_check_mark:                    | :x:                |
| toOption         | :heavy_check_mark:  | `elementAt`, `maybeFirst`, `maybeLast` | `toIterable`                                               |                    | :heavy_check_mark:                    | :x:                |
| toOutcome        | :heavy_check_mark:  | :x:                                    | :x:                                                        | :heavy_check_mark: |                                       | :x:                |
| zip              | :heavy_check_mark:  | :heavy_check_mark:                     | `toIterable`                                               | :heavy_check_mark: | :heavy_check_mark:                    | :heavy_check_mark: |
| zipWith          | :heavy_check_mark:  | :heavy_check_mark:                     | `toIterable`                                               | :heavy_check_mark: | :heavy_check_mark:                    | :heavy_check_mark: |

## Type-Specific Extensions
### [`T`](https://github.com/montibbalt/interlude-hx/tree/default/src/interlude/func) (any value)
### [`Function`](https://github.com/montibbalt/interlude-hx/tree/default/src/interlude/func)
### [`Either`](https://github.com/montibbalt/interlude-hx/blob/default/src/interlude/ds/EitherTools.hx)
### [`Iterable`](https://github.com/montibbalt/interlude-hx/blob/default/src/interlude/iter/IterableTools.hx)
### [`Array1`](https://github.com/montibbalt/interlude-hx/blob/default/src/interlude/ds/Array1.hx) / [`Iterable1`](https://github.com/montibbalt/interlude-hx/blob/default/src/interlude/ds/Iterable1.hx)
### [`Option`](https://github.com/montibbalt/interlude-hx/blob/default/src/interlude/ds/OptionTools.hx)
### [`Outcome`](https://github.com/montibbalt/interlude-hx/blob/default/src/interlude/ds/OutcomeTools.hx)
### [`Lazy`](https://github.com/montibbalt/interlude-hx/blob/default/src/interlude/ds/Lazy.hx)