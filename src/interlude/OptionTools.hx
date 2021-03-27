package interlude;

using Interlude;

@:nullSafety(Strict)
@:publicFields
class OptionTools {
    static function any<A>(maybeA:Option<A>):Bool return
        switch maybeA {
            case Some(_): true;
            case None   : false;
        }

    static function ap<A, B>(mFn:Option<A->B>, maybeA:Option<A>):Option<B> return
        switch [mFn, maybeA] {
            case [Some(fn), Some(a)]: Some(fn(a));
            case _                  : None;
            //case [Some(_) | None, Some(_) | None]: None;
        }

    static function asOption<A:NotVoid>(a:A):Option<A> return
        a != null ? Some(a) : None;

    static function filter<A>(maybeA:Option<A>, predicate:A->Bool):Option<A> return
        switch maybeA {
            case Some(a)
                if(predicate(a)): maybeA;
            case Some(_) | None : None;
        }

    static function filterAny<A>(maybeA:Option<A>, predicate:A->Bool):Bool return
        switch maybeA {
            case Some(a): predicate(a);
            case None   : false;
        }

    static function filterFmap<A, B>(maybeA:Option<A>, predicate:A->Bool, fn:A->Option<B>):Option<B> return
        switch maybeA {
            case Some(a)
                if(predicate(a)): fn(a);
            case Some(_) | None : None;
        }

    static function filterMap<A, B>(maybeA:Option<A>, predicate:A->Bool, fn:A->B):Option<B> return
        switch maybeA {
            case Some(a)
                if(predicate(a)): Some(fn(a));
            case Some(_) | None : None;
        }

    static function flatMap<A, B>(maybeA:Option<A>, fn:A->Option<B>):Option<B> return
        switch maybeA {
            case Some(a): fn(a);
            case None   : None;
        }

    static function flatten<A>(mmaybeA:Option<Option<A>>):Option<A> return
        switch mmaybeA {
            case Some(m): m;
            case None   : None;
        }

    static function fold<A, B>(maybeA:Option<A>, seed:B, fn:(accumulator:B, current:A)->B):B return
        switch maybeA {
            case Some(a): fn(seed, a);
            case None   : seed;
        }

    static function iterator<A>(maybeA:Option<A>):Iterator<A> return inline
        maybeA.match(
            a   -> ([a].iterator():Iterator<A>)
        ,   ()  -> ({ hasNext: () -> false, next: () -> throw 'Calling next on Option.None'})
        );

    static function map<A, B>(maybeA:Option<A>, fn:A->B):Option<B> return
        switch maybeA {
            case Some(a): Some(fn(a)); 
            case None   : None;
        }

    static function match<A, B>(maybeA:Option<A>, whenSome:A->B, whenNone:()->B):B return
        switch maybeA {
            case Some(a): whenSome(a);
            case None   : whenNone();
        }

    static function mutate<A>(maybeA:Option<A>, whenSome:A->Void, whenNone:()->Void):Option<A> return {
        switch maybeA {
            case Some(a): whenSome(a);
            case None   : whenNone();
        }
        maybeA;
    }

    static function mutate_<A>(maybeA:Option<A>, whenSome:A->Void):Option<A> return {
        switch maybeA {
            case Some(a): whenSome(a);
            case None   :
        }
        maybeA;
    }

    static function orDefault<A>(maybeA:Option<A>, whenNone:()->A):A return inline
        maybeA.match(identity, whenNone);

    static function orElse<A>(maybeA:Option<A>, genOther:()->Option<A>):Option<A> return
        switch maybeA {
            case Some(_): maybeA;
            case None   : genOther();
        }

    static function toArray<A>(maybeA:Option<A>):Iterable<A> return switch maybeA {
        case Some(a): [a];
        case None   : [];
    }

    static function toNullable<A>(maybeA:Option<A>):Null<A> return switch maybeA {
        case Some(a): a;
        case None   : null;
    }

    static function traceMessage<A>(maybeA:Option<A>, messageWhenNone:()->String):Option<A> return
        maybeA.mutate(
            discard
        ,   () -> trace(messageWhenNone())
        );

    static function traceValue<A>(maybeA:Option<A>):Option<A> return
        maybeA.mutate(
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