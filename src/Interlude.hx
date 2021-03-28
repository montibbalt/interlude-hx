package;

typedef Interlude = {};

typedef Curry2              = interlude.Curry.Curry2;
typedef Curry3              = interlude.Curry.Curry3;
typedef Curry4              = interlude.Curry.Curry4;
typedef Curry5              = interlude.Curry.Curry5;
typedef Curry6              = interlude.Curry.Curry6;

typedef Either<X, Y>        = haxe.ds.Either<X, Y>;
typedef EitherTools         = interlude.EitherTools;

typedef FunctionTools       = interlude.FunctionTools;

typedef Array1<X>           = interlude.Array1<X>;
typedef Array1Tools         = interlude.Array1.Array1Tools;
typedef IterableTools       = interlude.IterableTools;
typedef Iterable1<X>        = interlude.Iterable1<X>;
typedef Iterable1Tools      = interlude.Iterable1.Iterable1Tools;
typedef IteratorTools       = interlude.IteratorTools;
typedef KVIterableTools     = interlude.KeyValueIterableTools;
typedef KVIteratorTools     = interlude.KeyValueIterableTools.KeyValueIteratorTools;

typedef Lazy<X>             = interlude.Lazy<X>;

typedef MapTools            = interlude.MapTools;

typedef NullTools           = interlude.NullTools;
typedef Option<X>           = haxe.ds.Option<X>;
typedef OptionTools         = interlude.OptionTools;
typedef Outcome<X>          = interlude.OutcomeTools.Outcome<X>;
typedef OutcomeTools        = interlude.OutcomeTools;

typedef ValueTools          = interlude.ValueTools;

typedef KeyValuePair<K, V>  = { key:K, value:V };
typedef Pair<X, Y>          = interlude.PairTools.Pair<X, Y>;
typedef PairTools           = interlude.PairTools.PairTools;
typedef Trio<X, Y, Z>       = interlude.PairTools.Trio<X, Y, Z>;
typedef TrioTools           = interlude.PairTools.TrioTools;

typedef Trampoline<X>       = interlude.Trampoline<X>;
typedef TrampolineTools     = interlude.Trampoline.TrampolineTools;

// Might as well throw these in
typedef DateTools_          = DateTools;
typedef StringTools_        = StringTools;