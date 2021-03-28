package interlude.func;

@:nullSafety(Strict)
@:publicFields
class Curry2 {
    /**
        Convert 1 function of 2 arguments into 2 functions of 1 argument  
        `((a, b) -> a + b).curry()` == `a -> b -> a + b`
     **/
    inline static function curry<A, B, Z>(fn:(A, B)->Z):A->(B->Z) return
        a -> fn.bind(a);

    /**
        Convert 2 functions of 1 argument into 1 function of 2 arguments  
        `(a -> b -> a + b).uncurry()` == `(a, b) -> a + b`
    **/
    inline static function uncurry<A, B, Z>(fn:A->(B->Z)):(A, B)->Z return
        (a, b) -> fn(a)(b);
}

@:nullSafety(Strict)
@:publicFields
class Curry3 {
    static function curry<A, B, C, Z>(f:(A, B, C)->Z):A->(B->(C->Z)) return
        a -> b -> f.bind(a, b);

    static function uncurry<A, B, C, Z>(f:A->(B->(C->Z))):A->B->C->Z return
        (a, b, c) -> f(a)(b)(c);
}

@:nullSafety(Strict)
@:publicFields
class Curry4 {
    static function curry<A, B, C, D, Z>(f:(A, B, C, D)->Z):A->(B->(C->(D->Z))) return
        a -> b -> c -> f.bind(a, b, c);

    static function uncurry<A, B, C, D, Z>(f:A->(B->(C->(D->Z)))):A->B->C->D->Z return
        (a, b, c, d) -> f(a)(b)(c)(d);
}

@:nullSafety(Strict)
@:publicFields
class Curry5 {
    static function curry<A, B, C, D, E, Z>(f:(A, B, C, D, E)->Z):A->(B->(C->(D->(E->Z)))) return
        a -> b -> c -> d -> f.bind(a, b, c, d);

    static function uncurry<A, B, C, D, E, Z>(f:A->(B->(C->(D->(E->Z))))):A->B->C->D->E->Z return
        (a, b, c, d, e) -> f(a)(b)(c)(d)(e);
}

@:nullSafety(Strict)
@:publicFields
class Curry6 {
    static function curry<A, B, C, D, E, F, Z>(f:(A, B, C, D, E, F)->Z):A->(B->(C->(D->(E->(F->Z))))) return
        a -> b -> c -> d -> e -> f.bind(a, b, c, d, e);

    static function uncurry<A, B, C, D, E, F, Z>(fn:A->(B->(C->(D->(E->(F->Z)))))):A->B->C->D->E->F->Z return
        (a, b, c, d, e, f) -> fn(a)(b)(c)(d)(e)(f);
}