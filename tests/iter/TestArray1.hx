package iter;

import utest.Assert;
import utest.ITest;

class TestArray1 implements ITest {
    public function new() {}

    function testToArray() {
        var foo:Array<Int> = new Array1<Int>({_1: 1, _2:[2, 3, 4, 5, 6]});
        var bar:Array<Int> = new Array1<Int>({_1: 1, _2:[]});
        Assert.same([1, 2, 3, 4, 5, 6], foo);
        Assert.same([1], bar);
    }

    @:depends(testToArray)
    function testFrom() {
        var foo = Array1.from1(1, 2, 3, 4, 5, 6);
        var bar = Array1.from1(1);
        Assert.same([1, 2, 3, 4, 5, 6], foo.toArray());
        Assert.same([1], bar.toArray());
    }

    @:depends(testToArray)
    function testArray1With() {
        var foo = 1.array1With([2, 3, 4, 5, 6]);
        var bar = 1.array1With([]);
        Assert.same([1, 2, 3, 4, 5, 6], foo.toArray());
        Assert.same([1], bar.toArray());
    }

    @:depends(testArray1With)
    function testAsArray1() {
        var foo = 1.with([2, 3, 4, 5, 6]).asArray1();
        var bar = 1.with([]).asArray1();
        Assert.same(1.array1With([2, 3, 4, 5, 6]), foo);
        Assert.same(1.array1With([]), bar);
    }

    @:depends(testArray1With)
    function testMap1() {
        var foo = 1.array1With([2, 3, 4, 5, 6]);
        var bar = 1.array1With([]);
        var square = x -> x * x;

        Assert.same(1.array1With([4, 9, 16, 25, 36]), foo.map1(square));
        Assert.same(1.array1With([]), bar.map1(square));
    }

    @:depends(testArray1With)
    function testFlatMap1() {
        var foo = 1.array1With([2, 3, 4, 5, 6]);
        var bar = 1.array1With([]);
        var duplicateSquare = x -> (x * x).array1With([x * x]);

        Assert.same( 1.array1With([1, 4, 4, 9, 9, 16, 16, 25, 25, 36, 36])
                   , foo.flatMap1(duplicateSquare));
        Assert.same(1.array1With([1]), bar.flatMap1(duplicateSquare));
    }

    @:depends(testArray1With, testFlatMap1)
    function testFlatten() {
        var foo:Array1<Array1<Int>> = 1.array1With([2, 3]).array1With([4.array1With([5,6])]);
        var bar = 1.array1With([]).array1With([]);

        Assert.same(foo.flatMap1(identity), foo.flatten());
        Assert.same([1, 2, 3, 4, 5, 6], foo.flatten().toArray());
        Assert.same([1], bar.flatten().toArray());
    }

    @:depends(testArray1With)
    function testArrayAccess() {
        var foo = 1.array1With([2, 3, 4, 5, 6]);
        var bar = 1.array1With([]);

        Assert.equals(4, foo[3]);
        Assert.equals(1, bar[0]);
        Assert.equals(null, bar[1]);

        foo[3] = 69;
        bar[3] = 69;

        Assert.equals(69, foo[3]);
        Assert.equals(69, bar[3]);
    }

    @:depends(testArray1With, testArrayAccess)
    function testFirstLast() {
        var foo = 1.array1With([2, 3, 4, 5, 6]);
        var bar = 1.array1With([]);

        Assert.equals(foo.head, foo.first());
        Assert.equals(foo[0], foo.first());
        Assert.equals(1, foo.first());
        Assert.equals(1, bar.first());

        Assert.equals(6, foo.last());
        Assert.equals(foo[5], foo.last());
        Assert.equals(1, bar.last());
    }
}