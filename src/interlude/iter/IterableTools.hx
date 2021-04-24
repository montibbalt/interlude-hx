package interlude.iter;

/**
    Common extension methods for all types of `Iterable`s. Supports a fluent
    query-like syntax.
    ```haxe
    0.range(100) // [0...99]
        .filterL(isEven) // [0, 2, 4, ... 98]
        .map(Std.string) // ['0', '2', '4', ... '98']
        .maybeLast(); // Some('98')
    ```
**/
@:nullSafety(Strict)
@:publicFields
class IterableTools {
    /**
        Returns `true` if all elements of `as` satisfy a `predicate`  
        `[true, true, true].all(isTrue)` == `true`  
        `[true, false, true].all(isTrue)` == `false`
    **/
    static function all<A>(as:Iterable<A>, predicate:A->Bool):Bool return
        !as.anyMatch(predicate.not());

    /**
        Returns `true` if corresponding pairs of `as` and `bs` satisfy a predicate  
        `[1, 2, 3].all2([1, 2, 3], equals)` == `true`  
        `[1, 2, 3].all2([4, 2, 0], equals)` == `false`
    **/
    static function all2<A, B>(as:Iterable<A>, bs:Iterable<B>, predicate:A->B->Bool):Bool return
        as.zipWith(bs, predicate).all(identity);

    /**
        Returns `true` if every element is `true` or if `bs` is empty
    **/
    static function and(bs:Iterable<Bool>):Bool return
        bs.all(identity);

    /**
        Returns `true` if `as` is not empty
    **/
    static function any<A>(as:Iterable<A>):Bool return
        as.iterator().hasNext();

    /**
        Returns `true` if any element in `as` matches a `predicate`  
        *NOTE*: This will evaluate `as` until a match is found or `as` is exhausted, 
        so be careful with infinite `Iterable`s
    **/
    static function anyMatch<A>(as:Iterable<A>, predicate:A->Bool):Bool return
        as.filterL(predicate).iterator().hasNext();

    /**
        Experimental  
        Apply a set of functions to each element of `as`. Can be called
        repeatedly if the return type is a function.

        ```haxe
        [ a -> b -> a + b
        , a -> b -> a - b
        ].ap([1, 2])
         .ap([3, 4])

           | --------- a + b  -------- | --------  a - b  ------- |  
        == [(1+3), (1+4), (2+3), (2+4), (1-3), (1-4), (2-3), (2-4)]  
        == [  4,     5,     5,     6,    -2,    -3,    -1,    -2]
        ```
    **/
    static function ap<A, B>(fns:Iterable<A->B>, as:Iterable<A>):Iterable<B> return
        fns.flatMap(as.mapL);

    /**
        Returns a new `Iterable` that appends `with` onto the end of `as`  
        `[1, 2, 3].append([4, 5, 6])` == `[1, 2, 3, 4, 5, 6]`
        @see [Lambda.concat](https://api.haxe.org/Lambda.html#concat)  
    **/
    static function append<A>(as:Iterable<A>, with:Iterable<A>):Iterable<A> return {
        iterator: () -> {
            var a_it = as.iterator();
            var b_it = with.iterator();
            {   hasNext : () -> a_it.hasNext() || b_it.hasNext()
            ,   next    : () -> a_it.hasNext() ? a_it.next() : b_it.next()
            }
        }
    }

    /**
        Converts a single element to an `Iterable` containing that element  
        TODO: should this return `Iterable1`?
    **/
    inline static function asIterable<A>(a:A, ...rest:A):Iterable<A> return
        a.cons(rest);

    /**
        If `as` has any elements, returns the element at a positive `index`  
        Wraps around to the beginning if `index` is out of bounds  
        `[1, 2, 3].atWrappedIndex(1)` == `Some(2)`  
        `[1, 2, 3].atWrappedUndex(10)` == `Some(2)`  
        `[1].atWrappedIndex(100)` == `Some(1)`  
        `[].atWrappedIndex(1000)` == `None`
    **/
    static function atWrappedIndex<A>(as:Iterable<A>, index:Int):Option<A> return
        as.cycle().elementAt(index);

    /**
        If possible, draws a random element from `as`, using `genRandom` as a source of randomness
    **/
    static function choice<A>(as:Iterable<A>, genRandom:()->Float):Option<A> return as.any()
        ? as.uniform().draw(genRandom).asOption()
        : None;

