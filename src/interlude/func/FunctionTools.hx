package interlude.func;

@:nullSafety(Strict)
@:publicFields
class FunctionTools {

    /**
        Calls a function with a single argument.  
        Can be called repeatedly if the return type is a function
    **/
    inline static function ap<A, B>(fn:A->B, a:A):B return
        fn(a);

    /**
        Swaps the order of two function arguments
    **/
    inline static function flip<A, B, C>(fn:A->B->C):B->A->C return
        (b, a) -> fn(a, b);

    /**
        Calls a function that generates a value from nothing
    **/
    inline static function gen<A>(generator:()->A):A return
        generator();

    /**
        Produces a function that inverts the result of a function returning `Bool`
    **/
    inline static function not<A>(fn:A->Bool):A->Bool return
        a -> !fn(a);

    /**
        Composes two functions
    **/
    inline static function of<A, B, C>(bc:B->C, ab:A->B):A->C return
        a -> bc(ab(a));

    /**
        Composes two functions in reverse order, like a pipeline operator
    **/
    inline static function to<A, B, C>(ab:A->B, bc:B->C):A->C return
        bc.of(ab);

    /**
        Builds a function that returns a transformed value if it matches some `predicate`, or `None` if it doesn't
    **/
    inline static function when<A, B>(transform:A->B, predicate:A->Bool):A->Option<B> return a -> predicate(a)
        ? transform(a).asOption()
        : None;
}