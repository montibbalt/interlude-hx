package interlude.func;

@:nullSafety(Strict)
@:publicFields
class Curry2 {
    /**
        Convert 1 function of 2 arguments into 2 functions of 1 argument
        ```haxe
        ((a, b) -> a + b).curry() == a -> b -> a + b;
        ```
     **/
    inline static function curry<A, B, Z>(fn:(A, B)->Z):A->(B->Z) return
        a -> fn.bind(a);

    /**
        Convert 2 functions of 1 argument into 1 function of 2 arguments  
        ```haxe
        (a -> b -> a + b).uncurry() == (a, b) -> a + b;
        ```
    **/
    inline static function uncurry<A, B, Z>(fn:A->(B->Z)):(A, B)->Z return
        (a, b) -> fn(a)(b);
}

@:nullSafety(Strict)
@:publicFields
class Curry3 {
    /**
        Convert 1 function of 3 arguments into 3 functions of 1 argument  
        ```haxe
        ((a, b, c) -> a + b + c).curry() == a -> b -> c -> a + b + c;
        ```
     **/
    static function curry<A, B, C, Z>(f:(A, B, C)->Z):A->(B->(C->Z)) return
        a -> b -> f.bind(a, b);

    /**
        Convert 3 functions of 1 argument into 1 function of 3 arguments  
        ```haxe
        (a -> b -> c -> a + b + c).uncurry() == (a, b, c) -> a + b + c;
        ```
    **/
    static function uncurry<A, B, C, Z>(f:A->(B->(C->Z))):A->B->C->Z return
        (a, b, c) -> f(a)(b)(c);
}

@:nullSafety(Strict)
@:publicFields
class Curry4 {
    /**
        Convert 1 function of 4 arguments into 4 functions of 1 argument  
        ```haxe
        ((a, b, c, d) -> a + b + c + d).curry() == a -> b -> c -> d -> a + b + c + d;
        ```
     **/
    static function curry<A, B, C, D, Z>(f:(A, B, C, D)->Z):A->(B->(C->(D->Z))) return
        a -> b -> c -> f.bind(a, b, c);

    /**
        Convert 4 functions of 1 argument into 1 function of 4 arguments  
        ```haxe
        (a -> b -> c -> d -> a + b + c + d).uncurry() == (a, b, c, d) -> a + b + c + d;
        ```
    **/
    static function uncurry<A, B, C, D, Z>(f:A->(B->(C->(D->Z)))):A->B->C->D->Z return
        (a, b, c, d) -> f(a)(b)(c)(d);
}

@:nullSafety(Strict)
@:publicFields
class Curry5 {
    /**
        Convert 1 function of 5 arguments into 5 functions of 1 argument  
        ```haxe
        ((a, b, c, d, e) -> a + b + c + d + e).curry() == a -> b -> c -> d -> e -> a + b + c + d + e;
        ```
     **/
    static function curry<A, B, C, D, E, Z>(f:(A, B, C, D, E)->Z):A->(B->(C->(D->(E->Z)))) return
        a -> b -> c -> d -> f.bind(a, b, c, d);

    /**
        Convert 5 functions of 1 argument into 1 function of 5 arguments  
        ```haxe
        (a -> b -> c -> d -> e -> a + b + c + d + e).uncurry() == (a, b, c, d, e) -> a + b + c + d + e;
        ```
    **/
    static function uncurry<A, B, C, D, E, Z>(f:A->(B->(C->(D->(E->Z))))):A->B->C->D->E->Z return
        (a, b, c, d, e) -> f(a)(b)(c)(d)(e);
}

@:nullSafety(Strict)
@:publicFields
class Curry6 {
    /**
        Convert 1 function of 6 arguments into 6 functions of 1 argument  
        ```haxe
        ((a, b, c, d, e, f) -> a + b + c + d + e + f).curry() == a -> b -> c -> d -> e -> f-> a + b + c + d + e + f;
        ```
     **/
    static function curry<A, B, C, D, E, F, Z>(f:(A, B, C, D, E, F)->Z):A->(B->(C->(D->(E->(F->Z))))) return
        a -> b -> c -> d -> e -> f.bind(a, b, c, d, e);

    /**
        Convert 6 functions of 1 argument into 1 function of 6 arguments  
        ```haxe
        (a -> b -> c -> d -> e -> f -> a + b + c + d + e + f).uncurry() == (a, b, c, d, e, f) -> a + b + c + d + e + f;
        ```
    **/
    static function uncurry<A, B, C, D, E, F, Z>(fn:A->(B->(C->(D->(E->(F->Z)))))):A->B->C->D->E->F->Z return
        (a, b, c, d, e, f) -> fn(a)(b)(c)(d)(e)(f);
}