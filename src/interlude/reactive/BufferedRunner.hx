package interlude.reactive;

/**
    A type of double buffer meant to handle resolution of
    `interlude.reactive.Task`s, but can work on any `Void` functions.

    Consumes the entire buffer, swapping the front and back buffers until both
    are empty

    Call `resolve` in your event loop to resolve `Task`s
**/
@:nullSafety(Strict)
@:publicFields
@:structInit
class BufferedRunner {
    var frontBuffer(default, null):Array<()->Void> = [];
    var backBuffer(default, null):Array<()->Void> = [];

    function new() {}

    /**
     * Pushes a callback function into the buffer
     * @return The new length of the buffer `fn` was added to
     */
    function queue(fn:()->Void):Int return
        frontBuffer.any()
            ? backBuffer.push(fn)
            : frontBuffer.push(fn);

    /**
     * Pushes an Array of callback functions into the buffer
     * @return A reference to the updated buffer
     */
    function queueMany(fns:Array<()->Void>):Array<()->Void> return
        frontBuffer.any()
            ? backBuffer = backBuffer.concat(fns)
            : frontBuffer = fns;

    /**
     * Calls every callback in the front buffer, then swaps buffers.
     * Loops until both buffers are consumed, so some care must be taken to avoid infinite loops
     */
    function resolve():Void
        do {
            frontBuffer.mutate(gen);
            frontBuffer = backBuffer;
            backBuffer = [];
        } while (frontBuffer.length > 0);
}