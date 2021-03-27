package interlude;

@:nullSafety(Strict)
class Lazy<A:NotVoid> {
    var result:Null<A> = null;
    var genValue:() -> A;
    public function new(genValue:() -> A) {
        this.genValue = genValue;
    }

    public function eval():A return result != null
        ? result
        : result = genValue();

    public function toArray():Array<A> return
        [eval()];

    public function toIterable():Iterable<A> return result != null
        ? [result]
        : { iterator: () -> { hasNext   : () -> result == null
                            , next      : () -> eval()
                            }
          }

    public function toString():String return result != null
        ? '$result'
        : 'Lazy<>';

    inline public static function asLazy<X>(x:X):Lazy<X> return
        new Lazy<X>(x.identity);
}