    /**
        If possible, draws a random element from `as`, using `Math.random` as a source of randomness
    **/
    inline static function choiceStd<A>(as:Iterable<A>):Option<A> return
        as.choice(Math.random);

    /**
        Adds a value to the front of an `Iterable`
    **/
    inline static function cons<A>(a:A, as:Iterable<A>):Iterable<A> return
        [a].append(as);

    /**
        Returns `true` if `a` is present in `as`  
        *NOTE*: This will evaluate `as` until if finds `a` or `as` is exhausted,  
        so be careful with infinite `Iterable`s
    **/
    static function contains<A>(as:Iterable<A>, a:A):Bool return
        as.filterL(a.equals).any();

    /**
        Counts the number of elements in `as`  
        *NOTE*: This will fully evaluate `as`, so be careful with infinite `Iterable`s
    **/
    static function count<A>(as:Iterable<A>):Int return {
        var count = 0;
        for (a in as) count++;
        count;
    };

    /**
        Infinitely repeats an `Iterable`  
        `[6, 9].cycle()` == `[6, 9, 6, 9, 6, ...]`
    **/
    static function cycle<A>(as:Iterable<A>):Iterable<A> return as.isEmpty()
        ? as
        : { iterator: () -> {
                var as_it = as.iterator();
                {   hasNext : () -> true
                ,   next    : () -> as_it.hasNext() ? as_it.next() : {
                        as_it = as.iterator();
                        as_it.next();
                    }
                }
            }
        }

    /**
        A lazy `unfold` operation, which produces an `Iterable` from an initial
        seed. The opposite of `foldl` (which reduces an `Iterable` to a single
        value)  
        ```haxe
        (x -> x == 0 
            ? None
            : Some(x.with(x - 1))
        ).distribute(5)

        == [5, 4, 3, 2, 1]
        ```
    **/
    static function distribute<A, B>(fn:A->Option<Pair<B, A>>, seed:A):Iterable<B> return {
        iterator: () -> {
            var cached = fn(seed);
            {   hasNext: () -> cached.any()
            ,   next    : () -> switch cached {
                    case Some({_1:b, _2:a}):
                        cached = fn(a);
                        b;
                    default: throw 'Calling next with no remaining elements';
            }
            }
        }
    }

    /**
        If possible, returns an element from `as` at a specified `index`  
        `[1, 2, 3].elementAt(1)` == `Some(2)`  
        `[1, 2, 3].elementAt(10)` == `None`  
        `[].elementAt(100)` == `None`
    **/
    static function elementAt<A>(as:Iterable<A>, index:Int):Option<A> return as.isEmpty() || index < 0
        ? None
        : as.skip(index).maybeFirst();

    /**
        Returns an empty `Iterable`
    **/
    static function empty<A>():Iterable<A> return {
        iterator: IteratorTools.empty
    }

    /**
        An alternative to `indexed`. Pairs every element of `as` with its index
    **/
    inline static function enumerate<A>(as:Iterable<A>):Iterable<Pair<Int, A>> return
        indices().zip(as);

    /**
        Splits `as` into chunks of size `n`  
        If `n <= 0`, returns an empty `Iterable`
    **/
    static function every<A>(as:Iterable<A>, n:Int):Iterable<Iterable<A>> return n <= 0
        ? []
        : { iterator: () -> {
                var cached = as;
                {   hasNext : () -> cached.any()
                ,   next    : () -> { var out = cached.take(n); cached = cached.skip(n); out; }
                }
            }
          };

    /**
        Returns elements of `as` that are not equal to `except`
    **/
    static function except<A>(as:Iterable<A>, except:A):Iterable<A> return
        as.filterL(except.notEquals);

    /**
        Returns elements of `as` that do not appear in `except`
    **/
    static function excepts<A>(as:Iterable<A>, except:Iterable<A>) return
        as.filterL(a -> !except.contains(a));

    /**
        Returns elements of `as` that satisfy some `predicate`
    **/
    static function filterL<A>(as:Iterable<A>, predicate:A->Bool):Iterable<A> return {
        iterator: () -> {
            var fit = as.iterator().filtered();
            {   hasNext : () -> fit.hasNextWhere(predicate)
            ,   next    : () -> fit.next()
            }
        }
    }

