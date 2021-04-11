package iter;

import utest.Assert;
import utest.ITest;

class TestIterableTools implements ITest {
    public function new() {}

    function testAll() {
        Assert.isTrue([true, true, true].all(identity));
        Assert.isFalse([true, true, false].all(identity));
    }

    function testAll2() {
        var foo = [1, 2, 3];
        Assert.isTrue(foo.all2(foo, equals));

        var bar = [4, 5, 6];
        Assert.isFalse(foo.all2(bar, equals));
    }

    function testAnd() {
        Assert.isTrue([true, true, true].and());
        Assert.isFalse([true, true, false].and());
        Assert.isTrue([].and());
    }

    function testAny() {
        Assert.isTrue([123].any());
        Assert.isFalse([].any());
    }

    function testAnyMatch() {
        Assert.isTrue([true].anyMatch(identity));
        Assert.isFalse([false].anyMatch(identity));
        Assert.isFalse([].anyMatch(identity));
    }

    function testAp() {
        var foo = [ identity
                  ].ap([1, 2, 3]);
        Assert.same([1, 2, 3], foo.toArray());

        var bar = [ a -> b -> a + b
                  ].ap([1, 2, 3])
                   .ap([4, 5, 6]);
        Assert.same( [ 1+4, 1+5, 1+6
                     , 2+4, 2+5, 2+6
                     , 3+4, 3+5, 3+6 ]
                   , bar.toArray());

        var baz = [ a -> b -> a + b
                  , a -> b -> a - b
                  ].ap([1, 2])
                   .ap([3, 4]);
        Assert.same( [ 1+3, 1+4, 2+3, 2+4
                     , 1-3, 1-4, 2-3, 2-4 ]
                   , baz.toArray());
    }

    function testAppend() {
        var foo = [1, 2, 3];
        var bar = [4, 5, 6];
        Assert.same([1, 2, 3, 4, 5, 6], foo.append(bar).toArray());
    }

    function testAsIterable() {
        Assert.same([123], 123.asIterable().toArray());
    }

    function testAtWrappedIndex() {
        var empty = [];
        var three = ['a', 'b', 'c'];
        Assert.same(None        , empty.atWrappedIndex(0));
        Assert.same(Some('a')   , three.atWrappedIndex(0));
        Assert.same(Some('b')   , three.atWrappedIndex(10));
        Assert.same(None        , three.atWrappedIndex(-1));
    }

    function testChoice() {
        var empty = [];
        var singl = ['a'];
        var three = ['a', 'b', 'c'];

        // choiceStd uses Math.random as its generator
        Assert.same(None        , empty.choiceStd());
        Assert.same(Some('a')   , singl.choiceStd());
        Assert.same(None        , empty.choice(() -> 1.0));
        Assert.same(Some('a')   , three.choice(() -> 0.0));
        Assert.same(Some('b')   , three.choice(() -> 0.5));
        Assert.same(Some('c')   , three.choice(() -> 1.0));
        Assert.same(Some('a')   , three.choice(() -> -2.));
        Assert.same(Some('c')   , three.choice(() -> 2.0));
    }

    function testChoiceComplexCase() {
        var heads = 'H';
        var tails = 'T';
        var toDraw = 1000000;
        var sig = toDraw * 0.0005;
        var lowerBound = toDraw * 0.5 - sig;
        var upperBound = toDraw * 0.5 + sig;
        var dist:Weighted<Weighted<String>> = [
            new Weighted([heads.with(25.0), tails.with(75.0)]).with(1.0)
        ,   new Weighted([heads.with(75.0), tails.with(25.0)]).with(1.0)
        ];

        var results = [for(n in 0...toDraw) dist.flatten().draw(Math.random)];

        var numHeads = results.filter(x -> x == heads).length;
        Assert.isTrue(lowerBound <= numHeads && numHeads <= upperBound
                     , 'Expected value $lowerBound <= $numHeads <= $upperBound');
    }

