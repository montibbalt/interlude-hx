package interlude;

import haxe.Constraints.IMap;

@:publicFields
@:nullSafety(Strict)
class MapTools {
    /** Attempts to find `key` in `map`, returning `None` if it's not found **/
    inline static function withKey<K, V>(map:IMap<K, V>, key:K):Option<V> return
        map.get(key).toOption();

    /** Attempts fo find `key` in `map`, and inserts a generated value if it's not found **/
    static function withKeyOrInsertNew<K, V>(map:IMap<K, V>, key:K, ifNotPresent:()->V):V return
        map.withKey(key).orDefault(() -> ifNotPresent().mut(map.set.bind(key)));
}