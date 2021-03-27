package interlude;

enum Outcome<A> {
    Success(a:A);
    Failure(message:String, ?pos:haxe.PosInfos);
}

@:nullSafety(Strict)
@:publicFields
class OutcomeTools {
    static function any<A>(o:Outcome<A>):Bool return switch o {
        case Success(_): true;
        case Failure(_, _)  : false;
    }

    static function ap<A, B>(fn:Outcome<A->B>, o:Outcome<A>):Outcome<B> return
        fn.flatMap(o.map);

    inline static function asFailure<A>(message:String, ?pos:haxe.PosInfos):Outcome<A> return
        Failure(message, pos);

    inline static function asOutcome<A>(value:A):Outcome<A> return
        Success(value);

    inline static function asSuccess<A>(value:A):Outcome<A> return
        value.asOutcome();

    static function flatMap<A, B>(o:Outcome<A>, fn:A->Outcome<B>):Outcome<B> return switch o {
        case Success(value)         : fn(value);
        case Failure(message, pos)  : message.asFailure(pos);
    }

    static function iterator<A>(o:Outcome<A>):Iterator<A> return inline o.match(
        value   -> value.asIterable().iterator()
    ,   (_, ?_) -> { hasNext: () -> false, next: () -> throw 'Calling next on Outcome.failure: $o' }
    );

    static function map<A, B>(o:Outcome<A>, fn:A->B):Outcome<B> return switch o {
        case Success(value)         : fn(value).asOutcome();
        case Failure(message, pos)  : message.asFailure(pos);
    }

    static function match<A, B>(o:Outcome<A>, whenSuccess:A->B, whenFailure:(message:String, ?pos:haxe.PosInfos)->B):B return switch o {
        case Success(value)         : whenSuccess(value);
        case Failure(message, pos)  : whenFailure(message, pos);
    }

    static function mutate<A>(o:Outcome<A>, whenSuccess:A->Void, whenFailure:(message:String, ?pos:haxe.PosInfos)->Void):Outcome<A> return {
        switch o {
            case Success(value)         : whenSuccess(value);
            case Failure(message, pos)  : whenFailure(message, pos);
        }
        o;
    }

    static function mutate_<A>(o:Outcome<A>, whenSuccess:A->Void):Outcome<A> return {
        switch o {
            case Success(value) : whenSuccess(value);
            case Failure(_, _)  :
        }
        o;
    }

    static function toArray<A>(o:Outcome<A>):Iterable<A> return switch o {
        case Success(value) : [value];
        case Failure(_)     : [];
    }

    static function toEither<A>(o:Outcome<A>):Either<String, A> return switch o {
        case Success(value)     : value.asRight();
        case Failure(message, _): message.asLeft();
    }

    static function toOption<A>(o:Outcome<A>):Option<A> return switch o {
        case Success(value) : value.asOption();
        case Failure(_, _)  : None;
    }

    static function traceMessage<A>(o:Outcome<A>):Outcome<A> return o.mutate(
        discard
    ,   (message, ?pos) -> pos != null ? trace('$pos: $message') : trace(message)
    );

    static function traceValue<A>(o:Outcome<A>):Outcome<A> return o.mutate(
        value -> trace('$value')
    ,   discardWithPos
    );

    static function zip<A, B>(mA:Outcome<A>, mB:Outcome<B>):Outcome<Pair<A, B>> return
        mA.zipWith(mB, PairTools.with);

    static function zipWith<A, B, C>(mA:Outcome<A>, mB:Outcome<B>, fn:A->B->C):Outcome<C> return switch [mA, mB] {
        case [Success(a), Success(b)]: fn(a, b).asOutcome();
        case _: 'One or more inputs failed: $mA, $mB'.asFailure();
    }

    static function zipWith3<A, B, C, D>(mA:Outcome<A>, mB:Outcome<B>, mC:Outcome<C>, fn:A->B->C->D):Outcome<D> return switch [mA, mB, mC] {
        case [Success(a), Success(b), Success(c)]: fn(a, b, c).asOutcome();
        case _: 'One or more inputs failed: $mA, $mB, $mC'.asFailure();
    }

}