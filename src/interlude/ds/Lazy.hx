package interlude.ds;

@:nullSafety(Strict)
class Lazy<A:NotVoid> {
    @:allow(interlude.ds)
    var result:Null<A> = null;
    var genValue:() -> A;
    public function new(genValue:() -> A) {
        this.genValue = genValue;
    }

    inline public function eval():A return result != null
        ? result
        : result = genValue();


    public function toIterable():Iterable<A> return result != null
        ? [result]
        : { iterator: () -> { hasNext   : () -> result == null
                            , next      : () -> eval()
                            }
          }

    public function toString():String return result != null
        ? '$result'
        : 'Lazy<>';

    inline static function any<A>(l:Lazy<A>):Bool return
        l.result != null;

    static function ap<A, B>(fn:Lazy<A->B>, a:Lazy<A>):Lazy<B> return
        fn.flatMap(a.map);

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
        la.zipWith(lb, Pair.with);

    static function zipWith<A, B, C>(la:Lazy<A>, lb:Lazy<B>, fn:A->B->C):Lazy<C> return
        new Lazy(() -> fn(la.eval(), lb.eval()));
}