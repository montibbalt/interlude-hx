package interlude.ds;

//typedef State<X, A> = X -> Pair<A, X>;

@:nullSafety(Strict)
@:forward
@:callable
abstract State<X, A>(X->Pair<A, X>) from X->Pair<A, X> to X->Pair<A, X> {
    inline public function new(s:X->Pair<A, X>) this = s;

    public static function ap<X, A, B>(fn:State<X, A->B>, s:State<X, A>):State<X, B> return
        fn.flatMap(s.map);

    public static inline function asState<X, A>(a:A):State<X, A> return
        a.with;

    public static function eval<X, A>(s:State<X, A>, x:X):A return
        s(x)._1;

    public static function filter<X, A>(s:State<X, A>, predicate:X->Bool):State<X, Option<A>> return
        sx -> predicate(sx)
            ? s(sx).map_1(Some)
            : None.with(sx);

    public static function filterMap<X, A, B>(s:State<X, A>, predicate:X->Bool, fn:A->B):State<X, Option<B>> return
        sx -> predicate(sx)
            ? s(sx).map_1(Some.of(fn))
            : None.with(sx);

    public static function filterFMap<X, A, B>(s:State<X, A>, predicate:X->Bool, fn:A->State<X, B>):State<X, Option<B>> return
        sx -> predicate(sx)
            ? sx.let(s.flatMap(fn).map(Some))
            : None.with(sx);

    public static function flatMap<X, A, B>(s:State<X, A>, fn:A->State<X, B>):State<X, B> return
        s.to(fn.apply2c);

    public static function flatten<X, A>(s:State<X, State<X, A>>):State<X, A> return
        s.to(Pair.eval);

    public static function local<X, A>(s:State<X, A>, fn:X->X):State<X, A> return
        s.of(fn);

    public static function map<X, A, B>(s:State<X, A>, fn:A->B):State<X, B> return
        s.flatMap(asState.of(fn));

    public static function run<X, A>(s:State<X, A>, x:X):X return
        s(x)._2;

    public static function zip<X, A, B>(sa:State<X, A>, sb:State<X, B>):State<X, Pair<A, B>> return
        sa.zipWith(sb, Pair.with);

    public static function zipWith<X, A, B, Z>(sa:State<X, A>, sb:State<X, B>, fn:A->B->Z):State<X, Z> return x -> {
        var a = sa(x);
        var b = sb(a._2);
        fn(a._1, b._1).with(b._2);
    }

    public static function zipWith3<X, A, B, C, Z>(sa:State<X, A>, sb:State<X, B>, sc:State<X, C>, fn:A->B->C->Z):State<X, Z> return x -> {
        var a = sa(x);
        var b = sb(a._2);
        var c = sc(b._2);
        fn(a._1, b._1, c._1).with(c._2);
    }
}