package interlude;

enum Trampoline<T> {
    Done(t:T);
    Continue(f:Void->Trampoline<T>);
}

@:nullSafety(Strict)
@:publicFields
class TrampolineTools {
    /**
        Runs a recursive operation as an iterative one until it has been exhausted
    **/
    static function trampoline<T>(t:Trampoline<T>):T {
        var cache = t;
        while(true) {
            switch(cache) {
                case Done(t): return t;
                case Continue(f): cache = f();
            }
        }
    }
}