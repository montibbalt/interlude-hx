package interlude.ds;

/**
    Represents a weighted probability distribution. Supports a tree-structure for
    weights with `Weighted<Weighted<A>>`  
    ```haxe
      enum Coin { H; T; }

      // Heads and Tails equally likely
      var fairCoin = [H, T].uniform();
      var fairFlips = [
          for(i in 0...10)
              fairCoin.draw(Math.random)
      ]; // ex: [T,H,H,T,T,H,T,T,H,T]

      // Tails much more likely than Heads
      var unfairCoin = [H.with(0.25), T.with(0.75)];
      var unfairFlips = [
          for(i in 0...10)
              unfairCoin.draw(Math.random)
      ]; // ex: [T,T,T,T,H,T,H,T,T,H]
    ```
 **/
@:forward(iterator)
@:arrayAccess
@:publicFields
abstract Weighted<A:NotVoid>(Iterable<Pair<A, Float>>) from Iterable<Pair<A, Float>> to Iterable<Pair<A, Float>> {
    @:allow(interlude.ds)
    inline public function new(weights:Iterable<Pair<A, Float>>)
        this = weights;

    @:from
    static function fromIterable<A>(value:Iterable<Pair<A, Float>>):Weighted<A> return
        new Weighted(value);
        //value.normalize();

    public function asArray():Array<Pair<A, Float>> return
        this.toArray();

    public function toString():String return
        [for(pair in this.normalize()) '${pair._2} => ${pair._1}'].join('\n');

    /**
        Lifts a single value into a weighted distribution
    **/
    public static function asWeighted<A>(t:A):Weighted<A> return
        [t].uniform();

    /**
        Draws a single result from a weighted set. `randomGen` should be a
        function that generates a random value between 0 and 1, e.g. `Math.random`  
        Clamps the output of `randomGen` between 0.0 and 1.0
    **/
    public static function draw<A>(dist:Weighted<A>, randomGen:()->Float):A return {
        var rand = randomGen().max(0.0).min(1.0);

        var index = dist
            .scan_(0.0, (acc, val) -> acc + val._2)
            .takeWhile(acc -> acc < rand)
            .count();
        dist.toArray()[index]._1;
    }

    /**
        Draws a result from a weighted set and returns its index. `randomGen`
        should be a function that generates a random value between 0 and 1, 
        e.g. `Math.random`  
        Clamps the output of `randomGen` between 0.0 and 1.0
    **/
    public static function drawIndex<A>(dist:Weighted<A>, randomGen:()->Float):Int return {
        var rand = randomGen().max(0.0).min(1.0);

        dist.scan_(0.0, (acc, val) -> acc + val._2)
            .takeWhile(acc -> acc < rand)
            .count();
    }

    /**
        Projects each element of a weighted distribution of `A` to a distribution
        of type `B`, and flattens the results  
        Monadic bind/flatMap
    **/
    public static function flatMap<A, B>(dist:Weighted<A>, fn:A->Weighted<B>):Weighted<B> return
        dist.map(fn).flatten();

    /**
        Flattens one layer of a probability tree by multiplying weights together
    **/
    public static function flatten<A>(dists:Weighted<Weighted<A>>):Weighted<A> return [
        for(dist in dists.normalize())
            for(d in dist._1.normalize())
                d._1.with(dist._2 * d._2)
    ];

    /**
        Maps the `A` elements of a weighted distribution to a type `B` using `fn`  
        ```haxe
        [123.with(1)].map(x -> '$x') == ['123'.with(1)];
        ```
     **/
    public static function map<A, B>(dist:Weighted<A>, fn:A->B):Weighted<B> return [
        for(t in dist)
            fn(t._1).with(t._2)
    ];

    /**
        Normalizes large weights to numbers between 0 and 1  
        ```haxe
        ['abc'.with(450), 'def'.with(50)].normalize() == ['abc'.with(0.9), 'def'.with(0.1)];
        ```
    **/
    public static function normalize<A>(dist:Weighted<A>):Weighted<A> return {
        var total = 0.0;
        for(pair in dist)
            total += pair._2;

        new Weighted([for(pair in dist) pair._1.with(pair._2 / total) ]);
    }

    /**
        Pretty-prints the weights in a distribution
    **/
    public static function show<A>(dist:Weighted<A>):String return [
        for(pair in dist)
            '${pair._1}: ${pair._2}'
    ].join(',\n');

    /**
        Creates an even set of weights from a list of elements
    **/
    public static function uniform<A>(vals:Iterable<A>):Weighted<A> return
        vals.mapL(a -> a.with(1.0)).normalize().toArray();
}