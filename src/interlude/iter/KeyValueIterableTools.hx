package interlude.iter;

@:publicFields
@:nullSafety(Strict)
class KeyValueIteratorTools {
    /**
        Converts a `KeyValueIterator` into a `KeyValueIterable`
    **/
    static function asKVIterable<K, V>(kvs:KeyValueIterator<K, V>):KeyValueIterable<K, V> return {
        keyValueIterator: () -> kvs
    }

    /**
        Converts a `KeyValueIterator` into an `Array` of `KeyValuePair`s
    **/
    static function toArray<K, V>(kvs:KeyValueIterator<K, V>):Array<KeyValuePair<K, V>> return inline
        IteratorTools.toArray(kvs);
}

@:publicFields
@:nullSafety(Strict)
class KeyValueIterableTools {
    /**
        A version of `mapL` whose `transform` function takes a key-value pair
    **/
    static function kvMap<K, A, B>(kvs:KeyValueIterable<K, A>, transform:K->A->B):KeyValueIterable<K, B> return {
        keyValueIterator: () -> {
            var kv_it = kvs.keyValueIterator();
            {   hasNext: kv_it.hasNext
            ,   next: () -> {
                    var kvp = kv_it.next();
                    transform(kvp.key, kvp.value).keyedWith(kvp.key);
            }}
        }
    }

    /**
        Converts a `KeyValueIterable` into an `Array` of `KeyValuePair`s
    **/
    static function toKVArray<K, V>(kvs:KeyValueIterable<K, V>):Array<KeyValuePair<K, V>> return [
        for(k => v in kvs) k.keyFor(v)
    ];
}