    /**
        A fused combination of `filter` and `map`
    **/
    static function filterMap<A, B>(as:Iterable<A>, predicate:A->Bool, fn:A->B):Iterable<B> return {
        iterator: () -> {
            var fit = as.iterator().filtered();
            {   hasNext : () -> fit.hasNextWhere(predicate)
            ,   next    : () -> fn(fit.next())
            }
        }
    }

    /**
        A fused combination of `filter` and `flatMap`
    **/
    static function filterFMap<A, B>(as:Iterable<A>, predicate:A->Bool, fn:A->Iterable<B>):Iterable<B> return {
        iterator: () -> {
            var as_iter = as.iterator().filtered();
            var cache:Iterator<B> = IteratorTools.empty();

            var notEmpty = () -> {
                while(!cache.hasNext() && as_iter.hasNextWhere(predicate))
                    cache = fn(as_iter.next()).iterator();
                cache.hasNext();
            }
            var next = () -> {
                notEmpty();
                cache.next();
            }

            {   hasNext : notEmpty
            ,   next    : next
            }
        }
    }

    /**
        Returns the first element of `as` or a default value if `as` is empty  
    **/
    static function firstOrDefault<A>(as:Iterable<A>, genDefault:()->A):A return
        as.maybeFirst().orDefault(genDefault);

    /**
        If possible, returns the first value of `as` that matches some `predicate`  
        *NOTE*: This will evaluate `as` until it finds a match or `as` is exhausted, 
        so be careful with infinite `Iterable`s
    **/
    static function firstMatch<A>(as:Iterable<A>, predicate:A->Bool):Option<A> return
        as.filterL(predicate).maybeFirst();

    /**
        Projects each element of `as` into an `Iterable` of `B`s using `fn` as 
        a transform, and flattens the results into a single `Iterable`  
        This version is lazy  
        `[1, 2, 3].flatMap(x -> x.replicate(3))` == `[1, 1, 1, 2, 2, 2, 3, 3, 3]`
        @see [Lambda.flatMap](https://api.haxe.org/Lambda.html#flatMap)  
    **/
    static function flatMap<A, B>(as:Iterable<A>, fn:A->Iterable<B>):Iterable<B> return {
        iterator: () -> {
            var as_iter = as.iterator();
            var cache:Iterator<B> = IteratorTools.empty();

            var notEmpty = () -> {
                while(!cache.hasNext() && as_iter.hasNext())
                    cache = fn(as_iter.next()).iterator();
                cache.hasNext();
            }
            var next = () -> {
                notEmpty();
                cache.next();
            }

            {   hasNext : notEmpty
            ,   next    : next
            }
        }
    };

    /**
        Projects each element of `as` into an `Iterable` of `B`s using `fn` as 
        a transform, and flattens the results into a single `Iterable`  
        This version is strict  
        `[1, 2, 3].flatMapS(x -> x.replicate(3))` == `[1, 1, 1, 2, 2, 2, 3, 3, 3]`
        @see [Lambda.flatMap](https://api.haxe.org/Lambda.html#flatMap)  
    **/
    static function flatMapS<A, B>(as:Iterable<A>, fn:A->Iterable<B>):Array<B> return
        [for(a in as) for (b in fn(a)) b];

    /**
        Appends one level of nested `Iterable`s together  
        `[[1, 2, 3], [4, 5, 6], [7, 8, 9]].flatten()` == `[1, 2, 3, 4, 5, 6, 7, 8, 9]`  
        `[].flatten()` == `[]`
    **/
    static function flatten<A>(ass:Iterable<Iterable<A>>):Iterable<A> return
        ass.flatMap(identity);

    /**
        Applies `fn` over elements of `as` using `seed` as an initial value,
        reducing an `Iterable` to a single value. This version is left-associative  
        `[1, 2, 3, 4, 5].foldl(0, (x, y) -> x + y)` == `0+1+2+3+4+5` == `15`  
        `[].foldl(0, (x, y) -> x + y)` == `0`  
        *NOTE*: This may not terminate with an infinite `Iterable`
        @see [Lambda.fold](https://api.haxe.org/Lambda.html#fold)  
    **/
    static function foldl<A, B>(as:Iterable<A>, seed:B, fn:(accumulator:B, current:A)->B):B return {
        var accum = seed;
        for(a in as)
            accum = fn(accum, a);
        accum;
    }

