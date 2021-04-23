package;

typedef Interlude = {};

typedef Curry2              = interlude.func.Curry.Curry2;
typedef Curry3              = interlude.func.Curry.Curry3;
typedef Curry4              = interlude.func.Curry.Curry4;
typedef Curry5              = interlude.func.Curry.Curry5;
typedef Curry6              = interlude.func.Curry.Curry6;
typedef FunctionTools       = interlude.func.FunctionTools;
typedef FloatTools          = interlude.func.ValueTools.FloatTools;
typedef IntTools            = interlude.func.ValueTools.IntTools;
typedef ValueTools          = interlude.func.ValueTools;
typedef Trampoline<X>       = interlude.func.Trampoline<X>;
typedef TrampolineTools     = interlude.func.Trampoline.TrampolineTools;

typedef Array1<X>           = interlude.ds.Array1<X>;
typedef Either<X, Y>        = haxe.ds.Either<X, Y>;
typedef EitherTools         = interlude.ds.EitherTools;
typedef Iterable1<X>        = interlude.ds.Iterable1<X>;
typedef Lazy<X>             = interlude.ds.Lazy<X>;
typedef MapTools            = interlude.ds.MapTools;
typedef NullTools           = interlude.ds.NullTools;
typedef Option<X>           = haxe.ds.Option<X>;
typedef OptionTools         = interlude.ds.OptionTools;
typedef Outcome<X>          = interlude.ds.Outcome<X>;
typedef OutcomeTools        = interlude.ds.Outcome.OutcomeTools;
typedef KeyValuePair<K, V>  = interlude.ds.Pair.KeyValuePair<K, V>;
typedef Pair<X, Y>          = interlude.ds.Pair<X, Y>;
typedef State<X, Y>         = interlude.ds.State<X, Y>;
typedef AsyncState<X, Y>    = interlude.ds.AsyncState<X, Y>;
typedef Trio<X, Y, Z>       = interlude.ds.Pair.Trio<X, Y, Z>;
typedef Unit                = interlude.ds.Unit;
typedef Weighted<X>         = interlude.ds.Weighted<X>;
typedef WeightedTools       = interlude.ds.Weighted.WeightedTools;

typedef IterableTools       = interlude.iter.IterableTools;
typedef IteratorTools       = interlude.iter.IteratorTools;
typedef KVIterableTools     = interlude.iter.KeyValueIterableTools;
typedef KVIteratorTools     = interlude.iter.KeyValueIterableTools.KeyValueIteratorTools;

typedef Task<X>             = interlude.reactive.Task<X>;
typedef Surprise<X>         = interlude.reactive.Surprise<X>;
typedef Observable<X>       = interlude.reactive.Observable<X>;

// Might as well throw these in
typedef DateTools_          = DateTools;
typedef Math_               = Math;
typedef StringTools_        = StringTools;