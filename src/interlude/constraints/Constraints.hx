package interlude.constraints;

typedef HasLengthProperty = { var length(default, null):Int; }

typedef SizedIterable<X> = {
    > Iterable<X>,
    > HasLengthProperty,
}