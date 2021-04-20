package interlude.reactive;

@:nullSafety(Strict)
@:publicFields
class Observable<A:NotVoid> {
    var subscribers(default, null):Array<A->Void> = [];
    var lastDispatched(default, null):Option<A> = None;

    function new(?initial:A)
        if(initial != null) {
            lastDispatched = initial.asOption();
        }

    function mutate(fn:A->Void, last:Bool = true):Observable<A> return {
        subscribers.push(fn);
        if(last) lastDispatched.mutate_(fn);
        this;
    }

    function resolve(value:A):A return {
        Task.runner.queueMany([for(fn in subscribers) fn.bind(value)]);
        lastDispatched = value.asOption();
        value;
    }

    static function always<A, B>(o:Observable<A>, value:B):Observable<B> return
        o.map(value.v_);

    static function ap<A, B>(o:Observable<A->B>, as:Observable<A>):Observable<B> return
        o.flatMap(as.map);

    inline static function asObservable<X>(value:X):Observable<X> return
        new Observable(value);

    static function filter<A>(o:Observable<A>, predicate:A->Bool):Observable<A> return
        o.mutate(new Observable<A>().resolve.when(predicate));

    static function filterMap<A, B>(o:Observable<A>, predicate:A->Bool, fn:A->B):Observable<B> return {
        var stream = new Observable<B>();
        o.mutate(a -> if(predicate(a)) stream.resolve(fn(a)));
        stream;
    }

    static function filterFMap<A, B>(o:Observable<A>, predicate:A->Bool, fn:A->Task<B>):Observable<B> return {
        var stream = new Observable<B>();
        o.mutate(a -> if(predicate(a)) fn(a).mutate(stream.resolve));
        stream;
    }

    static function flatMap<A, B>(o:Observable<A>, fn:A->Observable<B>):Observable<B> return {
        var stream = new Observable<B>();
        o.mutate(a -> fn(a).mutate(stream.resolve));
        stream;
    }

    static function flatten<A>(oo:Observable<Observable<A>>):Observable<A> return
        oo.flatMap(identity);

    static function map<A, B>(o:Observable<A>, fn:A->B):Observable<B> return inline
        o.flatMap(fn.to(asObservable));

    static function replay<A>(o:Observable<A>):Void
        o.lastDispatched.mutate_(o.resolve);

    static function unit<A>(o:Observable<A>):Observable<Unit> return inline
        o.always(Unit);

    static function zip<A, B>(sA:Observable<A>, sB:Observable<B>):Observable<Pair<A, B>> return
        sA.zipWith(sB, Pair.with);

    static function zipWith<A, B, C>(sA:Observable<A>, sB:Observable<B>, fn:A->B->C):Observable<C> return {
        var stream = new Observable<C>();
        sA.mutate(a -> sB.lastDispatched.mutate_(b -> fn(a, b).mut(stream.resolve)));
        sB.mutate(b -> sA.lastDispatched.mutate_(a -> fn(a, b).mut(stream.resolve)));
        stream;
    }

}