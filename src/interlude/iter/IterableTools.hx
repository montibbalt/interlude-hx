package interlude.iter;

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

    static function ap<A, B>(fns:Iterable<A->B>, as:Iterable<A>):Iterable<B> return
        fns.flatMap(as.mapL);

    /**
        Returns a new `Iterable` that appends `with` onto the end of `as`  
        See [Lambda.concat](https://api.haxe.org/Lambda.html#concat)  
        `[1, 2, 3].append([4, 5, 6])` == `[1, 2, 3, 4, 5, 6]`
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
    inline static function asIterable<A>(a:A):Iterable<A> return
        [a];

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
    //static function choice<A>(as:Iterable<A>, genRandom:()->Float):Option<A> return as.any()
    //    ? as.uniform().draw(genRandom).asOption()
    //    : None;

    /**
        If possible, draws a random element from `as`, using `Math.random` as a source of randomness
    **/
    //inline static function choiceStd<A>(as:Iterable<A>):Option<A> return
    //    as.choice(Math.random);

    /**
        Adds a value to the front of an `Iterable`
    **/
    inline static function cons<A>(a:A, as:Iterable<A>):Iterable<A> return
        a.asIterable().append(as);

    /**
        Returns `true` if `a` is present in `as`  
        *NOTE*: This will evaluate `as` until if finds `a` or `as` is exhausted,  
        so be careful with infinite `Iterable`s
    **/
    static function contains<A>(as:Iterable<A>, a:A):Bool return
        as.filterL(a.equals).any();

    /**
        Counts the number of elements in `as`  
        *NOTE* This will fully evaluate `as`, so be careful with infinite `Iterable`s
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
        ? []
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
    inline static function empty<A>():Iterable<A> return
        [];

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
    @:nullSafety(Off)
    static function filterFMap<A, B>(as:Iterable<A>, predicate:A->Bool, fn:A->Iterable<B>):Iterable<B> return {
        iterator: () -> {
            var as_iter = as.iterator().filtered();
            var cache:Iterator<B> = null;

            var cacheEmpty = () -> (cache == null || !cache.hasNext());
            var notEmpty = () -> {
                while(cacheEmpty() && as_iter.hasNextWhere(predicate))
                    cache = fn(as_iter.next()).iterator();
                !cacheEmpty();
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
        If possible, returns the furst value of `as` that matches some `predicate`  
        *NOTE*: This will evaluate `as` until it finds a match or `as` is exhausted, 
        so be careful with infinite `Iterable`s
    **/
    static function firstWhere<A>(as:Iterable<A>, predicate:A->Bool):Option<A> return
        as.filterL(predicate).maybeFirst();

    /**
        Projects each element of `as` into an `Iterable` of `B`s using `fn` as 
        a transform, and flattens the results into a single `Iterable`  
        This version is lazy  
        See [Lambda.flatMap](https://api.haxe.org/Lambda.html#flatMap)  
        `[1, 2, 3].flatMap(x -> x.replicate(3))` == `[1, 1, 1, 2, 2, 2, 3, 3, 3]`
    **/
    @:nullSafety(Off)
    static function flatMap<A, B>(as:Iterable<A>, fn:A->Iterable<B>):Iterable<B> return
        { iterator: () -> {
            var as_iter = as.iterator();
            var cache:Iterator<B> = null;

            var cacheEmpty = () -> (cache == null || !cache.hasNext());
            var notEmpty = () -> {
                while(cacheEmpty() && as_iter.hasNext())
                    cache = fn(as_iter.next()).iterator();
                !cacheEmpty();
            }
            var next = () -> {
                notEmpty();
                cache.next();
            }

            {   hasNext : notEmpty
            ,   next    : next
            }
        }};

    /**
        Projects each element of `as` into an `Iterable` of `B`s using `fn` as 
        a transform, and flattens the results into a single `Iterable`  
        This version is strict  
        See [Lambda.flatMap](https://api.haxe.org/Lambda.html#flatMap)  
        `[1, 2, 3].flatMapS(x -> x.replicate(3))` == `[1, 1, 1, 2, 2, 2, 3, 3, 3]`
    **/
    static function flatMapS<A, B>(as:Iterable<A>, fn:A->Iterable<B>):Array<B> return
        [for(a in as) for (b in fn(a)) b];

    static function flatten<A>(ass:Iterable<Iterable<A>>):Iterable<A> return
        ass.flatMap(identity);

    /**
        Applies `fn` over elements of `as` using `seed` as an initial value,
        reducing an `Iterable` to a single value. This version is left-associative  
        See [Lambda.fold](https://api.haxe.org/Lambda.html#fold)  
        `[1, 2, 3, 4, 5].foldl(0, (x, y) -> x + y)` == `0+1+2+3+4+5` == `15`  
        `[].foldl(0, (x, y) -> x + y)` == `0`  
        *NOTE*: This may not terminate with an infinite `Iterable`
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

    static function intercalate<A>(as:Iterable<Iterable<A>>, separator:Iterable<A>):Iterable<A> return
        as.intersperse(separator).flatten();

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

    static function lastWhere<A>(as:Iterable<A>, predicate:A->Bool):Option<A> return
        as.filterL(predicate).maybeLast();

    /**
        Projects `as` into and `Iterable` of `B`s using `fn` as a transform  
        See [Lambda.map](https://api.haxe.org/Lambda.html#map)  
        This version is lazy  
        `[1, 2, 3].mapL(Std.string)` == `['1', '2', '3']`
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
        Projects `as` into and `Iterable` of `B`s using `fn` as a transform  
        See [Lambda.map](https://api.haxe.org/Lambda.html#map)  
        This version is strict  
        `[1, 2, 3].mapS(Std.string)` == `['1', '2', '3']`
    **/
    static function mapS<A, B>(as:Iterable<A>, fn:A->B):Array<B> return
        [for(a in as) fn(a)];

    static function mapMaybes<A, B>(as:Iterable<Option<A>>, fn:A->B):Iterable<B> return
        as.somes().mapL(fn);

    static function mapOutcomes<A, B>(as:Iterable<Outcome<A>>, fn:A->B):Iterable<B> return
        as.successes().mapL(fn);

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
        for (a in as) last = a;
        last.asOption();
    }

    inline static function mutate<A>(as:Iterable<A>, mutator:A->Void):Iterable<A> return {
        for (a in as)
            mutator(a);
        as;
    }

    static function mutatei<A>(as:Iterable<A>, mutator:Int->A->Void):Iterable<A> return {
        var i = 0;
        for (a in as)
            mutator(i++, a);
        as;
    }

    inline static function natural():Iterable<Int> return
        1.iterate(add1);

    static function opposite<A>(as:Iterable<A>):Array<A> return {
        var out = as.toArray();
        out.reverse();
        out;
    }

    static function orDefault<A>(as:Iterable<A>, whenEmpty:()->Iterable<A>):Iterable<A> return as.any()
        ? as
        : whenEmpty();

    static function orderByAsc<A>(as:Iterable<A>, selector:A->Int):Array<A> return
        as.toArray().mut(arr -> arr.sort((a1, a2) -> selector(a1) - selector(a2)));

    static function orderByDesc<A>(as:Iterable<A>, selector:A->Int):Array<A> return
        as.toArray().mut(arr -> arr.sort((a1, a2) -> selector(a2) - selector(a1)));

    static function pairs<A>(as:Iterable<A>):Iterable<Pair<A, A>> return
        as.zip(as.tail());

    static function partition<A>(as:Iterable<A>, predicate:A->Bool):Pair<Array<A>, Array<A>> return {
        var left = [];
        var right = [];
        for(a in as) predicate(a)
            ? left.push(a)
            : right.push(a);

        left.with(right);
    }

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

    static function shuffled<A>(as:Iterable<A>, genRandom:Int->Int):Array<A> return {
        var len = as.count();
        as.orderByAsc(_ -> genRandom(len));
    }

    inline function shuffledStd<A>(as:Iterable<A>):Array<A> return
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

    static function somes<A>(as:Iterable<Option<A>>):Iterable<A> return
        as.flatMap(OptionTools.toArray);

    static function span<A>(as:Iterable<A>, predicate:A->Bool):Pair<Iterable<A>, Iterable<A>> return
        as.takeWhile(predicate).with(as.skipWhile(predicate));

    static function successes<A>(as:Iterable<Outcome<A>>):Iterable<A> return
        as.flatMap(OutcomeTools.toArray);

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
        as.zipWith(bs, PairTools.with);

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