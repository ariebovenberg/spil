class Scanner {
  var s:String;
  var i:Int;

  public function new(s:String) {
    this.s = s;
    i = 0;
  }

  // if there is no next, an empty string is returned
  public function peek():String {
    return s.charAt(i);
  }

  /* public function recede():Void { */
  /*   i = Math.min(i - 1, 0); */
  /* } */

  public function hasNext():Bool {
    return i < s.length;
  }

  // if there is no next, an empty string is returned
  public function next() {
    return s.charAt(i++);
  }
}

enum Token {
  Integer(v: Int);
}

typedef Char = Int;  // Ascii-encoded byte

class Spil {

  public static inline final ASCII_NINE = 57;
  public static inline final ASCII_ZERO = 48;
  public static inline final ASCII_a = 97;
  public static inline final ASCII_z = 122;
  public static inline final ASCII_A = 65;
  public static inline final ASCII_Z = 90;

  static public function main():Void {
    var content = sys.io.File.getContent(Sys.args()[0]);
    var scan = new Scanner(content);
    var result = [
      for (char in scan)
      switch char.charCodeAt(0) {
        case null: return;
        case isDigit(_) => true: parse_digit(scan);
        case isIdentifierStart(_) => true: parse_identifier(scan);
        case _: throw 'Invalid character: `$char`';
      }
    ];
    trace(scan.peek());
    trace(scan.peek());
    trace(scan.next());
    trace(scan.peek());

    /* trace([for (i in new Scanner(content)) i]); */
  }

  static private function parse_digit(s: Scanner):Token {
    return Integer(5);
  }

  static private function parse_identifier(s: Scanner):Token {
    return Integer(5);
  }

  static private function isDigit(c: Char):Bool {
    return if (ASCII_NINE >= c && c >= ASCII_ZERO) true else false;
  }

  static private function isIdentifierStart(c: Char):Bool {
    // a-z or A-Z
    return if ((ASCII_z > c && c > ASCII_a) || (ASCII_Z > c && c > ASCII_A)) true else false;
  }
}
