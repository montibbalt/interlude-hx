package iter;

import utest.Assert;
import utest.ITest;

class TestIterable1 implements ITest {
    public function new() {}

    function testToArray() {
        var foo:Array<Int> = new Iterable1<Int>({_1: 1, _2:[2, 3, 4, 5, 6]});
        var bar:Array<Int> = new Iterable1<Int>({_1: 1, _2:[]});
        Assert.same([1, 2, 3, 4, 5, 6], foo);
        Assert.same([1], bar);
    }

    @:depends(testToArray)
    function testFrom() {
        var foo = Iterable1.from1(1, 2, 3, 4, 5, 6);
        var bar = Iterable1.from1(1);
        Assert.same([1, 2, 3, 4, 5, 6], foo.toArray());
        Assert.same([1], bar.toArray());
    }

    @:depends(testToArray)
    function testIterable1With() {
        var foo = 1.iterable1With([2, 3, 4, 5, 6]);
        var bar = 1.iterable1With([]);
        Assert.same([1, 2, 3, 4, 5, 6], foo.toArray());
        Assert.same([1], bar.toArray());
    }

    @:depends(testIterable1With)
    function testAsIterable1() {
        var foo = 1.with(2.asIterable(3, 4, 5, 6)).asIterable1();
        var bar = 1.with(IterableTools.empty()).asIterable1();
        Assert.same( 1.iterable1With([2, 3, 4, 5, 6]).toArray()
                   , foo.toArray());
        Assert.same( 1.iterable1With([]).toArray()
                   , bar.toArray());
    }

    @:depends(testIterable1With)
    function testMap1() {
        var foo = 1.iterable1With([2, 3, 4, 5, 6]);
        var bar = 1.iterable1With([]);
        var square = x -> x * x;

        Assert.same( 1.iterable1With([4, 9, 16, 25, 36]).toArray()
                   , foo.map1(square).toArray());
        Assert.same( 1.iterable1With([]).toArray()
                   , bar.map1(square).toArray());
    }

    @:depends(testIterable1With)
    function testFlatMap1() {
        var foo = 1.iterable1With([2, 3, 4, 5, 6]);
        var bar = 1.iterable1With([]);
        var duplicateSquare = x -> (x * x).iterable1With([x * x]);

        Assert.same( 1.iterable1With([1, 4, 4, 9, 9, 16, 16, 25, 25, 36, 36]).toArray()
                   , foo.flatMap1(duplicateSquare).toArray());
        Assert.same( 1.iterable1With([1]).toArray()
                   , bar.flatMap1(duplicateSquare).toArray());
    }

    @:depends(testIterable1With, testFlatMap1)
    function testFlatten() {
        var foo:Iterable1<Iterable1<Int>> = 1.iterable1With([2, 3]).iterable1With([4.iterable1With([5,6])]);
        var bar = 1.iterable1With([]).iterable1With([]);

        Assert.same(foo.flatMap1(identity), foo.flatten());
        Assert.same([1, 2, 3, 4, 5, 6], foo.flatten().toArray());
        Assert.same([1], bar.flatten().toArray());
    }

    @:depends(testIterable1With)
    function testFirstLast() {
        var foo = 1.iterable1With([2, 3, 4, 5, 6]);
        var bar = 1.iterable1With([]);

        Assert.equals(foo.head, foo.first());
        Assert.equals(1, foo.first());
        Assert.equals(1, bar.first());

        Assert.equals(6, foo.last());
        Assert.equals(1, bar.last());
    }
}