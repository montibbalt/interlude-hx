package iter;

import utest.Assert;
import utest.ITest;

class TestIteratorTools implements ITest {
    public function new(){}

    function testAsIterator() {
        var it = 123.asIterator();

        Assert.same([123], [for (x in it) x]);
    }

    function testEmpty() {
        var it = IteratorTools.empty();

        Assert.isFalse(it.hasNext());
        Assert.raises(it.next);
    }

    function testFiltered() {
        var it = [1, 2, 3, 4, 5, 6].iterator().filtered();
        var filter = isEven;
        var filteredIterable = { hasNext: () -> it.hasNextWhere(filter), next: it.next };

        Assert.same([2, 4, 6], filteredIterable.toArray());
    }

    function testIndexed() {
        var it = [Unit, Unit, Unit].iterator().indexed();

        Assert.same([Unit.keyedWith(0), Unit.keyedWith(1), Unit.keyedWith(2)], it.toArray());
    }

    function testMapped() {
        var it = [1, 2, 3].iterator().mapped();
        var transform = Std.string;
        var transformedIterable = { hasNext: it.hasNext, next: () -> it.next(transform) };

        Assert.same(['1', '2', '3'], transformedIterable.toArray());
    }

    function testPeekable() {
        var it = [1, 2, 3].iterator().peekable();

        Assert.same(Some(1), it.peek());
        Assert.same(Some(1), it.peek());
        Assert.same([1, 2, 3], it.toArray());
        Assert.same(None, it.peek());
    }
}