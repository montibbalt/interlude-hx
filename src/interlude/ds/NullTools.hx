package interlude.ds;

@:nullSafety(Strict)
@:publicFields
class NullTools {
    /**
        Converts a nullable value to `Option`
    **/
    static function toOption<A:NotVoid>(a:Null<A>):Option<A> return a != null
        ? Some(cast a)
        : None;
}