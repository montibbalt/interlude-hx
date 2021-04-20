package interlude.ds;

@:publicFields
@:nullSafety(Strict)
class EitherTools {
    static function ap<A, B, C>(fn:Either<A, B->C>, e:Either<A, B>):Either<A, C> return
        fn.flatMap(e.map);

    inline static function asLeft<A:NotVoid, B>(a:A):Either<A, B> return
        Left(a);

    inline static function asRight<A, B:NotVoid>(b:B):Either<A, B> return
        Right(b);

    static function flatMap<A, B, C>(e:Either<A, B>, fn:B->Either<A, C>):Either<A, C> return switch e {
        case Left(a)    : Left(a);
        case Right(b)   : fn(b);
    }

    static function lefts<A, B>(es:Iterable<Either<A, B>>):Iterable<A> return
        es.flatMap(either -> either.match(l -> [l], r -> []));

    static function map<A, B, C>(e:Either<A, B>, f:B->C):Either<A, C> return switch e {
        case Left(a)    : Left(a);
        case Right(b)   : Right(f(b));
    }

    static function match<A, B, C>(e:Either<A, B>, whenLeft:A->C, whenRight:B->C):C return switch e {
        case Left(a)    : whenLeft(a);
        case Right(b)   : whenRight(b);
    }

    static function mutate<A, B>(e:Either<A, B>, whenLeft:A->Void, whenRight:B->Void):Either<A, B> return {
        switch e {
            case Left(a)    : whenLeft(a);
            case Right(b)   : whenRight(b);
        }
        e;
    }

    static function mutate_<A, B>(e:Either<A, B>, whenRight:B->Void):Either<A, B> return {
        switch e {
            case Left(a)    :
            case Right(b)   : whenRight(b);
        }
        e;
    }

    static function rights<A, B>(es:Iterable<Either<A, B>>):Iterable<B> return
        es.flatMap(either -> either.match(l -> [], r -> [r]));

    static function toNullable<A, B>(e:Either<A, B>):Null<B> return switch e {
        case Left(_)    : null;
        case Right(b)   : b;
    }

    static function toOption<A, B:NotVoid>(e:Either<A, B>):Option<B> return switch e {
        case Left(a)    : None;
        case Right(b)   : Some(b);
    }

    static function toOutcome<A, B:NotVoid>(e:Either<A, B>, ?pos:haxe.PosInfos):Outcome<B> return switch e {
        case Left(a)    : Failure('Converted to Outcome: Left($a)', pos);
        case Right(b)   : Success(b);
    }

    static function zip<X, A, B>(eA:Either<X, A>, eB:Either<X, B>):Either<X, Pair<A, B>> return
        eA.zipWith(eB, Pair.with);

    static function zipWith<X, A, B, C>(eA:Either<X, A>, eB:Either<X, B>, fn:A->B->C):Either<X, C> return switch [eA, eB] {
        case [Right(a), Right(b)]       : fn(a, b).asRight();
        case [Left(x), _] | [_, Left(x)]: x.asLeft();
    }
}