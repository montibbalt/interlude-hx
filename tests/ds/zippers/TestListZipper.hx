package ds.zippers;

import utest.Assert;
import utest.ITest;

class TestListZipper implements ITest {
    public function new() {}

    function testAsZipper() {
        var foo:ListZipper<Int> = 123.asZipper();
        var bar:ListZipper<Int> = 123.listZipperWith(new List());
        var baz:ListZipper<Int> = 123.from1(456, 789);

        Assert.same([123], [for (x in foo) x]);
        Assert.same([123], [for (x in bar) x]);
        Assert.same([123, 456, 789], [for (x in baz) x]);
    }

    function testLeftRight() {
        var foo:ListZipper<Int> = 0.from1(1, 2, 3, 4, 5);
        Assert.equals(0, foo.focus);

        var bar = foo.right();
        Assert.same(1, bar.focus);
        Assert.same([0], bar.facingLeft.toArray());
        Assert.same([2, 3, 4, 5], bar.facingRight.toArray());

        var baz = bar.left();
        Assert.same(foo, baz);
    }

    function testUpdate() {
        var foo:ListZipper<Int> = 0.from1(1, 2, 3, 4, 5);
        var qux = foo.update(69);
        Assert.same(69, qux.focus);
        Assert.same(foo.facingLeft, qux.facingLeft);
        Assert.same(foo.facingRight, qux.facingRight);
    }
}