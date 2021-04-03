# interlude
A library of helpful types and static extensions in pure Haxe. It should be
usable on all targets as well as inside macros.

## Installation
Interlude is available on haxelib:
```
haxelib install interlude
```  
To include it in your project, add `-lib interlude` to your project's build
parameters.

## Usage
### Quickstart
The easiest way to use Interlude is to add `using Interlude;` to your
`import.hx` or at the top of each file. This will automatically import
everything. An example import file can be found in
[`src/import.hx`](https://github.com/montibbalt/interlude-hx/blob/default/src/import.hx);
it is the one Interlude itself uses.

### Specific Packages
If you'd like to import specific parts of Interlude, each package has its own
shortcut. For example, to import everything in the `func` package, you can add
`using interlude.Func;` at the top of a file.  

For fine control, each of the "Tools" classes are usable in a similar way
individually.

### Building
To build the package, simply run `haxe build.hxml`. Individual targets can be 
found in `/hxml`.  

If you'd like to build the API documentation, run:
```
haxelib install dox
haxe hxml/build-dox.hxml
```
