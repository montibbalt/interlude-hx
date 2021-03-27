package interlude;

@:nullSafety(Strict)
@:publicFields
class NullTools {
    static function toOption<A:NotVoid>(a:Null<A>):Option<A> return a != null
        ? Some(cast a)
        : None;
}