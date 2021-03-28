package interlude.ds;

typedef KeyValuePair<K:NotVoid, V:NotVoid>  = { key:K, value:V };
typedef Pair<X:NotVoid, Y:NotVoid> = { _1: X, _2: Y }
typedef Trio<X:NotVoid, Y:NotVoid, Z:NotVoid> = { _1: X, _2: Y, _3: Z }

@:nullSafety(Strict)
@:publicFields
class PairTools {
    inline static function apply<A, B, Z>(t:Pair<A, B>, fn:(A, B)->Z):Z return
        fn(t._1, t._2);

    inline static function toKeyValue<A, B>(t:Pair<A, B>):KeyValuePair<A, B> return
        { key: t._1, value: t._2 };

    inline static function fromN<A, B, Z>(fn:(A, B)->Z, t:Pair<A, B>):Z return
        fn(t._1, t._2);

    inline static function fromNC<A, B, Z>(fn:A->(B->Z), t:Pair<A, B>):Z return
        fn(t._1)(t._2);

    inline static function fst<A>(tup:{_1:A}):A return
        tup._1;

    inline static function snd<A>(tup:{_2:A}):A return
        tup._2;

    inline static function with<A, B>(a:A, b:B):Pair<A, B> return
        { _1: a, _2: b };
}

@:nullSafety(Strict)
@:publicFields
class TrioTools {
    inline static function apply<A, B, C, Z>(t:Trio<A, B, C>, fn:(A, B, C)->Z):Z return
        fn(t._1, t._2, t._3);

    inline static function fromN<A, B, C, Z>(fn:(A, B, C)->Z, t:Trio<A, B, C>):Z return
        fn(t._1, t._2, t._3);

    inline static function fromNC<A, B, C, Z>(fn:A->(B->(C->Z)), t:Trio<A, B, C>):Z return
        fn(t._1)(t._2)(t._3);

    inline static function thd<A>(tup:{_3:A}):A return
        tup._3;

    inline static function with<A, B, C>(b:Pair<A, B>, a:C):Trio<A, B, C> return
        { _1: b._1, _2: b._2, _3: a };

    inline static function with3<A, B, C>(a:A, b:B, c:C):Trio<A, B, C> return
        { _1: a, _2: b, _3: c };
}