package;

typedef Interlude = {};

typedef Curry2              = interlude.func.Curry.Curry2;
typedef Curry3              = interlude.func.Curry.Curry3;
typedef Curry4              = interlude.func.Curry.Curry4;
typedef Curry5              = interlude.func.Curry.Curry5;
typedef Curry6              = interlude.func.Curry.Curry6;
typedef FunctionTools       = interlude.func.FunctionTools;
typedef ValueTools          = interlude.func.ValueTools;
typedef Trampoline<X>       = interlude.func.Trampoline<X>;
typedef TrampolineTools     = interlude.func.Trampoline.TrampolineTools;

typedef Array1<X>           = interlude.ds.Array1<X>;
typedef Array1Tools         = interlude.ds.Array1.Array1Tools;
typedef Either<X, Y>        = haxe.ds.Either<X, Y>;
typedef EitherTools         = interlude.ds.EitherTools;
typedef Iterable1<X>        = interlude.ds.Iterable1<X>;
typedef Iterable1Tools      = interlude.ds.Iterable1.Iterable1Tools;
typedef Lazy<X>             = interlude.ds.Lazy<X>;
typedef LazyTools           = interlude.ds.Lazy.LazyTools;
typedef MapTools            = interlude.ds.MapTools;
typedef NullTools           = interlude.ds.NullTools;
typedef Option<X>           = haxe.ds.Option<X>;
typedef OptionTools         = interlude.ds.OptionTools;
typedef Outcome<X>          = interlude.ds.OutcomeTools.Outcome<X>;
typedef OutcomeTools        = interlude.ds.OutcomeTools;
typedef KeyValuePair<K, V>  = interlude.ds.PairTools.KeyValuePair<K, V>;
typedef Pair<X, Y>          = interlude.ds.PairTools.Pair<X, Y>;
typedef PairTools           = interlude.ds.PairTools.PairTools;
typedef Trio<X, Y, Z>       = interlude.ds.PairTools.Trio<X, Y, Z>;
typedef TrioTools           = interlude.ds.PairTools.TrioTools;
typedef Unit                = interlude.ds.Unit;
typedef Weighted<X>         = interlude.ds.Weighted<X>;
typedef WeightedTools       = interlude.ds.Weighted.WeightedTools;

typedef IterableTools       = interlude.iter.IterableTools;
typedef IteratorTools       = interlude.iter.IteratorTools;
typedef KVIterableTools     = interlude.iter.KeyValueIterableTools;
typedef KVIteratorTools     = interlude.iter.KeyValueIterableTools.KeyValueIteratorTools;

typedef Task<X>             = interlude.reactive.Task<X>;
typedef TaskTools           = interlude.reactive.Task.TaskTools;
typedef Surprise<X>         = interlude.reactive.Surprise<X>;
typedef SurpriseTools       = interlude.reactive.Surprise.SurpriseTools;
typedef Observable<X>       = interlude.reactive.Observable<X>;
typedef ObservableTools     = interlude.reactive.Observable.ObservableTools;

// Might as well throw these in
typedef DateTools_          = DateTools;
typedef Math_               = Math;
typedef StringTools_        = StringTools;