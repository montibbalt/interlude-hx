package interlude.ds;

/**
    Delays evaluation of a value until access to it is needed
    ```haxe
    var delayed = expensiveOperation.toLazy();
    trace(delayed.toString()); // 'Lazy<>'
    var expensiveResult = delayed.eval();
    trace(delayed.toString()); // expensiveResult
    ```
**/
@:nullSafety(Strict)
@:publicFields
class Lazy<A:NotVoid> {
    var result(default, null):Null<A> = null;
    var genValue(default, null):() -> A;
    function new(genValue:() -> A) {
        this.genValue = genValue;
    }

    inline function eval():A return result != null
        ? result
        : result = genValue();

    function iterator():Iterator<A> return {
        hasNext : () -> result == null
    ,   next    : () -> eval()
    }

    function toString():String return result != null
        ? '$result'
        : 'Lazy<>';

    inline static function any<A>(l:Lazy<A>):Bool return
        l.result != null;

    static function ap<A, B>(fn:Lazy<A->B>, a:Lazy<A>):Lazy<B> return
        flatMap(fn, a.map);

    inline static function asLazy<A>(a:A):Lazy<A> return
        new Lazy<A>(a.identity);

    static function flatMap<A, B>(l:Lazy<A>, fn:A->Lazy<B>):Lazy<B> return
        new Lazy<B>(() -> l.eval().let(fn).eval());

    static function flatten<A>(l:Lazy<Lazy<A>>):Lazy<A> return
        new Lazy<A>(() -> l.eval().eval());

    static function map<A, B>(l:Lazy<A>, fn:A->B):Lazy<B> return
        new Lazy(() -> l.eval().let(fn));

    inline static function mutate<A>(l:Lazy<A>, mutator:A->Void):Lazy<A> return {
        l.eval().mut(mutator);
        l;
    }

    inline static function mutate_<A>(l:Lazy<A>, whenEval:A->Void):Lazy<A> return {
        if(l.result != null)
            whenEval(l.result);
        l;
    }

    static function toArray<A>(l:Lazy<A>):Array<A> return
        [l.eval()];

    inline static function zip<A, B>(la:Lazy<A>, lb:Lazy<B>):Lazy<Pair<A, B>> return
        zipWith(la, lb, Pair.with);

    static function zipWith<A, B, C>(la:Lazy<A>, lb:Lazy<B>, fn:A->B->C):Lazy<C> return
        new Lazy(() -> fn(la.eval(), lb.eval()));
}