    function testCons() {
        var foo = 1.cons([2, 3]);
        Assert.same([1, 2, 3], foo.toArray());
        Assert.same(1.asIterable().toArray(), 1.cons([]).toArray());
    }

    function testContains() {
        var empty = [];
        var singl = [1];

        Assert.isFalse(empty.contains(1));
        Assert.isFalse(singl.contains(2));
        Assert.isTrue(singl.contains(1));
    }

    function testCount() {
        Assert.equals(0, [].count());
        Assert.equals(3, [1, 2, 3].count());
    }

    function testCycle() {
        var empty = [];
        var ten = [1, 2, 3].cycle().take(10);
        Assert.same(empty, empty.cycle());
        Assert.same([1, 2, 3, 1, 2, 3, 1, 2, 3, 1], ten.toArray());
    }

    function testElementAt() {
        var empty = [];
        var three = ['a', 'b', 'c'];

        Assert.same(None        , empty.elementAt(0));
        Assert.same(Some('b')   , three.elementAt(1));
        Assert.same(None        , three.elementAt(100));
        Assert.same(None        , three.elementAt(-1));
    }

    function testEnumerate() {
        var empty = [];
        var three = ['a', 'b', 'c'];
        Assert.same(empty, empty.enumerate().toArray());
        Assert.same( [ 0.with('a')
                     , 1.with('b')
                     , 2.with('c')]
                   , three.enumerate().toArray());
    }

    function testEvery() {
        var empty = [];
        var seven = [1, 2, 3, 4, 5, 6, 7];
        Assert.same(empty, empty.every(1).toArray());
        Assert.same( [ [1, 2, 3]
                     , [4, 5 ,6]
                     , [7]]
                   , seven.every(3).toArray().map(x -> x.toArray()));
        Assert.same(empty, seven.every(0).toArray());
        Assert.same(empty, seven.every(-1).toArray());
    }

    function testExcept() {
        var empty = [];
        var three = [1, 2, 3];
        Assert.same(empty   , empty.except(2).toArray());
        Assert.same(empty   , empty.excepts(empty).toArray());
        Assert.same(empty   , empty.excepts([2]).toArray());
        Assert.same([1, 3]  , three.except(2).toArray());
        Assert.same(three   , three.excepts(empty).toArray());
        Assert.same([2]     , three.excepts([1, 3]).toArray());
    }

    function testFilterL() {
        var empty = [];
        var trues = [true, true, true];
        var fail1 = [true, false, true];

        Assert.same(empty           , empty.filterL(identity).toArray());
        Assert.same(trues           , trues.filterL(identity).toArray());
        Assert.same([true, true]    , fail1.filterL(identity).toArray());
    }

    function testFilterMap() {
        var empty = [];
        var trues = [true, true, true];
        var falss = [false, false, false];
        var fail1 = [true, false, true];
        Assert.same(empty           , empty.filterMap(identity, notb).toArray());
        Assert.same(falss           , trues.filterMap(identity, notb).toArray());
        Assert.same([false, false]  , fail1.filterMap(identity, notb).toArray());
    }

    function testFilterFMap() {
        var empty = [];
        var trues = [true, true, true];
        var falss = [false, false, false];
        var fail1 = [true, false, true];

        var twice = x -> [x, x];

        Assert.same( empty
                   , empty.filterFMap(identity, twice).toArray());
        Assert.same( [true, true, true, true, true, true]
                   , trues.filterFMap(identity, twice).toArray());
        Assert.same(empty, falss.filterFMap(identity, twice).toArray());
        Assert.same( [true, true, true, true]
                   , fail1.filterFMap(identity, twice).toArray());
    }

    function testFirstOrDefault() {
        var empty = [];
        var three = [1, 2, 3];

        var genDefault = () -> 69;
        Assert.equals(69, empty.firstOrDefault(genDefault));
        Assert.equals( 1, three.firstOrDefault(genDefault));
    }

