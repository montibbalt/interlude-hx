package interlude.ds;

import interlude.ds.PairTools.fst;
import interlude.ds.PairTools.snd;

typedef AsyncState<X, A> = X -> Task<Pair<A, X>>;

@:nullSafety(Strict)
@:publicFields
class AsyncStateTools {
    static function ap<X, A, B>(fn:AsyncState<X, A->B>, s:AsyncState<X, A>):AsyncState<X, B> return
        fn.flatMap(s.map);

    static function asAsyncState<X, A>(a:A):AsyncState<X, A> return
        TaskTools.asTask.of(a.with);

    static function eval<X, A>(s:AsyncState<X, A>, x:X):Task<A> return
        s(x).map(fst);

    static function filter<X, A>(s:AsyncState<X, A>, predicate:X->Bool):AsyncState<X, Option<A>> return
        sx -> predicate(sx)
            ? s(sx).map(pair -> pair.map_1(Some))
            : None.with(sx).asTask();

    static function filterMap<X, A, B>(s:AsyncState<X, A>, predicate:X->Bool, fn:A->B):AsyncState<X, Option<B>> return
        sx -> predicate(sx)
            ? s(sx).map(pair -> pair.map_1(Some.of(fn)))
            : None.with(sx).asTask();

    static function filterFMap<X, A, B>(s:AsyncState<X, A>, predicate:X->Bool, fn:A->AsyncState<X, B>):AsyncState<X, Option<B>> return
        sx -> predicate(sx)
            ? sx.let(s.flatMap(fn).map(Some))
            : None.with(sx).asTask();

    static function flatMap<X, A, B>(s:AsyncState<X, A>, fn:A->AsyncState<X, B>):AsyncState<X, B> return
        sx -> s(sx).flatMap(fn.fromNC);

    static function flatten<X, A>(s:AsyncState<X, AsyncState<X, A>>):AsyncState<X, A> return
        x -> s(x).flatMap(PairTools.eval);

    static function local<X, A>(s:AsyncState<X, A>, fn:X->X):AsyncState<X, A> return
        s.of(fn);

    static function map<X, A, B>(s:AsyncState<X, A>, fn:A->B):AsyncState<X, B> return
        s.flatMap(asAsyncState.of(fn));

    static function run<X, A>(s:AsyncState<X, A>, x:X):Task<X> return
        s(x).map(snd);

    static function zip<X, A, B>(sa:AsyncState<X, A>, sb:AsyncState<X, B>):AsyncState<X, Pair<A, B>> return
        sa.zipWith(sb, PairTools.with);

    static function zipWith<X, A, B, Z>(sa:AsyncState<X, A>, sb:AsyncState<X, B>, fn:A->B->Z):AsyncState<X, Z> return
        x -> sa(x).zipWith(sb(x), (pa, pb) -> fn(pa._1, pb._1).with(x));

    static function zipWith3<X, A, B, C, Z>(sa:AsyncState<X, A>, sb:AsyncState<X, B>, sc:AsyncState<X, C>, fn:A->B->C->Z):AsyncState<X, Z> return
        x -> sa(x).zipWith3(sb(x), sc(x), (pa, pb, pc) -> fn(pa._1, pb._1, pc._1).with(x));
}