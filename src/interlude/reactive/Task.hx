package interlude.reactive;

@:nullSafety(Strict)
class Task<A:NotVoid> {
    public static final runner:BufferedRunner = {}
    public var data(default, null):Null<A> = null;
    public var isComplete(default, null):Bool = false;

    @:allow(interlude.reactive)
    var observers:Array<A->Void> = [];

    public function new(?data:A = null) {
        if(data != null) {
            this.data = data;
            this.isComplete = true;
        }
    }

    public function resolve(data:A):A return {
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
}

@:publicFields
@:nullSafety(Strict)
class TaskTools {
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
        t.flatMap(TaskTools.asTask.of(fn));

    static function mutate<A>(t:Task<A>, fn:A->Void):Task<A> return {
        t.isComplete && t.data != null
            ? Task.runner.queue(fn.bind(cast t.data))
            : t.observers.push(fn);

        t;
    }

    static function zip<A, B>(ta:Task<A>, tb:Task<B>):Task<Pair<A, B>> return
        ta.zipWith(tb, PairTools.with);

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