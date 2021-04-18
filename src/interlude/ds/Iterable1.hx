package interlude.ds;

@:nullSafety(Strict)
@:publicFields
abstract Iterable1<A:NotVoid>(Pair<A, Iterable<A>>) from Pair<A, Iterable<A>> {
    var head(get, never):A;
    var tail(get, never):Iterable<A>;

    @:noCompletion function get_head():A return
        this._1;

    @:noCompletion function get_tail():Iterable<A> return
        this._2;

    inline public function new(it:Pair<A, Iterable<A>>)
        this = it;

    inline function first():A return
        this._1;

    function last():A return this._2.isEmpty()
        ? this._1
        : {
            var tmp = this._2.toArray();
            tmp[tmp.length - 1];
        }

    function iterator():Iterator<A> return {
        var idx = 0;
        var tail_it = this._2.iterator();
        {   hasNext : () -> idx == 0 || tail_it.hasNext()
        ,   next    : () -> idx++ == 0 ? this._1 : tail_it.next()
        }
    }

    @:to inline function toIterable():Iterable<A> return {
        iterator: iterator
    }

    @:to inline function toArray1():Array1<A> return
        new Array1<A>(this._1.with(this._2.toArray()));

    @:to inline function toArray():Array<A> return
        [for(a in iterator()) a];

    function flatMap1<B>(fn:A->Iterable1<B>):Iterable1<B> return
        fn(this._1).mut(tmp -> tmp.first()
            .with(tmp.tail
                .append(this._2
                    .flatMap(a -> fn(a).toIterable())))
            .asIterable1());

    function map1<B>(fn:A->B):Iterable1<B> return
        fn(this._1).with(this._2.mapL(fn)).asIterable1();

    function from(fst:A, ...rest:A):Array1<A> return
        new Iterable1(fst.with(cast rest.toArray()));

    static function iterable1With<A>(head:A, tail:Iterable<A>):Iterable1<A> return
        new Iterable1(head.with(tail));

    static function asIterable1<A>(as:Pair<A, Iterable<A>>):Iterable1<A> return
        as;
}