    /**
        Applies `fn` over elements of `as` using `seed` as an initial value,
        reducing an `Iterable` to a single value. This version is right-associative  
        `[1, 2, 3, 4, 5].foldl(0, (x, y) -> x + y)` == `0+5+4+3+2+1` == `15`  
        `[].foldr(0, (x, y) -> x + y)` == `0`  
        *NOTE*: This may not terminate with an infinite `Iterable`
    **/
    static function foldr<A, B>(as:Iterable<A>, seed:B, fn:(current:A, accumulator:B)->B):B return as.isEmpty()
        ? seed
        : {
            var accum = seed;
            for(a in as.take(1))
                accum = fn(a, as.tail().foldr(seed, fn));
            accum;
        };

    /**
        An alternative to `enumerate`. Converts a plain `Iterable` to one that
        maintains an index for each element.
    **/
    static function indexed<A>(as:Iterable<A>):KeyValueIterable<Int, A> return {
        keyValueIterator: as.iterator().indexed
    }

    /**
        Returns an `Iterable` containing every `Int` >= 0  
        In theory this is infinite; in practice it will overflow MAX_INT
    **/
    inline static function indices():Iterable<Int> return
        0.iterate(add1);

    /**
        Returns all elements of `as` except the last one
    **/
    @:nullSafety(Off)
    static function init<A>(as:Iterable<A>):Iterable<A> return {
        iterator: () -> {
            var it = as.iterator();
            var cache:Null<A> = it.hasNext() ? it.next() : null;
            {   hasNext : () -> cache != null && it.hasNext()
            ,   next    : () -> { var tmp = cache; cache = it.next(); tmp; }
            }
        }
    }

    /**
        Inserts `separator` in between `Iterable`s and flattens the result  
        `[[1, 2], [3, 4], [5, 6]].intercalate([0, 0])` == `[1, 2, 0, 0, 3, 4, 0, 0, 5, 6]`
    **/
    static function intercalate<A>(ass:Iterable<Iterable<A>>, separator:Iterable<A>):Iterable<A> return
        ass.intersperse(separator).flatten();

    /**
        Returns an `Iterable` with `separator` interspersed between every
        element of `as`  
        `[1, 2, 3, 4].intersperse(0)` == `[1, 0, 2, 0, 3, 0, 4]`
    **/
    static function intersperse<A>(as:Iterable<A>, separator:A):Iterable<A> return {
        iterator: () -> {
            var as_it = as.iterator();
            var needSep = false;
            {   hasNext : () -> as_it.hasNext()
            ,   next    : () -> needSep 
                              ? { needSep = false; separator; }
                              : { needSep = true; as_it.next(); }
            }
        }
    }

    /**
        Returns `true` iff `as` does not have any elements
    **/
    inline static function isEmpty<A>(as:Iterable<A>):Bool return
        !as.any();

    /**
      Creates an infinite sequence of `T` values by applying `fn` to the first
      value, then to the result of that, then...  
      `iterate(0, add1)` == `[x, f(x), f(f(x)), f(f(f(x))), ...]` == `[0, 1, 2, 3, 4, 5, ...]`
    **/
    static function iterate<A>(a:A, fn:A->A):Iterable<A> return {
        var cached = a;
        var it = a.asIterable();
        it.append({
            iterator: () -> {
                hasNext : () -> true
            ,   next    : () -> cached = fn(cached)
            }
        });
    }

    /**
        If possible, returns the last value of `as` that matches some
        `predicate`  
        *NOTE*: This will evaluate `as` until it finds a match or `as` is
        exhausted, so be careful with infinite `Iterable`s
    **/
    static function lastMatch<A>(as:Iterable<A>, predicate:A->Bool):Option<A> return
        as.filterL(predicate).maybeLast();

    /**
        Projects `as` into an `Iterable` of `B`s using `fn` as a transform  
        This version is lazy  
        `[1, 2, 3].mapL(Std.string)` == `['1', '2', '3']`
        @see [Lambda.map](https://api.haxe.org/Lambda.html#map)  
    **/
    static function mapL<A, B>(as:Iterable<A>, fn:A->B):Iterable<B> return {
        iterator: () -> {
            var as_iter = as.iterator().mapped();
            {   hasNext: as_iter.hasNext
            ,   next    : () -> as_iter.next(fn)
            }
        }
    }

