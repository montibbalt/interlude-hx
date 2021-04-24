package reactive;

import haxe.io.Int32Array;
import utest.Assert;
import utest.ITest;

class TestTask implements ITest {
    public function new() {}

    function testAsTask() {
        var t0 = new Task<Int>();
        var t1 = new Task<Int>(123);
        var t2 = 123.asTask();

        Assert.isNull(t0.data);
        Assert.isFalse(t0.isComplete);
        Assert.same([], t0.observers);

        Assert.same(123, t1.data);
        Assert.isTrue(t1.isComplete);
        Assert.same([], t1.observers);

        Assert.same(123, t2.data);
        Assert.isTrue(t2.isComplete);
        Assert.same([], t2.observers);
    }

    function testResolve() {
        var t = new Task<Int>();

        t.mutate(discard);
        Assert.same([discard], t.observers);

        t.resolve(123);

        Assert.same(123, t.data);
        Assert.isTrue(t.isComplete);
        Assert.same([], t.observers);

        Task.runner.resolve();

        Assert.same(123, t.data);
        Assert.isTrue(t.isComplete);
        Assert.same([], t.observers);
    }
}