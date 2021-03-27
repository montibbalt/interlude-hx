package interlude;

@:publicFields
@:nullSafety(Strict)
class KeyValueIteratorTools {
    static function asKVIterable<K, V>(kvs:KeyValueIterator<K, V>):KeyValueIterable<K, V> return {
        keyValueIterator: () -> kvs
    }

    static function toArray<K, V>(kvs:KeyValueIterator<K, V>):Array<KeyValuePair<K, V>> return inline
        IteratorTools.toArray(kvs);
}

@:publicFields
@:nullSafety(Strict)
class KeyValueIterableTools {
    static function kvMap<K, A, B>(kvs:KeyValueIterable<K, A>, fn:K->A->B):KeyValueIterable<K, B> return {
        keyValueIterator: () -> {
            var kv_it = kvs.keyValueIterator();
            {   hasNext: kv_it.hasNext
            ,   next: () -> {
                    var kvp = kv_it.next();
                    fn(kvp.key, kvp.value).keyedWith(kvp.key);
            }}
        }
    }

    static function toKVArray<K, V>(kvs:KeyValueIterable<K, V>):Array<KeyValuePair<K, V>> return [
        for(k => v in kvs) k.keyFor(v)
    ];
}