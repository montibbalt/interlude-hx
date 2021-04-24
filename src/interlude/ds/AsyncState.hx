package interlude.ds;

import interlude.ds.Pair.fst;
import interlude.ds.Pair.snd;

//typedef AsyncState<X, A> = X -> Task<Pair<A, X>>;

/**
    A type of function that takes an initial state `X`, and asynchronously
    produces an output value `A` and a new state  
    @see https://en.wikibooks.org/wiki/Haskell/Understanding_monads/State
**/
@:nullSafety(Strict)
@:forward
@:callable
abstract AsyncState<X, A>(X->Task<Pair<A, X>>) from X->Task<Pair<A, X>> to X->Task<Pair<A, X>> {
    inline public function new(as:X->Task<Pair<A, X>>) this = as;
    
    public static function ap<X, A, B>(fn:AsyncState<X, A->B>, s:AsyncState<X, A>):AsyncState<X, B> return
        fn.flatMap(s.map);

    public static function asAsyncState<X, A>(a:A):AsyncState<X, A> return
        Task.asTask.of(a.with);

    public static function eval<X, A>(s:AsyncState<X, A>, x:X):Task<A> return
        s(x).map(fst);

    public static function filter<X, A>(s:AsyncState<X, A>, predicate:X->Bool):AsyncState<X, Option<A>> return
        sx -> predicate(sx)
            ? s(sx).map(pair -> pair.map_1(Some))
            : None.with(sx).asTask();

    public static function filterMap<X, A, B>(s:AsyncState<X, A>, predicate:X->Bool, fn:A->B):AsyncState<X, Option<B>> return
        sx -> predicate(sx)
            ? s(sx).map(pair -> pair.map_1(Some.of(fn)))
            : None.with(sx).asTask();

    public static function filterFMap<X, A, B>(s:AsyncState<X, A>, predicate:X->Bool, fn:A->AsyncState<X, B>):AsyncState<X, Option<B>> return
        sx -> predicate(sx)
            ? sx.let(s.flatMap(fn).map(Some))
            : None.with(sx).asTask();

    public static function flatMap<X, A, B>(s:AsyncState<X, A>, fn:A->AsyncState<X, B>):AsyncState<X, B> return
        sx -> s(sx).flatMap(fn.apply2c);

    public static function flatten<X, A>(s:AsyncState<X, AsyncState<X, A>>):AsyncState<X, A> return
        x -> s(x).flatMap(Pair.eval);

    public static function local<X, A>(s:AsyncState<X, A>, fn:X->X):AsyncState<X, A> return
        s.of(fn);

    public static function map<X, A, B>(s:AsyncState<X, A>, fn:A->B):AsyncState<X, B> return
        s.flatMap(asAsyncState.of(fn));

    public static function run<X, A>(s:AsyncState<X, A>, x:X):Task<X> return
        s(x).map(snd);

    public static function zip<X, A, B>(sa:AsyncState<X, A>, sb:AsyncState<X, B>):AsyncState<X, Pair<A, B>> return
        sa.zipWith(sb, Pair.with);

    public static function zipWith<X, A, B, Z>(sa:AsyncState<X, A>, sb:AsyncState<X, B>, fn:A->B->Z):AsyncState<X, Z> return
        x -> sa(x).zipWith(sb(x), (pa, pb) -> fn(pa._1, pb._1).with(x));

    public static function zipWith3<X, A, B, C, Z>(sa:AsyncState<X, A>, sb:AsyncState<X, B>, sc:AsyncState<X, C>, fn:A->B->C->Z):AsyncState<X, Z> return
        x -> sa(x).zipWith3(sb(x), sc(x), (pa, pb, pc) -> fn(pa._1, pb._1, pc._1).with(x));
}