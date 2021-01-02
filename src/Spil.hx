class Spil {
    static public function main():Void {
        var content = sys.io.File.getContent(Sys.args()[0]);
        var scan = new Scanner(content);
        trace(Parser.parseSequence(scan, null));
    }
}

class Parser {

    public static function parseSequence(s: Scanner, terminator: Null<Char>):Array<Atom> {
        var result = new Array<Atom>();
        while (true) {
            if (s.peek() == terminator) {
                s.next();
                break;
            } else if (s.peek() == ASCII_SEMICOLON) {
                s.takeWhile((c:Char) -> c != ASCII_NEWLINE);
            } else {
                switch parseAtom(s) {
                    case null: throw 'Unexpected end of sequence';
                    case atom: result.push(atom);
                }
            }
            s.takeWhile(isWhitespace);
        }
        return result;
    }

    public static function parseAtom(s: Scanner):Null<Atom> {
        return switch s.peek() {
            case null: null;
            case isWhitespace(_) => true: {s.takeWhile(isWhitespace); parseAtom(s);};
            case isDigit(_) => true: parseInt(s);
            case isLetter(_) => true: parseSymbol(s);
            case ASCII_LPAR: {
                s.next();
                Atom.List(parseSequence(s, ASCII_RPAR));
            };
            case ASCII_QUOTE: parseString(s);
            case other: throw 'Invalid character in file: `${String.fromCharCode(other)}`, ASCII code ${s.current()}';
        }
    }

    public static function parseInt(s: Scanner):Atom {
        return Integer(Std.parseInt(s.takeWhile(isDigit)));
    }

    public static function parseSymbol(s: Scanner):Atom {
        return Symbol(
            s.takeWhile(
                (c:Char) -> (
                    isDigit(c)
                    || isLetter(c)
                    || c == ASCII_DASH
                    || c == ASCII_UNDERSCORE
                )
            )
        );
    }

    public static function parseString(s: Scanner):Atom {
        var result = new StringBuf();
        var first = s.next();  // skip the initial quote
        while (s.next() != ASCII_QUOTE) {
            result.addChar(
                switch s.current() {
                    case ASCII_BACKSLASH: {
                        switch s.next() {
                            case ASCII_BACKSLASH: ASCII_BACKSLASH;
                            case ASCII_QUOTE: ASCII_QUOTE;
                            case _: throw 'Unexpected escape sequence: `${String.fromCharCode(s.current())}`.';
                        };
                    };
                    case isPrintable(_) => true: s.current();
                    case _: throw 'Unexpected character in string: `${String.fromCharCode(s.current())}`.';
                }
            );
        };
        return Str(result.toString());
    }

    static private function isDigit(c: Char):Bool {
        return ASCII_NINE >= c && c >= ASCII_ZERO;
    }

    static private function isWhitespace(c: Char):Bool {
        return (
            c == ASCII_SPACE
            || c == ASCII_NEWLINE
            || c == ASCII_TAB
            || c == ASCII_RETURN
        );
    }

    static private function isLetter(c: Char):Bool {
        return (
            (ASCII_a <= c && c <= ASCII_z)
            || (ASCII_A <= c && c <= ASCII_Z)
        );
    }

    static private function isPrintable(c: Char):Bool {
        return (ASCII_SPACE <= c && c < 255) || isWhitespace(c);
    }

    private static inline final ASCII_NINE = 57;
    private static inline final ASCII_ZERO = 48;
    private static inline final ASCII_a = 97;
    private static inline final ASCII_z = 122;
    private static inline final ASCII_A = 65;
    private static inline final ASCII_Z = 90;
    private static inline final ASCII_LPAR = 40;
    private static inline final ASCII_RPAR = 41;
    private static inline final ASCII_QUOTE = 34;
    private static inline final ASCII_NEWLINE = 10;
    private static inline final ASCII_RETURN = 13;
    private static inline final ASCII_TAB = 9;
    private static inline final ASCII_SPACE = 32;
    private static inline final ASCII_BACKSLASH = 92;
    private static inline final ASCII_SEMICOLON = 59;
    private static inline final ASCII_DASH = 45;
    private static inline final ASCII_UNDERSCORE = 95;
}

enum Atom {
    Integer(v: Int);
    Str(s: String);
    Symbol(name: String);
    List(as: Array<Atom>);
}

typedef Char = Int;  // Ascii-encoded byte (0-255)


class Scanner {
    var s:String;
    var pos:Int;

    public function new(s:String) {
        this.s = s;
        pos = 0;
    }

    public function hasNext():Bool {
        return pos < s.length;
    }

    public function next():Null<Char> {
        return s.charCodeAt(pos++);
    }

    public function current():Null<Char> {
        return s.charCodeAt(pos - 1);
    }

    public function peek():Null<Char> {
        return s.charCodeAt(pos);
    }

    public function takeWhile(f: Char->Bool):String {
        var start = pos;
        for (char in this) {
            if (!f(char)) {
                pos--;
                break;
            }
        }
        return s.substring(start, pos);
    }
}
