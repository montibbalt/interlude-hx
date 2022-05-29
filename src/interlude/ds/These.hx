package interlude.ds;

enum These<A, B> {
    This(a:A);
    That(b:B);
    These(a:A, b:B);
}

@:nullSafety(Strict)
@:publicFields
class TheseTools {
    static function ap<A:Appendable<A>, B, Z>(fn:These<A, B->Z>, t:These<A, B>):These<A, Z> return switch [fn, t] {
        case [This(a), _]: This(a);
        case [That(_), This(a)]: This(a);
        case [That(f), That(b)]: That(f(b));
        case [That(f), These(a, b)]: These(a, f(b));
        case [These(a1, _), This(a2)]: This(a1.append(a2));
        case [These(a, f), That(b)]: These(a, f(b));
        case [These(a1, f), These(a2, b)]: These(a1.append(a2), f(b));
    }

    static function biMap<A, B, X, Y>(t:These<A, B>, mapThis:A->X, mapThat:B->Y):These<X, Y> return switch t {
        case This(a): This(mapThis(a));
        case That(b): That(mapThat(b));
        case These(a, b): These(mapThis(a), mapThat(b));
    }

    static function flatMap<A:{ append:A->A }, B>(t:These<A, A>, fn:A->These<A, B>):These<A, B> return switch t {
        case This(a): This(a);
        case That(a): fn(a);
        case These(a, b): switch fn(b) {
            case This(a2): This(a.append(a2));
            case That(b2): These(a, b2);
            case These(a2, b2): These(a.append(a2), b2);
        }
    }

    static function mergeTheseWith<A, B, Z>(t:These<A, B>, mapThis:A->Z, mapThat:B->Z, merge:Z->Z->Z):Z return switch t {
        case This(a): mapThis(a);
        case That(b): mapThat(b);
        case These(a, b): merge(mapThis(a), mapThat(b));
    }
}