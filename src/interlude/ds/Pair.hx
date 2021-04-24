package interlude.ds;

typedef KeyValuePair<K:NotVoid, V:NotVoid>  = { key:K, value:V };

/**
    A type that holds two values; essentially a 2-Tuple. Can be used with 
    structure syntax.
    ```haxe
    abc.with(123) == { _1: abc, _2: 123 } == new Pair(abc, 123)
    ```
**/
@:nullSafety(Strict)
@:publicFields
@:structInit
class Pair<X:NotVoid, Y:NotVoid> {
    final _1:X;
    final _2:Y;

    public function new(_1:X, _2:Y) {
        this._1 = _1;
        this._2 = _2;
    }

    inline static function apply<A, B, Z>(t:Pair<A, B>, fn:(A, B)->Z):Z return
        fn(t._1, t._2);

    inline static function toKeyValue<A, B>(t:Pair<A, B>):KeyValuePair<A, B> return
        { key: t._1, value: t._2 };

    inline static function eval<A, Z>(t:Pair<A->Z, A>):Z return
        t._1(t._2);

    static function flip<A, B>(t:Pair<A, B>):Pair<B, A> return
        t._2.with(t._1);

    inline static function apply2<A, B, Z>(fn:(A, B)->Z, t:Pair<A, B>):Z return
        fn(t._1, t._2);

    inline static function apply2c<A, B, Z>(fn:A->(B->Z), t:Pair<A, B>):Z return
        fn(t._1)(t._2);

    static function map_1<A, B, Z>(t:Pair<A, B>, fn:A->Z):Pair<Z, B> return {
        _1: fn(t._1)
    ,   _2: t._2
    }

    static function map_2<A, B, Z>(t:Pair<A, B>, fn:B->Z):Pair<A, Z> return {
        _1: t._1
    ,   _2: fn(t._2)
    }

    inline static function fst<A>(tup:{final _1:A;}):A return
        tup._1;

    inline static function snd<A>(tup:{final _2:A;}):A return
        tup._2;

    inline static function with<A, B>(a:A, b:B):Pair<A, B> return
        { _1: a, _2: b };
}

/**
    A type that holds three values; essentially a 3-Tuple. Can be used with 
    structure syntax.
    ```haxe
    abc.with(123, Unit) == { _1: abc, _2: 123, _3: Unit } == new Pair(abc, 123, Unit)
    ```
**/
@:nullSafety(Strict)
@:publicFields
@:structInit
class Trio<X:NotVoid, Y:NotVoid, Z:NotVoid> {
    final _1:X;
    final _2:Y;
    final _3:Z;

    public function new(_1:X, _2:Y, _3:Z) {
        this._1 = _1;
        this._2 = _2;
        this._3 = _3;
    }

    inline static function apply<A, B, C, Z>(t:Trio<A, B, C>, fn:(A, B, C)->Z):Z return
        fn(t._1, t._2, t._3);

    inline static function eval<A, B, Z>(t:Trio<A->B->Z, A, B>):Z return
        t._1(t._2, t._3);

    inline static function apply3<A, B, C, Z>(fn:(A, B, C)->Z, t:Trio<A, B, C>):Z return
        fn(t._1, t._2, t._3);

    inline static function apply3c<A, B, C, Z>(fn:A->(B->(C->Z)), t:Trio<A, B, C>):Z return
        fn(t._1)(t._2)(t._3);

    static function map_1<A, B, C, Z>(t:Trio<A, B, C>, fn:A->Z):Trio<Z, B, C> return {
        _1: fn(t._1)
    ,   _2: t._2
    ,   _3: t._3
    }

    static function map_2<A, B, C, Z>(t:Trio<A, B, C>, fn:B->Z):Trio<A, Z, C> return {
        _1: t._1
    ,   _2: fn(t._2)
    ,   _3: t._3
    }

    static function map_3<A, B, C, Z>(t:Trio<A, B, C>, fn:C->Z):Trio<A, B, Z> return {
        _1: t._1
    ,   _2: t._2
    ,   _3: fn(t._3)
    }

    static function rotate<A, B, C>(t:Trio<A, B, C>):Trio<C, A, B> return
        t._3.with3(t._1, t._2);

    inline static function thd<A>(tup:{final _3:A;}):A return
        tup._3;

    //inline static function with<A, B, C>(b:Pair<A, B>, a:C):Trio<A, B, C> return
    //    { _1: b._1, _2: b._2, _3: a };

    inline static function with3<A, B, C>(a:A, b:B, c:C):Trio<A, B, C> return
        { _1: a, _2: b, _3: c };
}