package interlude.ds;

/**
    An array that is guaranteed to have at least one element
**/
@:nullSafety(Strict)
@:forward
abstract Array1<A:NotVoid>(Pair<A, Array<A>>) from Pair<A, Array<A>> to Pair<A, Array<A>> {
    public var head(get, never):A;
    public var tail(get, never):Array<A>;
    public var length(get, never):Int;

    inline function get_head():A return
        this._1;

    inline function get_tail():Array<A> return
        this._2;

    inline function get_length():Int return
        this._2.length + 1;

    inline public function new(arr1:Pair<A, Array<A>>)
        this = arr1;

    inline public function first():A return
        this._1;

    public function last():A return this._2.length == 0
        ? this._1
        : this._2[this._2.length - 1];

    @:arrayAccess function get(index:Int):A return index == 0
        ? this._1
        : this._2[index - 1];

    @:arrayAccess inline function set(index:Int, value:A):A return index == 0
        ? (this = value.with(this._2))._1
        : this._2[index - 1] = value;

    public function iterator():Iterator<A> return {
        var index = 0;
        var tailIter = this._2.iterator();
        {   hasNext : () -> index == 0 || tailIter.hasNext()
        ,   next    : () -> index++ == 0 ? this._1 : tailIter.next()
        };
    }


    @:to inline public function toArray():Array<A> return [
        for(a in iterator())
            a
    ];

    @:to public function toIterable():Iterable<A> return {
        iterator: iterator
    }

    @:to public function toIterable1():Iterable1<A> return
        new Iterable1(this._1.with((this._2:Iterable<A>)));
    @:from static function fromIterable1<A>(as:Iterable1<A>):Array1<A> return
        as;

    public function flatMap1<B>(fn:A->Array1<B>):Array1<B> return
        head.let(fn).let(mapped -> tail
            .flatMap(x -> fn(x))
            .let(mapped.tail.append)
            .toArray()
            .let(mapped.head.array1With));

    public function map1<B>(fn:A->B):Array1<B> return
        head.let(fn)
            .array1With(tail.mapL(fn).toArray());

    public static function flatten<A>(aas:Array1<Array1<A>>):Array1<A> return
        aas.head.head
            .array1With(aas.head.tail
                .append(aas.tail.flatMap(as -> (as:Iterable<A>)))
                .toArray());

    public static function from1<A>(fst:A, ...rest:A):Array1<A> return
        new Array1(fst.with(rest.toArray()));

    public static function array1With<A>(head:A, tail:Array<A>):Array1<A> return
        new Array1(head.with(tail));

    public static function asArray1<A>(as:Pair<A, Array<A>>):Array1<A> return
        as;
}