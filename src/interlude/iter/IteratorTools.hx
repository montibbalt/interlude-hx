package interlude.iter;

/** A type of `Iterator` that only yields elements matching some predicate **/
typedef FilteredIterator<A> = { hasNextWhere:(A->Bool)->Bool, next: ()->A }

/** A type of `Iterator` that can apply a function before yielding each element **/
typedef MappableIterator<A, B> = { hasNext:()->Bool, next:(A->B)->B }

@:nullSafety(Strict)
@:publicFields
class IteratorTools {

    /**
        Returns an empty `Iterator`
    **/
    inline static function empty<A>():Iterator<A> return {
        hasNext : () -> false
    ,   next    : () -> throw 'Calling .next() on an empty Iterable'
    }

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

    static function indexed<A>(as:Iterator<A>):KeyValueIterator<Int, A> return {
        var n = 0;
        {   hasNext : () -> as.hasNext()
        ,   next    : () -> as.next().keyedWith(n++)
        }
    }

    static function mapped<A, B>(as:Iterator<A>):MappableIterator<A, B> return {
        hasNext : as.hasNext
    ,   next    : fn -> as.next().let(fn)
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