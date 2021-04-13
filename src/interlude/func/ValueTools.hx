package interlude.func;

@:nullSafety(Strict)
@:publicFields
class ValueTools {
    /** Adds 1 to an Int **/
    inline static function add1(n:Int):Int return
        n + 1;

    /** Adds 1.0 to a Float **/
    inline static function add1f(n:Float):Float return
        n + 1.0;

    //inline static function branch<A, B>(value:A, predicate:A->Bool, whenTrue:A->B, whenFalse:A->B):B return
    //    predicate(value) ? whenTrue(value) : whenFalse(value);

    /** Subtracts 1 from an Int**/
    inline static function sub1(n:Int):Int return
        n - 1;

    /** Subtracts 1.0 from a Float **/
    inline static function sub1f(n:Float):Float return
        n - 1.0;

    /** An extension that drops its value into a Void **/
    inline static function discard<A>(_:A):Void return
        ;

    /** An extension that drops its value and position info into a Void **/
    inline static function discardWithPos<A>(_:A, ?pos:haxe.PosInfos):Void return
        ;

    /** A no-op function **/
    inline static function doNothing():Void return
        ;

    /** Composable version of the `==` operator **/
    inline static function equals<A>(x:A, y:A):Bool return
        x == y;

    /**
        A function that always returns its input unchanged  
        `Some(123).map(identity)` == `Some(123)`
    **/
    inline static function identity<A>(a:A):A return
        a;

    /**
        Composable way to create a Key/Value pair  
        `"abc".keyedWith(123)` == `{ key: 123, value: "abc" }`
    **/
    inline static function keyedWith<K, V>(value:V, key:K):KeyValuePair<K, V> return
        { key: key, value: value };

    /**
        Composable way to create a Key/Value pair  
        `123.keyFor("abc")` == `{ key: 123, value: "abc" }`
    **/
    inline static function keyFor<K, V>(key:K, value:V):KeyValuePair<K, V> return
        value.keyedWith(key);

    /**
        Fluent method for transforming a value  
        Similar to `map` but for any value  
        `123.let(Std.string)` == `"123"`
    **/
    inline static function let<T, K>(v:T, transformer:T->K):K return
        transformer(v);

    /**
        Fluent method for mutating a value or whatever else  
        Similar to `mutate` but for any value
    **/
    inline static function mut<T>(v:T, mutator:T->Void):T return {
        mutator(v);
        v;
    }

    /** Composable version of the `!` (not) operator **/
    inline static function notb(b:Bool):Bool return
        !b;

    /** Composable version of the `!=` operator **/
    inline static function notEquals<A>(x:A, y:A):Bool return
        x != y;

    /**
        An extension that always returns the original value and drops any input  
        `69.v_("nice")` == `69`
    **/
    static function v_<A, B>(value:A, input:B):A return
        value;

    /**
        An extension that always returns some input and drops the original value  
        `69._n("nice")` == `"nice"`
    **/
    static function _n<A, B>(value:A, input:B):B return
        input;

}