    function testFirstWhere() {
        var empty = [];
        var three = [1, 2, 3];

        Assert.same(None   , empty.firstMatch(x -> x == 69));
        Assert.same(None   , three.firstMatch(x -> x == 69));
        Assert.same(Some(2), three.firstMatch(x -> x == 2));
    }

    function testFlatMap() {
        var empty = [];
        var three = [1, 2, 3];
        var twice = x -> [x, x];

        Assert.same( empty
                   , empty.flatMap(twice).toArray());
        Assert.same( [1, 1, 2, 2, 3, 3]
                   , three.flatMap(twice).toArray());
        Assert.same(empty
                   , empty.flatMapS(twice));
        Assert.same( [1, 1, 2, 2, 3, 3]
                   , three.flatMapS(twice));
    }

    function testFlatten() {
        var empty = [];
        var multi = [[], []];
        var pairs = [[1, 2], [3, 4]];

        Assert.same( empty
                   , empty.flatten().toArray());
        Assert.same( empty
                   , multi.flatten().toArray());
        Assert.same( [1, 2, 3, 4]
                   , pairs.flatten().toArray());
    }

    function testFolds() {
        var empty = [];
        var three = [1, 2, 3];

        var add = (a, b) -> a + b;
        var sub = (a, b) -> a - b;

        Assert.equals( 0, empty.foldl(0, add));
        Assert.equals( 0, empty.foldl(0, sub));
        Assert.equals( 6, three.foldl(0, add));
        Assert.equals(-6, three.foldl(0, sub)); // ((0-1)-2)-3

        Assert.equals( 0, empty.foldr(0, add));
        Assert.equals( 0, empty.foldr(0, sub));
        Assert.equals( 6, three.foldr(0, add));
        Assert.equals( 2, three.foldr(0, sub)); // 1-(2-(3-0))
    }

    function testIndexed() {
        var empty = [];
        var three = ['a', 'b', 'c'];
        Assert.same(empty, empty.indexed().toKVArray());
        Assert.same( [ 0.keyFor('a')
                     , 1.keyFor('b')
                     , 2.keyFor('c') ]
                   , three.indexed().toKVArray());
    }

    function testInit() {
        var empty = [];
        var three = [1, 2, 3];
        Assert.same(empty   , empty.init().toArray());
        Assert.same([1, 2]  , three.init().toArray());
    }

    function testIntercalate() {
        var empty = [];
        var multi = [[], []];
        var three = [1, 2, 3];
        var separator = [69, 420];
        Assert.same( empty      , empty.intercalate(separator).toArray());
        Assert.same( separator  , multi.intercalate(separator).toArray());
        Assert.same( [three, separator, three, separator, three].flatten().toArray()
                   , three.replicate(3).intercalate(separator).toArray());
    }

    function testIntersperse() {
        var empty = [];
        var three = [1, 2, 3];
        var separator = 69;
        Assert.same( empty, empty.intersperse(separator).toArray());
        Assert.same( [ 1, separator, 2, separator, 3]
                   , three.intersperse(separator).toArray());
    }

    function testIsEmpty() {
        var empty = [];
        var nonEmpty = [123];
        Assert.isTrue(empty.isEmpty());
        Assert.isFalse(nonEmpty.isEmpty());
    }

    function testIterate() {
        var lazyTen = 1.iterate(add1).take(10);
        var strict = [for(x in 1...11) x]; // array comprehension is exclusive on the upper bound
        Assert.same(strict, lazyTen.toArray());
    }

    function testLastWhere() {
        var empty = [];
        var input = [8, 6, 7, 5, 3, 0, 9];
        var test = x -> x < 5;
        Assert.same(None    , empty.lastMatch(test));
        Assert.same(Some(0) , input.lastMatch(test));
    }

