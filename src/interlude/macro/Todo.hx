package interlude.macro;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Printer;

/**
    Adds new metas that print strings as compiler messages. The user can
    optionally pass an array of additional meta names which will be treated as
    warnings.

    ```haxe
    @:build(interlude.macro.Todo.build(['foo'])) // adds @foo in addition to @note and @todo
    class Example {
        @note('This will print some info') // output: "Note: 'This will print some info'"
        @todo(
            'This will',        // output: "Warning : Todo: 'This will'"
            'generate three',   //         "Warning : Todo: 'generate three'"
            'compiler warnings' //         "Warning : Todo: 'compiler warnings'"
        )
        @foo('user-defined warning')   // output: "Warning : Foo: 'User-defined warning'"
        final foo:Int = 0;
    }
    ```
**/
@:nullSafety(Strict)
class Todo {
    static var printNames = new Map<String, String>();

    public static macro function build(?userDefined:Array<String>):Array<Field> return {
        var fields = Context.getBuildFields();
        var printer = new Printer();
        var validTags = ['note', 'todo'].concat(userDefined == null ? [] : userDefined.toArray());

        fields
            .flatMap(field -> field.meta.filter(meta -> validTags.contains(meta.name
                .replace(':', '')
                .toLowerCase()
            )))
            .mutate(meta -> meta.params.mutate(expr -> {
                var noColon = meta.name.replace(':', '');
                var lowercaseName = noColon.toLowerCase();
                var printName = printNames.withKeyOrInsertNew(lowercaseName, () -> '${noColon.substr(0, 1).toUpperCase()}${noColon.substr(1)}');
                var printFn = lowercaseName == 'note'
                    ? Context.info
                    : Context.warning;
                printFn('$printName: ${printer.printExpr(expr)}', expr.pos);
            }));

        fields;
    }
}