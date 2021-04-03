package interlude.reactive;

@:nullSafety(Strict)
@:structInit
class BufferedRunner {
    var frontBuffer:Array<()->Void> = [];
    var backBuffer:Array<()->Void> = [];

    public function new() {}

    public function queue(fn:()->Void):Int return frontBuffer.any()
        ? backBuffer.push(fn)
        : frontBuffer.push(fn);

    public function queueMany(fns:Array<()->Void>):Array<()->Void> return frontBuffer.any()
        ? backBuffer = backBuffer.concat(fns)
        : frontBuffer = fns;

    public function resolve():Void
        do {
            frontBuffer.mutate(gen);
            frontBuffer = backBuffer;
            backBuffer = [];
        } while (frontBuffer.length > 0);
}