    function testMap() {
        var empty = [];
        var three = [1, 2, 3];
        var evens = [2, 4, 6];
        var selector = x -> x * 2;

        Assert.same(empty   , empty.mapS(selector));
        Assert.same(empty   , empty.mapL(selector).toArray());

        Assert.same(evens   , three.mapS(selector));
        Assert.same(evens   , three.mapL(selector).toArray());
    }

    function testMapMaybes() {
        var empty = [];
        var three = [Some(1), None, Some(3)];

        Assert.same(empty   , empty.mapMaybes(identity).toArray());
        Assert.same([1, 3]  , three.mapMaybes(identity).toArray());
    }

    function testMapOutcomes() {
        var empty = [];
        var three = [Success(1), Failure('nothing'), Success(3)];

        Assert.same(empty   , empty.mapOutcomes(identity).toArray());
        Assert.same([1, 3]  , three.mapOutcomes(identity).toArray());
    }

    function testMaybeFirst() {
        var empty = [];
        var three = [1, 2, 3];
        Assert.same(None    , empty.maybeFirst());
        Assert.same(Some(1) , three.maybeFirst());
    }

    function testMaybeLast() {
        var empty = [];
        var three = [1, 2, 3];
        Assert.same(None    , empty.maybeLast());
        Assert.same(Some(3) , three.maybeLast());
    }

    function testOpposite() {
        var empty = [];
        var three = [1, 2, 3];
        var blast = [3, 2, 1];

        Assert.same(empty   , empty.opposite());
        Assert.same(blast   , three.opposite());
    }

    function testOrDefault() {
        var empty = [];
        var three = [1, 2, 3];
        var evens = [2, 4, 6];
        var genDefault = () -> evens;

        Assert.same(evens   , empty.orDefault(genDefault));
        Assert.same(three   , three.orDefault(genDefault));
    }

    function testOrderBy() {
        var empty   = [];
        var numbers = [8, 6, 7, 5, 3, 0, 9];
        var ascends = [0, 3, 5, 6, 7, 8, 9];
        var descend = [9, 8, 7, 6, 5, 3, 0];

        Assert.same(empty   , empty.orderByAsc(identity));
        Assert.same(empty   , empty.orderByDesc(identity));
        Assert.same(ascends , numbers.orderByAsc(identity));
        Assert.same(descend , numbers.orderByDesc(identity));
    }

    function testPairs() {
        var empty = [];
        var three = [1, 2, 3];
        var pairs = [1.with(2), 2.with(3)];

        Assert.same(empty   , empty.pairs().toArray());
        Assert.same(pairs   , three.pairs().toArray());
    }

    function testPartition() {
        var empty = [];
        var numbers = [8, 6, 7, 5, 3, 0, 9];
        var parts = [8, 6, 0].with([7, 5, 3, 9]);
        var predicate = x -> x % 2 == 0;

        Assert.same(empty.with(empty)   , empty.partition(predicate));
        Assert.same(parts               , numbers.partition(predicate));
    }

    function testProduct() {
        var empty = [];
        var abc = ['a', 'b', 'c'];
        var def = ['d', 'e', 'f'];
        var fn = (x, y) -> '$x$y';
        var res = [ 'ad', 'ae', 'af'
                  , 'bd', 'be', 'bf'
                  , 'cd', 'ce', 'cf'
                  ];

        Assert.same(empty   , empty.product(empty, fn).toArray());
        Assert.same(res     , abc.product(def, fn).toArray());
    }

    function testRange() {
        Assert.same([]          , 1.range(0).toArray());
        Assert.same([]          , 1.range(-1).toArray());
        Assert.same([1, 2, 3]   , 1.range(3).toArray());
        Assert.same([-1, 0, 1]  , (-1).range(3).toArray());
    }

    function testRepeat() {
        Assert.same( [for(_ in 0...10) 0]
                   , 0.repeat().take(10).toArray());
    }

