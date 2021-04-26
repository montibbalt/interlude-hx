package interlude.macro;

import haxe.macro.Expr;

using haxe.Http;
using haxe.macro.Context;
using haxe.Json;
using Reflect;
using sys.io.File;

/**
    Uses some example JSON data to add fields to a type at compile time. Can use
    an inline JSON string, a local file, or web content.

    ```haxe
    @:structInit
    @:build(interlude.macro.JsonProvider.sampleString('{ "foo": 123.45 }'))
    class Example {}

    ...

    var a:Example = {}; // Compile error: Object requires field foo
    var b:Example = { foo: "bar" }; // Compile error: String should be Float
    ```
**/
@:nullSafety(Strict)
class JsonProvider {
    public static macro function sampleString(json:String):Array<Field> return
        combineFields(json.parse());

    public static macro function sampleFile(jsonPath:String):Array<Field> return
        combineFields(jsonPath.getContent().parse());

    public static macro function sampleWeb(url:String):Array<Field> return
        combineFields(url.requestUrl().parse());

#if macro
    /** Appends the fields from some object to our existing type's fields **/
    static function combineFields(dyn:Dynamic):Array<Field> return
        Context
            .getBuildFields()
            .concat(fromDynamic(dyn));

    /** Extracts all of the `Field`s from some object **/
    static function fromDynamic(dyn:Dynamic):Array<Field> return
        dyn.fields().map(fieldName -> {
            name    : fixDashes(fieldName)
        ,   pos     : Context.currentPos()
        ,   kind    : FVar(Context.typeof(macro $v{dyn.field(fieldName)}).toComplexType(), null)
        ,   access  : [APublic]
        ,   doc     : null
        ,   meta    : null
        });

    /**
        Convert dashed-field-names to camelCase
        ```haxe
        fixDashes('foo-bar-Baz----Qux-1') == 'fooBarBazQux1';
        ```
    **/
    static function fixDashes(dashedInput:String):String return
        (~/\-+([a-z]?)/g).map(dashedInput, reg -> reg.matched(1).toUpperCase());
#end
}