    /**
        Projects `as` into an `Iterable` of `B`s using `fn` as a transform  
        This version is strict  
        `[1, 2, 3].mapS(Std.string)` == `['1', '2', '3']`
        @see [Lambda.map](https://api.haxe.org/Lambda.html#map)  
    **/
    static function mapS<A, B>(as:Iterable<A>, fn:A->B):Array<B> return
        [for(a in as) fn(a)];

    /**
        A version of `mapL` that can discard elements.  Only `Some` values are
        `transform`ed and returned in the output.  
    **/
    static function mapMaybes<A, B>(as:Iterable<Option<A>>, transform:A->B):Iterable<B> return
        as.somes().mapL(transform);

    /**
        A version of `mapL` that can discard elements.  Only `Success` values
        are `transform`ed and returned in the output.  
    **/
    static function mapOutcomes<A, B>(as:Iterable<Outcome<A>>, transform:A->B):Iterable<B> return
        as.successes().mapL(transform);

    /**
        Attempts to get the first element of `as`, if there is one  
        `[a, b, c].maybeFirst()` == `Some(a)`  
        `[].maybeFirst()` == `None`
    **/
    static function maybeFirst<A>(as:Iterable<A>):Option<A> return {
        var as_iter = as.iterator();
        as_iter.hasNext()
            ? Some(as_iter.next())
            : None;
    }

    /**
        Attempts to get the last element of `as`, if there is one  
        `[a, b, c].maybeLast()` == `Some(c)`  
        `[].maybeLast()` == `None`  
        *NOTE*: this will not terminate if `as` is infinite
    **/
    static function maybeLast<A>(as:Iterable<A>):Option<A> return {
        var last:Null<A> = null;
        for (a in as)
            last = a;
        last.asOption();
    }

    /**
        Calls `mutator` on every element of `as`. Essentially a `for` loop
        specifically for mutating values
    **/
    inline static function mutate<A>(as:Iterable<A>, mutator:A->Void):Iterable<A> return {
        for (a in as)
            mutator(a);
        as;
    }

    /**
        Calls `mutator` on every element of `as` and their indices. Essentially
        a `for` loop specifically for mutating values
    **/
    static function mutatei<A>(as:Iterable<A>, mutator:Int->A->Void):Iterable<A> return {
        var i = 0;
        for (a in as)
            mutator(i++, a);
        as;
    }

    /**
      Returns an infinite `Iterable` of natural numbers  
      `natural()` == `[1, 2, 3, 4, 5, 6, ...]`
     **/
    inline static function natural():Iterable<Int> return
        1.iterate(add1);

    static function opposite<A>(as:Iterable<A>):Array<A> return {
        var out = as.toArray();
        out.reverse();
        out;
    }

    /**
      Returns the input Iterable if it has any elements, or some default if
      empty
    **/
    static function orDefault<A>(as:Iterable<A>, whenEmpty:()->Iterable<A>):Iterable<A> return as.any()
        ? as
        : whenEmpty();

    /**
      Returns the input Iterable if it has any elements, or some default if empty
      The default is required to have at least one element
    **/
    static function orDefault1<A>(as:Iterable<A>, whenEmpty:()->Iterable1<A>):Iterable<A> return as.any()
        ? as
        : whenEmpty();

    static function orderByAsc<A>(as:Iterable<A>, selector:A->Int):Array<A> return
        as.toArray().mut(arr -> arr.sort((a1, a2) -> selector(a1) - selector(a2)));

    static function orderByDesc<A>(as:Iterable<A>, selector:A->Int):Array<A> return
        as.toArray().mut(arr -> arr.sort((a1, a2) -> selector(a2) - selector(a1)));

    static function orElse<A>(as:Iterable<A>, genOther:()->Iterable<A>):Iterable<A> return as.any()
        ? as
        : genOther();

    /**
        Common use of `zip`, useful for comparing an element with the next one  
        `[1, 2, 3, 4].pairs()` == `[(1, 2), (2, 3), (3, 4)]`
    **/
    static function pairs<A>(as:Iterable<A>):Iterable<Pair<A, A>> return
        as.zip(as.tail());

