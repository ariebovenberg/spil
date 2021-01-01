package;

import Spil;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

class ScannerTest
{
	public function new()
	{
	}

	@Test
	public function testEmpty()
	{
		var s = new Spil.Scanner("");
    Assert.isFalse(s.hasNext());
    Assert.isNull(s.current());
    Assert.isNull(s.peek());
    Assert.isNull(s.next());
    Assert.isNull(s.current());
    Assert.isNull(s.next());
    Assert.isNull(s.current());
	}

	@Test
	public function testIteration()
	{
		var s = new Spil.Scanner("foO");
    Assert.isNull(s.current());
    Assert.areEqual(s.peek(), "f".code);
    Assert.isTrue(s.hasNext());
    Assert.areEqual(s.next(), "f".code);

    Assert.areEqual(s.current(), "f".code);
    Assert.areEqual(s.peek(), "o".code);
    Assert.isTrue(s.hasNext());
    Assert.areEqual(s.next(), "o".code);

    Assert.areEqual(s.current(), "o".code);
    Assert.areEqual(s.peek(), "O".code);
    Assert.isTrue(s.hasNext());
    Assert.areEqual(s.next(), "O".code);

    Assert.areEqual(s.current(), "O".code);
    Assert.isNull(s.peek());
    Assert.isFalse(s.hasNext());
    Assert.isNull(s.next());
	}

	@Test
	public function testTakeWhile()
	{
    Assert.areEqual("", (new Spil.Scanner("")).takeWhile((c:Char) -> c == "f".code));

		var s = new Spil.Scanner("foooOoo bar");
    Assert.areEqual("", s.takeWhile((c:Char) -> c == "K".code));
    Assert.areEqual("", s.takeWhile((c:Char) -> c == "K".code));
    Assert.areEqual("f".code, s.next());
    Assert.areEqual("", s.takeWhile((c:Char) -> c == "K".code));
    Assert.areEqual("ooo", s.takeWhile((c:Char) -> c == "o".code));
    Assert.areEqual("o".code, s.current());
    Assert.areEqual("", s.takeWhile((c:Char) -> c == "F".code));
    Assert.areEqual("O", s.takeWhile((c:Char) -> c == "O".code));
    Assert.areEqual("", s.takeWhile((c:Char) -> c == "O".code));
    Assert.areEqual("o".code, s.next());
    Assert.areEqual("o", s.takeWhile((c:Char) -> c == "o".code));
    Assert.areEqual(" ".code, s.next());
    Assert.areEqual(" ".code, s.current());
    Assert.areEqual("bar", s.takeWhile((c:Char) -> c > 0));
	}
}
