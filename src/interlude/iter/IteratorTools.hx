package interlude.iter;

/** A type of `Iterator` that only yields elements matching some predicate **/
typedef FilteredIterator<A> = { hasNextWhere:(A->Bool)->Bool, next: ()->A }

/** A type of `Iterator` that can apply a function before yielding each element **/
typedef MappableIterator<A, B> = { hasNext:()->Bool, next:(A->B)->B }

typedef PeekableIterator<A> = { peek:()->Option<A>, hasNext:()->Bool, next:()->A }

@:nullSafety(Strict)
@:publicFields
class IteratorTools {

    /**
        Converts a single element to an `Iterator` containing that element  
    **/
    inline static function asIterator<A>(a:A):Iterator<A> return {
        var done = false;
        {   hasNext: () -> !done
        ,   next   : () -> { done = true; a; }
        }
    }

    /**
        Returns an empty `Iterator`
    **/
    inline static function empty<A>():Iterator<A> return {
        hasNext : () -> false
    ,   next    : () -> throw 'Calling .next() on an empty Iterator'
    }

    /**
        converts an `Iterator` into a `FilteredIterator`
    **/
    static function filtered<A>(as:Iterator<A>):FilteredIterator<A> return {
        var cache:Null<A> = null;
        var cacheSet = false;
        var valid = false;
        {   hasNextWhere    : fn -> {
                if(cache == null || !cacheSet)
                    while(as.hasNext() && !(valid = fn({cacheSet = true; cache = as.next(); }))) {}
                cacheSet && valid;
            }
        ,   next            : () -> { cacheSet = valid = false; cast cache; }
        }
    }

    /**
        Converts an `Iterator` into one that maintains an index for its elements
    **/
    static function indexed<A>(as:Iterator<A>):KeyValueIterator<Int, A> return {
        var n = 0;
        {   hasNext : () -> as.hasNext()
        ,   next    : () -> as.next().keyedWith(n++)
        }
    }

    /**
        Converts an `Iterator` into a `MappableIterator`
    **/
    static function mapped<A, B>(as:Iterator<A>):MappableIterator<A, B> return {
        hasNext : as.hasNext
    ,   next    : fn -> as.next().let(fn)
    }

    /**
        Converts an `Iterator` into one with 1-element lookahead
    **/
    static function peekable<A>(as:Iterator<A>):PeekableIterator<A> return {
        var cache:Null<A> = null;
        {
            peek: () -> {
                if(cache != null) {
                    cache.asOption();
                }
                else if(as.hasNext()) {
                    cache = as.next();
                    cache.asOption();
                }
                else None;
            },
            hasNext: () -> cache != null || as.hasNext(),
            next: () -> {
                if(cache != null) {
                    var out = cache;
                    cache = null;
                    cast out;
                }
                else as.next();
            }
        }
    }

    /**
        Evaluates an `Iterator` as an `Array`  
        *NOTE* `as` must be finite
    **/
    inline static function toArray<A>(as:Iterator<A>):Array<A> return
        [for(a in as) a];

    /**
        Converts an `Iterator` into an `Iterable`
    **/
    static function toIterable<A>(as:Iterator<A>):Iterable<A> return {
        iterator: () -> as
    }
}