    function testReplicate() {
        Assert.same([], 0.replicate(0).toArray());
        Assert.same([], 0.replicate(-1).toArray());
        Assert.same( [for(_ in 0...10) 0]
                   , 0.replicate(10).toArray());
    }

    function testScan() {
        var empty = [];
        var a = 'a';
        var bcd = ['b', 'c', 'd'];
        var fn = (acc, val) -> '$acc$val';

        Assert.same(empty   , empty.scan_(a, fn).toArray());
        Assert.same([a]     , empty.scan(a, fn).toArray());

        Assert.same( ['a', 'ab', 'abc', 'abcd']
                   , bcd.scan(a, fn).toArray());
        Assert.same( ['ab', 'abc', 'abcd']
                   , bcd.scan_(a, fn).toArray());
    }

    function testSkip() {
        var empty = [];
        var three = [1, 2, 3];

        Assert.same(empty   , empty.skip(0).toArray());
        Assert.same(three   , three.skip(-1).toArray());
        Assert.same(three   , three.skip(0).toArray());
        Assert.same([3]     , three.skip(2).toArray());
    }

    function testSkipWhile() {
        var empty = [];
        var numbers = [8, 6, 7, 5, 3, 0, 9];
        var filter = x -> x >= 5;

        Assert.same(empty       , empty.skipWhile(filter).toArray());
        Assert.same([3, 0, 9]   , numbers.skipWhile(filter).toArray());
    }

    function testSomes() {
        var empty = [];
        var three = [Some(1), Some(2), None];

        Assert.same(empty   , empty.somes().toArray());
        Assert.same([1, 2]  , three.somes().toArray());
    }

    function testSpan() {
        var empty = [];
        var numbers = [8, 6, 7, 5, 3, 0, 9];
        var predicate = x -> x >= 5;

        var retype = (x:Pair<Iterable<Int>, Iterable<Int>>) ->
            x._1.toArray().with(x._2.toArray());

        Assert.same( empty.with(empty)
                   , retype(empty.span(predicate)));
        Assert.same( [8, 6, 7, 5].with([3, 0, 9])
                   , retype(numbers.span(predicate)));
    }

    function testSuccesses() {
        var empty = [];
        var three = [Success(1), Success(2), Failure('nothing')];

        Assert.same(empty   , empty.successes().toArray());
        Assert.same([1, 2]  , three.successes().toArray());
    }

    function testTail() {
        var empty = [];
        var three = [1, 2, 3];

        Assert.same(empty   , empty.tail().toArray());
        Assert.same([2, 3]  , three.tail().toArray());
    }

    function testTake() {
        var empty = [];
        var three = [1, 2, 3];

        Assert.same(empty   , empty.take(0).toArray());
        Assert.same(empty   , empty.take(1).toArray());
        Assert.same(empty   , three.take(-1).toArray());
        Assert.same(empty   , three.take(0).toArray());
        Assert.same([1, 2]  , three.take(2).toArray());
    }

    function testTakeWhile() {
        var empty = [];
        var numbers = [8, 6 ,7, 5, 3, 0, 9];
        var predicate = x -> x >= 5;

        Assert.same( empty
                   , empty.takeWhile(predicate).toArray());
        Assert.same( [8, 6, 7, 5]
                   , numbers.takeWhile(predicate).toArray());
    }

    function testToArray() {
        var empty = [];
        var three = [1, 2, 3];

        Assert.same(empty   , empty.toArray());
        Assert.same(three   , three.toArray());
    }

    function testZip() {
        var empty = [];
        var three = [1, 2, 3];
        var evens = [2, 4, 6];
        var pairs = [1.with(2), 2.with(4), 3.with(6)];

        Assert.same(empty   , empty.zip(empty).toArray());
        Assert.same(empty   , three.zip(empty).toArray()); // output length is the same as the shortest input
        Assert.same(pairs   , three.zip(evens).toArray());
    }
}