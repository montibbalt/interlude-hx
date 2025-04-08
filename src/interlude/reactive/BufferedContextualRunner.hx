package interlude.reactive;

/**
 * An experimental version of `BufferedRunner` which passes a value into every
 * callback.
 * 
 * For example, we could imagine a version of `AsyncState` that can pass around
 * configuration settings alongside the state
 */
@:nullSafety(Strict)
@:publicFields
@:structInit
class BufferedContextualRunner<Context> {
    var frontBuffer(default, null):Array<Context->Void> = [];
    var backBuffer(default, null):Array<Context->Void> = [];

    function new() {}

    /**
     * Pushes a callback function into the buffer
     * @return The new length of the buffer `fn` was added to
     */
    function queue(fn:Context->Void):Int return
        frontBuffer.any()
            ? backBuffer.push(fn)
            : frontBuffer.push(fn);

    /**
     * Pushes an Array of callback functions into the buffer
     * @return A reference to the updated buffer
     */
    function queueMany(fns:Array<Context->Void>):Array<Context->Void> return
        frontBuffer.any()
            ? backBuffer = backBuffer.concat(fns)
            : frontBuffer = fns;

    /**
     * Passes a context into every callback in the front buffer, then swaps buffers.
     * Loops until both buffers are consumed, so some care must be taken to avoid infinite loops
     */
    function resolve(ctx:Context):Void
        do {
            frontBuffer.mutate(ctx.let);
            frontBuffer = backBuffer;
            backBuffer = [];
        } while (frontBuffer.length > 0);

    /**
     * Calls every callback in the front buffer, then swaps buffers.
     * This version only consumes the front buffer, so subsequent calls must be
     * made to continue processing
     */
    function resolveOnce(ctx:Context):Void {
        if(frontBuffer.length > 0) {
            frontBuffer.mutate(ctx.let);
            frontBuffer = backBuffer;
            backBuffer = [];
        }
    }
}