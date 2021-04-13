package interlude.ds;

typedef State<X, A> = X -> Pair<A, X>;

@:nullSafety(Strict)
@:publicFields
class StateTools {
    static function ap<X, A, B>(fn:State<X, A->B>, s:State<X, A>):State<X, B> return
        fn.flatMap(s.map);

    static inline function asState<X, A>(a:A):State<X, A> return
        a.with;

    static function eval<X, A>(s:State<X, A>, x:X):A return
        s(x)._1;

    static function filter<X, A>(s:State<X, A>, predicate:X->Bool):State<X, Option<A>> return
        sx -> predicate(sx)
            ? s(sx).map_1(Some)
            : None.with(sx);

    static function filterMap<X, A, B>(s:State<X, A>, predicate:X->Bool, fn:A->B):State<X, Option<B>> return
        sx -> predicate(sx)
            ? s(sx).map_1(Some.of(fn))
            : None.with(sx);

    static function filterFMap<X, A, B>(s:State<X, A>, predicate:X->Bool, fn:A->State<X, B>):State<X, Option<B>> return
        sx -> predicate(sx)
            ? sx.let(s.flatMap(fn).map(Some))
            : None.with(sx);

    static function flatMap<X, A, B>(s:State<X, A>, fn:A->State<X, B>):State<X, B> return
        s.to(fn.fromNC);

    static function flatten<X, A>(s:State<X, State<X, A>>):State<X, A> return
        s.to(PairTools.eval);

    static function local<X, A>(s:State<X, A>, fn:X->X):State<X, A> return
        s.of(fn);

    static function map<X, A, B>(s:State<X, A>, fn:A->B):State<X, B> return
        s.flatMap(asState.of(fn));

    static function run<X, A>(s:State<X, A>, x:X):X return
        s(x)._2;

    static function zip<X, A, B>(sa:State<X, A>, sb:State<X, B>):State<X, Pair<A, B>> return
        sa.zipWith(sb, PairTools.with);

    static function zipWith<X, A, B, Z>(sa:State<X, A>, sb:State<X, B>, fn:A->B->Z):State<X, Z> return
        x -> fn(sa(x)._1, sb(x)._1).with(x);

    static function zipWith3<X, A, B, C, Z>(sa:State<X, A>, sb:State<X, B>, sc:State<X, C>, fn:A->B->C->Z):State<X, Z> return
        x -> fn(sa(x)._1, sb(x)._1, sc(x)._1).with(x);
}