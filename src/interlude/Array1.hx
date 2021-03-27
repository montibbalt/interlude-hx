package interlude;

@:nullSafety(Strict)
abstract Array1<A:NotVoid>(Pair<A, Array<A>>) from Pair<A, Array<A>> {
    public var head(get, never):A;
    public var tail(get, never):Array<A>;
    function get_head():A return
        this._1;
    function get_tail():Array<A> return
        this._2;

    inline public function new(arr1:Pair<A, Array<A>>)
        this = arr1;

    inline public function first():A return
        this._1;

    public function last():A return this._2.length == 0
        ? this._1
        : this._2[this._2.length - 1];

    @:arrayAccess
    function get(index:Int):A return index == 0
        ? this._1
        : this._2[index - 1];

    @:arrayAccess
    function set(index:Int, value:A):A return index == 0
        ? this._1 = value
        : this._2[index - 1] = value;

    public function iterator():Iterator<A> return {
        var index = 0;
        var tailIter = this._2.iterator();
        {   hasNext : () -> index == 0 || tailIter.hasNext()
        ,   next    : () -> index++ == 0 ? this._1 : tailIter.next()
        };
    }

    @:to
    public function toIterable():Iterable<A> return {
        iterator: iterator
    }

    @:to
    public function toIterable1():Iterable1<A> return
        new Iterable1(this._1.with((this._2:Iterable<A>)));

    public function flatMap1<B>(fn:A->Array1<B>):Array1<B> return
        fn(this._1).mut(tmp -> tmp.first()
            .with(tmp.tail
                .append(this._2
                    .flatMap(a -> fn(a).toIterable()))
                .toArray())
            .asArray1());

    public function map1<B>(fn:A->B):Array1<B> return
        fn(this._1).with(this._2.mapL(fn).toArray()).asArray1();
}

@:publicFields
@:nullSafety(Strict)
class Array1Tools {
    static function array1With<A>(head:A, tail:Array<A>):Array1<A> return
        new Array1(head.with(tail));

    static function asArray1<A>(as:Pair<A, Array<A>>):Array1<A> return
        as;
}