package interlude.ds.zippers;
/**
    A Zipper type for traversing a `List` in both directions.  
    NOTE: This implementation mutates the concrete List
    @see https://en.wikipedia.org/wiki/Zipper_(data_structure)
**/
@:nullSafety(Strict)
@:forward
abstract ListZipper<X>(Trio<List<X>, X, List<X>>) from Trio<List<X>, X, List<X>> to Trio<List<X>, X, List<X>> {
    public var focus(get, never):X;

    /** List elements to the left of the current `focus` **/
    public var facingLeft(get, never):List<X>;

    /** List elements to the right of the current `focus` **/
    public var facingRight(get, never):List<X>;

    /** Length from the current focus to the end of the list **/
    public var length(get, never):Int;

    /** Total length of the underlying list **/
    public var totalLength(get, never):Int;

    inline function get_focus():X return
        this._2;

    inline function get_facingLeft():List<X> return
        this._1;

    inline function get_facingRight():List<X> return
        this._3;

    inline function get_length():Int return
        1 + facingRight.length;

    inline function get_totalLength():Int return
        facingLeft.length + 1 + facingRight.length;

    public inline function new(t:Trio<List<X>, X, List<X>>) this = t;

    public function iterator():Iterator<X> return {
        var index = 0;
        var tailIter = facingRight.iterator();
        {   hasNext : () -> index == 0 || tailIter.hasNext()
        ,   next    : () -> index++ == 0 ? focus : tailIter.next()
        };
    }

    @:to public function toIterable():Iterable<X> return {
        iterator: iterator
    }

    public static function asZipper<A>(focus:A):ListZipper<A> return
        new List<A>().with3(focus, new List<A>());

    public static function from1<A>(focus:A, ...rest:A):ListZipper<A> return {
        var as = new List<A>();
        (rest:Iterable<A>).mutate(as.add);
        new List<A>().with3(focus, as);
    }

    public static function listZipperWith<A>(focus:A, right:List<A>):ListZipper<A> return
        new List<A>().with3(focus, right);

    /**
        Move the focus to the left one space, if possible.
    **/
    public static function left<A>(lz:ListZipper<A>):ListZipper<A> return lz._1.isEmpty()
        ? lz
        : {
            var focus2 = lz.facingLeft.pop();
            lz.facingRight.push(lz.focus);
            lz.facingLeft.with3(focus2, lz.facingRight);
        }

    /**
        Move the focus to the left one space, if possible.
    **/
    public static function right<A>(lz:ListZipper<A>):ListZipper<A> return lz._3.isEmpty()
        ? lz
        : {
            var focus2 = lz.facingRight.pop();
            lz.facingLeft.push(lz.focus);
            lz.facingLeft.with3(focus2, lz.facingRight);
        }

    /**
        Replace the value at the current focus.
    **/
    public static function update<A>(lz:ListZipper<A>, newValue:A):ListZipper<A> return
        lz.facingLeft.with3(newValue, lz.facingRight);
}