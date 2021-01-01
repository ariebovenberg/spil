package;

import Spil;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

class ParserTest
{
	public function new()
	{
	}

	@Test
	public function testParseInt()
	{
    var s = new Spil.Scanner('5 985 0 9');
    Assert.areEqual(Spil.Atom.Integer(5), Spil.Parser.parseInt(s));
    s.next();
    Assert.areEqual(Spil.Atom.Integer(985), Spil.Parser.parseInt(s));
    s.next();
    Assert.areEqual(Spil.Atom.Integer(0), Spil.Parser.parseInt(s));
    s.next();
    Assert.areEqual(Spil.Atom.Integer(9), Spil.Parser.parseInt(s));
	}

	@Test
	public function testParseSymbol()
	{
    var s = new Spil.Scanner("k foo foo-Bar hello_world");
    Assert.areEqual(Spil.Atom.Symbol("k"), Spil.Parser.parseSymbol(s));
    s.next();
    Assert.areEqual(Spil.Atom.Symbol("foo"), Spil.Parser.parseSymbol(s));
    s.next();
    Assert.areEqual(Spil.Atom.Symbol("foo-Bar"), Spil.Parser.parseSymbol(s));
    s.next();
    Assert.areEqual(Spil.Atom.Symbol("hello_world"), Spil.Parser.parseSymbol(s));
	}

	@Test
	public function testParseString()
	{
    var s = new Spil.Scanner('"k""bla""with\nnewline""wi\\\\th\\"escape!"');
    Assert.areEqual(Spil.Atom.Str('k'), Spil.Parser.parseString(s));
    Assert.areEqual(Spil.Atom.Str('bla'), Spil.Parser.parseString(s));
    Assert.areEqual(Spil.Atom.Str('with\nnewline'), Spil.Parser.parseString(s));
    Assert.areEqual(Spil.Atom.Str('wi\\th"escape!'), Spil.Parser.parseString(s));
	}

	@Test
	public function testParseSequenceEmpty()
	{
    var s = new Spil.Scanner('] foo');
    Assert.areEqual(
        [], Spil.Parser.parseSequence(s, "]".code)
    );
  }

	@Test
	public function testParseSequenceNullTerminator()
	{
    var s = new Spil.Scanner('foo 5');
    Assert.areEqual(
        [Spil.Atom.Symbol("foo"), Spil.Atom.Integer(5)],
        Spil.Parser.parseSequence(s, null)
    );
  }

	@Test
	public function testParseSequenceExample()
	{
    var s = new Spil.Scanner('5 "foo" ; comment \n     bla) not-included');
    Assert.areEqual(
        [Spil.Atom.Integer(5), Spil.Atom.Str('foo'), Spil.Atom.Symbol('bla')],
        Spil.Parser.parseSequence(s, ")".code)
    );
	}

	@Test
	public function testParseAtom()
	{
    var s = new Spil.Scanner('"foo" 934 (4 5) my-symbol');
    Assert.areEqual(Spil.Atom.Str('foo'), Spil.Parser.parseAtom(s));
    Assert.areEqual(Spil.Atom.Integer(934), Spil.Parser.parseAtom(s));
    Assert.isNotNull(Spil.Parser.parseAtom(s));
    Assert.areEqual(Spil.Atom.Symbol('my-symbol'), Spil.Parser.parseAtom(s));
    Assert.isNull(Spil.Parser.parseAtom(s));
	}
}
