package interlude.macro;

import haxe.macro.Printer;
import haxe.macro.Context;
import haxe.macro.Expr;

/**
    Adds a new meta for functions which:  
    - satisfies the function's return type automatically  
    - at compile time, emits a warning  
    - at runtime, throws a `NotImplementedException`  
    These properties help enable a basic form of *Type*-driven developmemt.

    ```haxe
    @:build(interlude.macro.NotImplemented.build())
    class Example {
        @notimpl // Warning : Notimpl: `foo` is not implemented.
        public static function foo();

        @notimpl('MESSAGE') // Warning : Notimpl: `bar` is not implemented. ('MESSAGE')
        public static function bar():Unit {
            // @notimpl allows this to compile with an incomplete implementation
            // At runtime, this will `throw new NotImplementedException('MESSAGE');`
        }
    }
    ```
**/
class NotImplemented {
    public static macro function build():Array<Field> return
        Context.getBuildFields().map(field -> {
            var printer = new Printer();
            var notImpls = field.meta.filter(meta -> meta.name.toLowerCase() == 'notimpl');
            switch field.kind {
                case FFun(f) if(notImpls.any()):
                    var notes = notImpls
                        .mapL(meta -> meta.params)
                        .nonNull()
                        .mapS(params -> printer.printExprs(params, ', '))
                        .join(', ');

                    var message = 'Notimpl: `${field.name}` is not implemented. ${notes.let(x -> x.length > 0 ? '($x)' : x)}';
                    Context.warning(message, field.pos);

                    f.expr = macro @:pos(field.pos) {
                        throw new haxe.exceptions.NotImplementedException($v{notes});
                        ${ f.expr == null ? macro {} : f.expr };
                    }
                case _:
            }
            field;
        });
}