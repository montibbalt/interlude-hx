package interlude.reactive;

/**
    A type that represents an asynchronous value. This is often called `Future`

    This implementation avoids stack problems some implementations have, but
    allows/requires the user to control resolution. A simple way to do this is
    to add `Task.runner.resolve();` to your main loop.
**/
@:nullSafety(Strict)
@:publicFields
class Task<A:NotVoid> {
    static final runner:BufferedRunner = {}
    var data(default, null):Null<A> = null;
    var isComplete(default, null):Bool = false;

    var observers(default, null):Array<A->Void> = [];

    function new(?data:A = null) {
        if(data != null) {
            this.data = data;
            this.isComplete = true;
        }
    }

    function resolve(data:A):A return {
        if(!this.isComplete) {
            this.data = data;
            this.isComplete = true;

            if(observers.any()) {
                runner.queueMany([for (fn in observers) fn.bind(data)]);
                observers = [];
            }
        }

        data;
    }

    static function always<A, B>(t:Task<A>, value:B):Task<B> return
        t.map(value.v_);

    static function any<A>(t:Task<A>):Bool return
        t.isComplete;

    static function ap<A, B>(fn:Task<A->B>, t:Task<A>):Task<B> return
        fn.flatMap(t.map);

    inline static function asTask<X>(data:X):Task<X> return
        new Task<X>(data);

    static function filter<A>(t:Task<A>, predicate:A->Bool):Task<Option<A>> return
        t.map(new Task<A>().resolve.when(predicate));

    static function filterMap<A, B>(t:Task<A>, predicate:A->Bool, fn:A->B):Task<Option<B>> return
        t.map(fn.when(predicate));

    static function filterFMap<A, B>(t:Task<A>, predicate:A->Bool, fn:A->Task<B>):Task<Option<B>> return
        t.flatMap(a -> predicate(a)
            ? fn(a).map(Some)
            : None.asTask());

    static function f_callbacks<A>(fn:(callback:A->Void)->Void):Task<A> return
        new Task<A>().mut(a -> fn(a.resolve));

    static function flatMap<A, B>(t:Task<A>, fn:A->Task<B>):Task<B> return {
        var promise = new Task<B>();
        t.mutate(a -> fn(a).mutate(promise.resolve));
        promise;
    }

    static function flatten<A>(t:Task<Task<A>>):Task<A> return
        t.flatMap(identity);

    static function map<A, B>(t:Task<A>, fn:A->B):Task<B> return inline
        t.flatMap(Task.asTask.of(fn));

    static function mutate<A>(t:Task<A>, fn:A->Void):Task<A> return {
        t.isComplete && t.data != null
            ? Task.runner.queue(fn.bind(cast t.data))
            : t.observers.push(fn);

        t;
    }

    static function zip<A, B>(ta:Task<A>, tb:Task<B>):Task<Pair<A, B>> return
        ta.zipWith(tb, Pair.with);

    static function zipWith<A, B, C>(a:Task<A>, b:Task<B>, fn:A->B->C):Task<C> return
        a.flatMap(fn.curry().to(b.map));
        //a.flatMap(b.map.of(fn.curry()));

    static function zipWith3<A, B, C, Z>(a:Task<A>, b:Task<B>, c:Task<C>, fn:A->B->C->Z):Task<Z> return
        a.flatMap(_a -> b.zipWith(c, fn.bind(_a)));

    static function logMessage<A>(t:Task<A>, genMessage:(data:A, ?pos:haxe.PosInfos)->String, ?pos:haxe.PosInfos):Task<A> return
        t.mutate(_ -> trace(genMessage(_, pos)));

    static function unit<A>(t:Task<A>):Task<Unit> return
        t.always(Unit);
}