package interlude.ds;

typedef KeyValuePair<K:NotVoid, V:NotVoid>  = { key:K, value:V };

@:publicFields
@:structInit
class TPair<X:NotVoid, Y:NotVoid> { final _1:X; final _2:Y; }

@:publicFields
@:structInit
class TTrio<X:NotVoid, Y:NotVoid, Z:NotVoid> { final _1:X; final _2:Y; final _3:Z; }

@:nullSafety(Strict)
@:forward
abstract Pair<X, Y>(TPair<X, Y>) from TPair<X, Y> to TPair<X, Y> {
    inline public function new(pair:TPair<X, Y>) this = pair;

    inline public static function apply<A, B, Z>(t:Pair<A, B>, fn:(A, B)->Z):Z return
        fn(t._1, t._2);

    inline public static function toKeyValue<A, B>(t:Pair<A, B>):KeyValuePair<A, B> return
        { key: t._1, value: t._2 };

    inline public static function eval<A, Z>(t:Pair<A->Z, A>):Z return
        t._1(t._2);

    inline public static function fromN<A, B, Z>(fn:(A, B)->Z, t:Pair<A, B>):Z return
        fn(t._1, t._2);

    inline public static function fromNC<A, B, Z>(fn:A->(B->Z), t:Pair<A, B>):Z return
        fn(t._1)(t._2);

    public static function map_1<A, B, Z>(t:Pair<A, B>, fn:A->Z):Pair<Z, B> return {
        _1: fn(t._1)
    ,   _2: t._2
    }

    public static function map_2<A, B, Z>(t:Pair<A, B>, fn:B->Z):Pair<A, Z> return {
        _1: t._1
    ,   _2: fn(t._2)
    }

    inline public static function fst<A>(tup:{final _1:A;}):A return
        tup._1;

    inline public static function snd<A>(tup:{final _2:A;}):A return
        tup._2;

    inline public static function with<A, B>(a:A, b:B):Pair<A, B> return
        { _1: a, _2: b };
}


@:nullSafety(Strict)
@:forward
abstract Trio<X, Y, Z>(TTrio<X, Y, Z>) from TTrio<X, Y, Z> to TTrio<X, Y, Z> {
    inline public function new(trio:TTrio<X, Y, Z>) this = trio;

    inline public static function apply<A, B, C, Z>(t:Trio<A, B, C>, fn:(A, B, C)->Z):Z return
        fn(t._1, t._2, t._3);

    inline public static function eval<A, B, Z>(t:Trio<A->B->Z, A, B>):Z return
        t._1(t._2, t._3);

    inline public static function fromN<A, B, C, Z>(fn:(A, B, C)->Z, t:Trio<A, B, C>):Z return
        fn(t._1, t._2, t._3);

    inline public static function fromNC<A, B, C, Z>(fn:A->(B->(C->Z)), t:Trio<A, B, C>):Z return
        fn(t._1)(t._2)(t._3);

    public static function map_1<A, B, C, Z>(t:Trio<A, B, C>, fn:A->Z):Trio<Z, B, C> return {
        _1: fn(t._1)
    ,   _2: t._2
    ,   _3: t._3
    }

    public static function map_2<A, B, C, Z>(t:Trio<A, B, C>, fn:B->Z):Trio<A, Z, C> return {
        _1: t._1
    ,   _2: fn(t._2)
    ,   _3: t._3
    }

    public static function map_3<A, B, C, Z>(t:Trio<A, B, C>, fn:C->Z):Trio<A, B, Z> return {
        _1: t._1
    ,   _2: t._2
    ,   _3: fn(t._3)
    }

    inline public static function thd<A>(tup:{final _3:A;}):A return
        tup._3;

    //inline public static function with<A, B, C>(b:Pair<A, B>, a:C):Trio<A, B, C> return
    //    { _1: b._1, _2: b._2, _3: a };

    inline public static function with3<A, B, C>(a:A, b:B, c:C):Trio<A, B, C> return
        { _1: a, _2: b, _3: c };
}