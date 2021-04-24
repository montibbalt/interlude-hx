package interlude.reactive;

/**
    A type of double buffer meant to handle resolution of
    `interlude.reactive.Task`s, but can work on any `Void` functions.

    Consumes the entire buffer, swapping the front and back buffers until both
    are empty
**/
@:nullSafety(Strict)
@:publicFields
@:structInit
class BufferedRunner {
    var frontBuffer(default, null):Array<()->Void> = [];
    var backBuffer(default, null):Array<()->Void> = [];

    function new() {}

    function queue(fn:()->Void):Int return frontBuffer.any()
        ? backBuffer.push(fn)
        : frontBuffer.push(fn);

    function queueMany(fns:Array<()->Void>):Array<()->Void> return frontBuffer.any()
        ? backBuffer = backBuffer.concat(fns)
        : frontBuffer = fns;

    function resolve():Void
        do {
            frontBuffer.mutate(gen);
            frontBuffer = backBuffer;
            backBuffer = [];
        } while (frontBuffer.length > 0);
}