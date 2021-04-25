package interlude.macro;

using haxe.Http;
using haxe.Json;
using haxe.macro.Context;
using sys.io.File;

/**
    Uses some example JSON data to add fields to a type at compile time. Can use
    an inline JSON string, a local file, or web content.

    ```haxe
    @:structInit
    @:build(interlude.macro.JsonProvider.sampleString('{ "foo": 123.45 }'))
    class Example {}

    ...

    var a:Example = {}; // Object requires field foo
    var b:Example = { foo: "bar" }; // String should be Float
    ```
**/
class JsonProvider {
#if macro
    public static macro function sampleString(json:String):Array<Field> return
        json
            .parse()
            .combineFields();

    public static macro function sampleFile(jsonPath:String):Array<Field> return
        jsonPath
            .getContent()
            .parse()
            .combineFields();

    public static macro function sampleWeb(url:String):Array<Field> return
        url
            .requestUrl()
            .parse()
            .combineFields();

    static function combineFields(dyn:Dynamic):Array<Field> return
        Context
            .getBuildFields()
            .concat(fromDynamic(dyn));

    static function fromDynamic(dyn:Dynamic):Array<Field> return {
        var fields = Reflect.fields(dyn);

        fields.map(fs -> {
            var value = Reflect.field(dyn, fs);
            var type = Context
                .typeof(macro $v{value})
                .toComplexType();

            {   name    : fs
            ,   pos     : Context.currentPos()
            ,   kind    : FVar(type, null)
            ,   access  : [APublic]
            ,   doc     : null
            ,   meta    : null }
        });
    }
#end
}