    /**
      Splits an `Iterable` into two subarrays based on a `predicate`  
      `0.iterate(add1).partition(isEven)` == ([0, 2, 4, ...], [1, 3, 5, ...])
      TODO: add a lazy version that doesn't evaluate the source list twice
     **/
    static function partition<A>(as:Iterable<A>, predicate:A->Bool):Pair<Array<A>, Array<A>> return {
        var left = [];
        var right = [];
        for(a in as) predicate(a)
            ? left.push(a)
            : right.push(a);

        left.with(right);
    }

    /**
        Cartesian product of two `Iterable`s  
        A deck of playing cards could be represented as
        `suits.product(ranks, Card.new)`
    **/
    static function product<A, B, C>(as:Iterable<A>, bs:Iterable<B>, fn:A->B->C):Iterable<C> return
        as.flatMap(bs.mapL.of(fn.curry()));

    /**
        Returns an `Iterable` containing a range of numbers between `start` and
        `start+count`  
        `0.range(5)` == `[0, 1, 2, 3, 4]`
    **/
    inline static function range(start:Int, count:Int):Iterable<Int> return
        start.iterate(add1).take(count);

    /**
        Returns an `Iterable` where `a` is infinitely repeated
    **/
    static function repeat<A>(a:A):Iterable<A> return
        a.iterate(identity);

    /**
        Returns an `Iterable` where `a` is repeated `count` times
    **/
    static function replicate<A>(a:A, count:Int):Iterable<A> return
        a.repeat().take(count);

    /**
      Applies `fn` to each element of `as`, passing an accumulator value through
      the computation  
      This version includes the seed as the first element of the output  
      `[0, 1, 2, 3].scan(1, (x, y) -> x + y)` == `[1, 1, 2, 4, 7]`
     **/
    static function scan<A, B>(as:Iterable<A>, seed:B, fn:B->A->B):Iterable<B> return
        seed.cons(as.scan_(seed, fn));

    /**
      Applies `fn` to each element of `as`, passing an accumulator value through
      the computation  
      This version does not include the seed in the output  
      `[0, 1, 2, 3].scan_(1, (x, y) -> x + y)` == `[1, 2, 4, 7]`
     **/
    static function scan_<A, B>(as:Iterable<A>, seed:B, fn:B->A->B):Iterable<B> return {
        iterator: () -> {
            var it = as.iterator();
            var accum = seed;
            {   hasNext : () -> it.hasNext()
            ,   next    : () -> accum = fn(accum, it.next())
            }
        }
    }

    /**
        Returns elements of `as` in a random order, using `genRandom` as a
        source of randomness
    **/
    static function shuffled<A>(as:Iterable<A>, genRandom:Int->Int):Array<A> return {
        var len = as.count();
        as.orderByAsc(_ -> genRandom(len));
    }

    /**
        Returns elements of `as` in a random order, using `Std.random` as a
        source of randomness
    **/
    inline static function shuffledStd<A>(as:Iterable<A>):Array<A> return
        as.shuffled(Std.random);

    /**
      Returns all of the elements of `as` after the first `count` items  
      If `as` has <= `count` items, return empty list  
      `[a, b, c].skip(2)` == `[c]`  
      `[a, b, c].skip(200)` == `[]`
     **/
    static function skip<A>(as:Iterable<A>, count:Int):Iterable<A> return {
        iterator: () -> {
            var it = as.iterator();
            var n = 0;
            while(n++ < count && it.hasNext())
                it.next();
            it;
        }
    }

    /**
      Skips elements of `as` until they no longer match `predicate`  
      If all elements match, returns an empty `Iterable`  
      `[1, 2, 3, 4].skipWhile(x -> x < 3)` == `[3, 4]`
      `[1, 2, 3, 4].skipWhile(x -> x > 0)` == `[]`  
      *NOTE*: This may not terminate if every element of an infinite `Iterable`
      matches the `predicate`
     **/
    static function skipWhile<A>(as:Iterable<A>, predicate:A->Bool):Iterable<A> return {
        iterator: () -> {
            var it = as.iterator();
            var cache:A;
            var valid = false;
            while(it.hasNext() && predicate({valid = true; cache = it.next(); })) { valid = false; }
            {   hasNext : () -> valid || it.hasNext()
            ,   next    : () -> if(valid) { valid = false; cache; } else it.next()
            }
        }
    }

