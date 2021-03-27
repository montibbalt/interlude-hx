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

typedef IterableTools       = interlude.IterableTools;
typedef IteratorTools       = interlude.IteratorTools;
typedef KVIterableTools     = interlude.KeyValueIterableTools;
typedef KVIteratorTools     = interlude.KeyValueIterableTools.KeyValueIteratorTools;

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