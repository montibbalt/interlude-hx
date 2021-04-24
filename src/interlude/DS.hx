package interlude;

typedef Array1<X>                   = interlude.ds.Array1<X>;
typedef Either<X, Y>                = haxe.ds.Either<X, Y>;
typedef Iterable1<X>                = interlude.ds.Iterable1<X>;
typedef Lazy<X>                     = interlude.ds.Lazy<X>;
typedef Option<X>                   = haxe.ds.Option<X>;
typedef Outcome<X>                  = interlude.ds.Outcome<X>;
typedef KeyValuePair<K, V>          = interlude.ds.Pair.KeyValuePair<K, V>;
typedef Pair<X, Y>                  = interlude.ds.Pair<X, Y>;
typedef State<X, Y>                 = interlude.ds.State<X, Y>;
typedef AsyncState<X, Y>            = interlude.ds.AsyncState<X, Y>;
typedef Trio<X, Y, Z>               = interlude.ds.Pair.Trio<X, Y, Z>;
typedef Unit                        = interlude.ds.Unit;
typedef Weighted<X>                 = interlude.ds.Weighted<X>;

@:dox(hide) typedef EitherTools     = interlude.ds.EitherTools;
@:dox(hide) typedef MapTools        = interlude.ds.MapTools;
@:dox(hide) typedef NullTools       = interlude.ds.NullTools;
@:dox(hide) typedef OptionTools     = interlude.ds.OptionTools;
@:dox(hide) typedef OutcomeTools    = interlude.ds.Outcome.OutcomeTools;