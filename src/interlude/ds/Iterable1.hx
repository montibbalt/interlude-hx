package interlude.ds;

/**
    An `Iterable` that is guaranteed to have at least one element
**/
@:nullSafety(Strict)
@:forward
abstract Iterable1<A:NotVoid>(Pair<A, Iterable<A>>) from Pair<A, Iterable<A>> to Pair<A, Iterable<A>> {
    public var head(get, never):A;
    public var tail(get, never):Iterable<A>;

    inline function get_head():A return
        this._1;

    inline function get_tail():Iterable<A> return
        this._2;

    inline public function new(it:Pair<A, Iterable<A>>)
        this = it;

    inline public function first():A return
        this._1;

    public function last():A return this._2.isEmpty()
        ? this._1
        : {
            var tmp = this._2.toArray();
            tmp[tmp.length - 1];
        }

    public function iterator():Iterator<A> return {
        var idx = 0;
        var tail_it = this._2.iterator();
        {   hasNext : () -> idx == 0 || tail_it.hasNext()
        ,   next    : () -> idx++ == 0 ? this._1 : tail_it.next()
        }
    }

    @:to inline public function toIterable():Iterable<A> return {
        iterator: iterator
    }

    @:to inline public function toArray1():Array1<A> return
        new Array1<A>(this._1.with(this._2.toArray()));
    @:from static function fromArray1<A>(as:Array1<A>):Iterable1<A> return
        as;

    @:to inline public function toArray():Array<A> return [
        for(a in iterator())
            a
    ];

    public function flatMap1<B>(fn:A->Iterable1<B>):Iterable1<B> return
        head.let(fn).let(mapped -> tail
            .flatMap(x -> fn(x).toIterable())
            .let(mapped.tail.append)
            .let(mapped.head.iterable1With));

    public function map1<B>(fn:A->B):Iterable1<B> return
        head.let(fn)
            .iterable1With(tail.mapL(fn));

    public static function flatten<A>(aas:Iterable1<Iterable1<A>>):Iterable1<A> return
        aas.head.head
            .iterable1With(aas.head.tail
                .append(aas.tail.flatMap(as -> as.toIterable())));

    public static function from1<A>(fst:A, ...rest:A):Iterable1<A> return
        new Iterable1(fst.with((rest.toArray():Iterable<A>)));

    public static function iterable1With<A>(head:A, tail:Iterable<A>):Iterable1<A> return
        new Iterable1(head.with(tail));

    public static function asIterable1<A>(as:Pair<A, Iterable<A>>):Iterable1<A> return
        as;
}