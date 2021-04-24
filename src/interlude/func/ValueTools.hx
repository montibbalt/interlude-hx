package interlude.func;

/** Named functions for `Int` operators **/
@:nullSafety(Strict)
@:publicFields
class IntTools {
    /** Adds two Ints **/
    inline static function add(a:Int, b:Int) return
        a + b;

    /** Adds 1 to an Int **/
    inline static function add1(n:Int):Int return
        n + 1;

    /** Subtracts `b` from `a` **/
    inline static function sub(a:Int, b:Int) return
        a - b;

    /** Subtracts 1 from an Int **/
    inline static function sub1(n:Int):Int return
        n - 1;

    /** Multiplies two Ints **/
    inline static function mul(a:Int, b:Int):Int return
        a * b;

    /** Divides `a` by `b` **/
    inline static function div(a:Int, b:Int):Float return
        a / b;

    inline static function isEven(n:Int):Bool return
        n % 2 == 0;

    inline static function isOdd(n:Int):Bool return
        n % 2 != 0;
}

/** Named functions for `Float` operators **/
@:nullSafety(Strict)
@:publicFields
class FloatTools {
    /** Adds two Floats **/
    inline static function add(a:Float, b:Float) return
        a + b;

    /** Adds 1.0 to a Float **/
    inline static function add1(n:Float):Float return
        n + 1.0;

    /** Subtracts `b` from `a` **/
    inline static function sub(a:Float, b:Float) return
        a - b;

    /** Subtracts 1.0 from a Float **/
    inline static function sub1(n:Float):Float return
        n - 1.0;

    /** Multiplies two Floats **/
    inline static function mul(a:Float, b:Float):Float return
        a * b;

    /** Divides `a` by `b` **/
    inline static function div(a:Float, b:Float):Float return
        a / b;
}

/**
    Common functions that are useful for any type
**/
@:nullSafety(Strict)
@:publicFields
class ValueTools {
    //inline static function branch<A, B>(value:A, predicate:A->Bool, whenTrue:A->B, whenFalse:A->B):B return
    //    predicate(value) ? whenTrue(value) : whenFalse(value);

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
        ```haxe
        Some(123).map(identity) == Some(123);
        ```
    **/
    inline static function identity<A>(a:A):A return
        a;

    /**
        Composable way to create a Key/Value pair  
        ```haxe
        "abc".keyedWith(123) == { key: 123, value: "abc" };
        ```
    **/
    inline static function keyedWith<K, V>(value:V, key:K):KeyValuePair<K, V> return
        { key: key, value: value };

    /**
        Composable way to create a Key/Value pair  
        ```haxe
        123.keyFor("abc") == { key: 123, value: "abc" };
        ```
    **/
    inline static function keyFor<K, V>(key:K, value:V):KeyValuePair<K, V> return
        value.keyedWith(key);

    /**
        Fluent method for transforming a value  
        Similar to `map` but for any value  
        ```haxe
        123.let(Std.string) == "123";
        ```
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
        ```haxe
        69.v_("nice") == 69;
        ```
    **/
    static function v_<A, B>(value:A, input:B):A return
        value;

    /**
        An extension that always returns some input and drops the original value  
        ```haxe
        69._n("nice") == "nice";
        ```
    **/
    static function _n<A, B>(value:A, input:B):B return
        input;

}