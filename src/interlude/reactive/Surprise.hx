package interlude.reactive;

/**
    A type that represents an asyncronous operation that can fail. Analogous to
    a `Promise`. Since this is based on `interlude.reactive.Task`, it has the
    same resolution requirements.
**/
@:using(interlude.reactive.Surprise.SurpriseTools)
typedef Surprise<A> = Task<Outcome<A>>;

@:nullSafety(Strict)
@:publicFields
class SurpriseTools {
    static function ap<A, B>(ab:Surprise<A->B>, a:Surprise<A>):Surprise<B> return
        ab.flatMap(a.map);

    static function asSurprise<A>(value:A):Surprise<A> return
        value.asOutcome().asTask();

    static function filter<A>(s:Surprise<A>, predicate:A->Bool):Surprise<A> return
        Task.map(s, o -> o.filter(predicate));

    static function flatMap<A, B>(s:Surprise<A>, fn:A->Surprise<B>):Surprise<B> return
        Task.flatMap(s, o -> o.match(fn, (m, ?p) -> Failure(m, p).asTask()));

    static function map<A, B>(s:Surprise<A>, fn:A->B):Surprise<B> return
        Task.map(s, o -> o.map(fn));

    static function mutate<A>(s:Surprise<A>, whenSuccess:A->Void, whenFailure:(message:String, ?pos:haxe.PosInfos)->Void):Surprise<A> return
        Task.mutate(s, o -> o.mutate(whenSuccess, whenFailure));

    static function mutate_<A>(s:Surprise<A>, whenSuccess:A->Void):Surprise<A> return
        Task.mutate(s, o -> o.mutate_(whenSuccess));

    static function zip<A, B>(sA:Surprise<A>, sB:Surprise<B>):Surprise<Pair<A, B>> return
        sA.zipWith(sB, Pair.with);

    static function zipWith<A, B, C>(sA:Surprise<A>, sB:Surprise<B>, fn:A->B->C):Surprise<C> return
        Task.zipWith(sA, sB, (oA, oB) -> oA.zipWith(oB, fn));
}