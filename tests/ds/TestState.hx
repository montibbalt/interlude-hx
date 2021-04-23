package ds;

import utest.Assert;
import utest.ITest;

class TestState implements ITest {
    public function new() {}

    function testAsState() {
        Assert.same(123, 123.asState()(Unit)._1);
    }

    @:depends(testAsState)
    function testEvalRun() {
        var state:State<Unit, Int> = 123.asState();

        Assert.same(123, state.eval(Unit));
        Assert.same(Unit, state.run(Unit));
    }

    @:depends(testAsState, testEvalRun)
    function testFilter() {
        var state:State<Unit, Int> = 123.asState();
        var pass = state.filter(_ -> true);
        var fail = state.filter(_ -> false);

        Assert.same(Some(123), pass.eval(Unit));
        Assert.same(None, fail.eval(Unit));
    }

    @:depends(testAsState, testEvalRun)
    function testFilterMap() {
        var state:State<Unit, Int> = 123.asState();
        var pass = state.filterMap(_ -> true, Std.string);
        var fail = state.filterMap(_ -> false, Std.string);

        Assert.same(Some('123'), pass.eval(Unit));
        Assert.same(None, fail.eval(Unit));
    }

    @:depends(testAsState, testEvalRun)
    function testFilterFMap() {
        var state:State<Unit, Int> = 123.asState();
        var pass = state.filterFMap(_ -> true, State.asState);
        var fail = state.filterFMap(_ -> false, State.asState);

        Assert.same(Some(123), pass.eval(Unit));
        Assert.same(None, fail.eval(Unit));
    }

    @:depends(testAsState, testEvalRun)
    function testFlatMap() {
        var state:State<Unit, String> = 123
            .asState()
            .flatMap(n -> '$n'.asState());

        var state2:State<Bool, Unit> = Unit
            .asState()
            .flatMap(a -> x -> a.with(!x));

        Assert.same('123', state.eval(Unit));
        Assert.same(false, state2.run(true));
    }

    @:depends(testAsState, testEvalRun)
    function testFlatten() {
        var state = 123.asState().asState();
        var flattened = state.flatten();

        // note the multiplication comes before the addition
        var state2:State<Int, State<Int, Unit>> = x -> (y -> Unit.with(y + 1)).with(x * 2);
        var flattened2:State<Int, Unit> = state2.flatten();

        Assert.same(123, flattened.eval(Unit));
        Assert.same(247, flattened2.run(123)); // x * 2 + 1; x == 123
    }

    function testMap() {
        var state = 123.asState().map(Std.string);

        Assert.same('123', state.eval(Unit));
    }

    function testZipWith() {
        var stateA = 123.asState();
        var stateB = 456.asState();

        var zipped = stateA.zipWith(stateB, add);
        Assert.same(579, zipped.eval(Unit)); // 123 + 456
    }

    function testZip() {
        var stateA = 123.asState();
        var stateB = 456.asState();

        Assert.same(123.with(456), stateA.zip(stateB).eval(Unit));
    }
}