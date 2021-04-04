package interlude.reactive;

typedef Surprise<A> = Task<Outcome<A>>;

@:nullSafety(Strict)
@:publicFields
class SurpriseTools {
    static function ap<A, B>(ab:Surprise<A->B>, a:Surprise<A>):Surprise<B> return
        ab.flatMap(a.map);

    static function asSurprise<A>(value:A):Surprise<A> return
        value.asOutcome().asTask();

    static function filter<A>(s:Surprise<A>, predicate:A->Bool):Surprise<A> return
        TaskTools.map(s, o -> o.filter(predicate));

    static function flatMap<A, B>(s:Surprise<A>, fn:A->Surprise<B>):Surprise<B> return
        TaskTools.flatMap(s, o -> o.match(fn, (m, ?p) -> Failure(m, p).asTask()));

    static function map<A, B>(s:Surprise<A>, fn:A->B):Surprise<B> return
        TaskTools.map(s, o -> o.map(fn));

    static function mutate<A>(s:Surprise<A>, whenSuccess:A->Void, whenFailure:(message:String, ?pos:haxe.PosInfos)->Void):Surprise<A> return
        TaskTools.mutate(s, o -> o.mutate(whenSuccess, whenFailure));

    static function mutate_<A>(s:Surprise<A>, whenSuccess:A->Void):Surprise<A> return
        TaskTools.mutate(s, o -> o.mutate_(whenSuccess));

    static function zip<A, B>(sA:Surprise<A>, sB:Surprise<B>):Surprise<Pair<A, B>> return
        sA.zipWith(sB, PairTools.with);

    static function zipWith<A, B, C>(sA:Surprise<A>, sB:Surprise<B>, fn:A->B->C):Surprise<C> return
        TaskTools.zipWith(sA, sB, (oA, oB) -> oA.zipWith(oB, fn));
}