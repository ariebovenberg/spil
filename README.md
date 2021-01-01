Spil
====

A simple lisp parser in Haxe.
Currently supported:

- integers
- strings
- symbols
- comments
- lists

Development guide
-----------------

### Requirements

- `haxe`. on MacOS: `brew install haxe`.

The following haxe libraries (`haxelib install <library>`):

- `munit` (2.3.5)
- `hamcrest` (3.0.0)

### Running

```bash
haxe -p src --run Spil example.lisp
```

### Tests

```bash
haxelib run munit test
```
