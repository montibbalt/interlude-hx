package interlude.ds;

@:nullSafety(Strict)
@:publicFields
class OptionTools {
    static function any<A>(maybe:Option<A>):Bool return switch maybe {
        case Some(_): true;
        case None   : false;
    }

    static function anyMatch<A>(maybe:Option<A>, predicate:A->Bool):Bool return switch maybe {
        case Some(a): predicate(a);
        case None   : false;
    }

    static function ap<A, B>(fn:Option<A->B>, maybe:Option<A>):Option<B> return switch [fn, maybe] {
        case [Some(fn), Some(a)]: Some(fn(a));
        case _                  : None;
    }

    static function asOption<A:NotVoid>(a:A):Option<A> return a != null
        ? Some(a)
        : None;

    static function contains<A>(maybe:Option<A>, value:A):Bool return switch maybe {
        case Some(a): a == value;
        case None   : false;
    }

    static function filter<A>(maybe:Option<A>, predicate:A->Bool):Option<A> return switch maybe {
        case Some(a)
            if(predicate(a)): maybe;
        case Some(_) | None : None;
    }

    static function filterFmap<A, B>(maybe:Option<A>, predicate:A->Bool, fn:A->Option<B>):Option<B> return switch maybe {
        case Some(a)
            if(predicate(a)): fn(a);
        case Some(_) | None : None;
    }

    static function filterMap<A, B>(maybe:Option<A>, predicate:A->Bool, fn:A->B):Option<B> return switch maybe {
        case Some(a)
            if(predicate(a)): Some(fn(a));
        case Some(_) | None : None;
    }

    static function flatMap<A, B>(maybe:Option<A>, fn:A->Option<B>):Option<B> return switch maybe {
        case Some(a): fn(a);
        case None   : None;
    }

    static function flatten<A>(mmaybe:Option<Option<A>>):Option<A> return switch mmaybe {
        case Some(m): m;
        case None   : None;
    }

    static function fold<A, B>(maybe:Option<A>, seed:B, fn:(accumulator:B, current:A)->B):B return switch maybe {
        case Some(a): fn(seed, a);
        case None   : seed;
    }

    static function iterator<A>(maybe:Option<A>):Iterator<A> return inline
        maybe.match(
            IteratorTools.asIterator
        ,   IteratorTools.empty
        );

    static function map<A, B>(maybe:Option<A>, fn:A->B):Option<B> return switch maybe {
        case Some(a): Some(fn(a)); 
        case None   : None;
    }

    static function match<A, B>(maybe:Option<A>, whenSome:A->B, whenNone:()->B):B return switch maybe {
        case Some(a): whenSome(a);
        case None   : whenNone();
    }

    static function mutate<A>(maybe:Option<A>, whenSome:A->Void, whenNone:()->Void):Option<A> return {
        switch maybe {
            case Some(a): whenSome(a);
            case None   : whenNone();
        }
        maybe;
    }

    static function mutate_<A>(maybe:Option<A>, whenSome:A->Void):Option<A> return {
        switch maybe {
            case Some(a): whenSome(a);
            case None   :
        }
        maybe;
    }

    static function orDefault<A>(maybe:Option<A>, whenNone:()->A):A return inline
        maybe.match(identity, whenNone);

    static function orElse<A>(maybe:Option<A>, genOther:()->Option<A>):Option<A> return switch maybe {
        case Some(_): maybe;
        case None   : genOther();
    }

    static function toArray<A>(maybe:Option<A>):Iterable<A> return switch maybe {
        case Some(a): [a];
        case None   : [];
    }

    static function toEither<A>(maybe:Option<A>):Either<String, A> return switch maybe {
        case Some(a): a.asRight();
        case None   : 'Option.None converted to Either.Left'.asLeft();
    }

    static function toNullable<A>(maybe:Option<A>):Null<A> return switch maybe {
        case Some(a): a;
        case None   : null;
    }

    static function toOutcome<A>(maybe:Option<A>):Outcome<A> return switch maybe {
        case Some(a): a.asSuccess();
        case None   : 'Option.None converted to Outcome'.asFailure();
    }

    static function traceMessage<A>(maybe:Option<A>, messageWhenNone:()->String):Option<A> return
        maybe.mutate(
            discard
        ,   () -> trace(messageWhenNone())
        );

    static function traceValue<A>(maybe:Option<A>):Option<A> return
        maybe.mutate(
            a -> trace('$a')
        ,   doNothing
        );

    static function zip<A, B>(mA:Option<A>, mB:Option<B>):Option<Pair<A, B>> return
        mA.zipWith(mB, PairTools.with);

    static function zipWith<A, B, C>(mA:Option<A>, mB:Option<B>, fn:A->B->C):Option<C> return switch [mA, mB] {
        case [Some(a), Some(b)]: Some(fn(a, b));
        case _: None;
    }

    static function zipWith3<A, B, C, D>(mA:Option<A>, mB:Option<B>, mC:Option<C>, fn:A->B->C->D):Option<D> return switch [mA, mB, mC] {
        case [Some(a), Some(b), Some(c)]: Some(fn(a, b, c));
        case _: None;
    }
}