    /**
        Returns all the `Some` values from a set of `Option`s
    **/
    static function somes<A>(as:Iterable<Option<A>>):Iterable<A> return
        as.flatMap(OptionTools.toIterable);

    /**
        Returns a `Pair` containing the longest prefix of `as` that match some 
        `predicate` and the rest of the `Iterable`  
        `[1, 2, 3, 4, 1, 2, 3].span(x -> x < 3)` == `([1, 2], [3, 4, 1, 2, 3])`
    **/
    static function span<A>(as:Iterable<A>, predicate:A->Bool):Pair<Iterable<A>, Iterable<A>> return
        as.takeWhile(predicate).with(as.skipWhile(predicate));


    /**
        Returns all the `Success` values from a set of `Outcome`s
    **/
    static function successes<A>(as:Iterable<Outcome<A>>):Iterable<A> return
        as.flatMap(OutcomeTools.toArray);

    /**
        Return all elements of an `Iterable` except the first one.  
        Returns [] if `as` is empty or only has one element  
        `[1, 2, 3].tail()` == `[2, 3]`  
        `[1].tail()` == `[]`
        `[].tail()` == `[]`
    **/
    inline static function tail<A>(as:Iterable<A>):Iterable<A> return
        as.skip(1);

    /**
      Returns up to the first `count` elements of `as`  
      If `as` does not have >= `count` elements, it returns as many as it can  
      `[a, b, c, d].take(2)` == `[a, b]`  
      `[].take(2)` == `[]`
     **/
    static function take<A>(as:Iterable<A>, count:Int):Iterable<A> return {
        iterator: () -> {
            var it = as.iterator();
            var n = 0;
            {   hasNext : () -> n < count && it.hasNext()
            ,   next    : () -> { n++; it.next(); }
            }
        }
    }

    /**
      Returns elements from `as` until one is found that doesn't match
      `predicate`  
      `[1, 2, 3, 4, 5, 6].takeWhile(x -> x < 4)` == `[1, 2, 3]`
     **/
    @:nullSafety(Off)
    static function takeWhile<A>(as:Iterable<A>, predicate:A->Bool):Iterable<A> return {
        iterator: () -> {
            var it = as.iterator();
            var cache:A = null;
            var valid = false;
            {   hasNext : () -> (!valid && it.hasNext() && predicate({ valid = true; cache = it.next(); })) ? true : { valid = false; }
            ,   next    : () -> { valid = false; cache; }
            }
        }
    }

    /**
        Converts an `Iterable` into an `Array`.  
        *NOTE*: Since this fully evaluates the `Iterable`, it may not terminate 
        if `as` is infinite.
    **/
    inline static function toArray<A>(as:Iterable<A>):Array<A> return
        as.iterator().toArray();

    /**
        Returns `Pair`s of values from `as` and `bs`. If the two `Iterable`s are
        not the same length, `zip` stops at the end of the shorter one  
        `[1, 2, 3].zip(['a', 'b', 'c])` == `[(1, 'a'), (2, 'b'), (3, 'c')]`  
        `[1, 2, 3].zip([])` == `[]`
    **/
    static function zip<A, B, C:NotVoid>(as:Iterable<A>, bs:Iterable<B>):Iterable<Pair<A, B>> return
        as.zipWith(bs, Pair.with);

    /**
        Applies a `transform` function to corresponsing pairs of elements in
        `as` and `bs`  
        If the `Iterable`s don't have the same number of elements, `zipWith`
        will only apply until it reaches the end of the shorter one  
        `[1, 2, 3].zipWith([4, 5, 6], (x, y) -> x + y)` == `[1+4, 2+5, 3+6]` == `[5, 7, 9]`
    **/
    static function zipWith<A, B, C:NotVoid>(as:Iterable<A>, bs:Iterable<B>, transform:A->B->C):Iterable<C> return {
        iterator: () -> {
            var a_it = as.iterator();
            var b_it = bs.iterator();
            {   hasNext : () -> a_it.hasNext() && b_it.hasNext()
            ,   next    : () -> transform(a_it.next(), b_it.next())
            }
        }
    }
}