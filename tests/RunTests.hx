package ;

import haxe.unit.TestCase;
import haxe.unit.TestRunner;
import tink.Stringly;

using tink.CoreApi;

class RunTests extends TestCase {
  
  function testStringify() {
    inline function eq(a:String, b:Stringly, ?pos) {
      assertEquals(a, b, pos);
    }
    
    
    eq('100', 100);
    eq('123.456', 123.456);
    eq('true', true);
    eq(#if java '1.483232461E12' #elseif interp '1.483232461e+12' #else '1483232461000' #end, utc(2017,0,1,1,1,1));
    eq('just some string', 'just some string');
  }
  
  function testParseInt() {
    
    inline function invalidInt(val:Stringly, ?pos) 
      assertFalse(val.parseInt().isSuccess(), pos);
    
    invalidInt('10g');
    invalidInt('10.34');
    
    inline function eq(a:Int, b:Stringly, ?pos) 
      assertEquals(a, b, pos);
      
    for (i in 0...50) {
      var v = Std.random(100000000);
      eq(v,   v );
      eq(v, '$v');  
    }
  }
  

  function testParseFloat() {
    
    inline function invalidFloat(val:Stringly, ?pos) 
      assertFalse(val.parseFloat().isSuccess(), pos);
    
    invalidFloat('10g');
    invalidFloat('10.34.5');
    
    inline function eq(a:Float, b:Stringly, ?pos) 
      assertEquals(a, b, pos);
      
    for (i in 0...50) {
      var v = Std.parseFloat(Std.string(i * Math.random() / Math.random()));
      eq(v,   v );
      eq(v, '$v');  
    }
  }  
  
  function testParseDate() {
    
    inline function invalidDate(val:Stringly, ?pos) 
      assertFalse(val.parseDate().isSuccess(), pos);
    
    invalidDate('a');
    invalidDate('2a');
    invalidDate('2017-01-01');
    invalidDate('01:01:01');
    invalidDate('20:00Z');
    invalidDate('2017-01-01 01:01:01');
    invalidDate('2017-01-01T01:01:01');
    invalidDate('2017-01-01A01:01:01Z');
    invalidDate('2017-01-01T01:01:01*00:00');
    invalidDate('2017-01-01T01:01:01.000*00:00');
    
    inline function eq(a:Date, b:Stringly, ?pos)
      assertEquals(a.toString(), (b:Date).toString(), pos);
    
     // timestamp (UTC)
    eq(utc(2017,0,1,1,1,1), '1483232461000');
    
    // ISO 8601
    eq(utc(2017,0,1,1,1,1), '2017-01-01T01:01:01Z');
    eq(utc(2017,0,1,1,1,1), '2017-01-01T01:01:01+00:00');
    eq(utc(2017,0,1,1,1,1), '2017-01-01T09:01:01+08:00');
    eq(utc(2017,0,1,1,1,1), '2017-01-01T01:01:01.000Z');
    eq(utc(2017,0,1,1,1,1), '2017-01-01T01:01:01.000+00:00');
    eq(utc(2017,0,1,1,1,1), '2017-01-01T09:01:01.000+08:00');
    
    eq(utc(2017,2,4,12,13,14), '2017-03-04T12:13:14Z');
    eq(utc(2017,3,15,1,1,1), '2017-04-15T01:01:01+00:00');
    eq(utc(2017,7,31,15,1,1), '2017-08-31T23:01:01+08:00');
    eq(utc(2017,11,31,1,1,1), '2017-12-31T01:01:01.000Z');
    eq(utc(1970,0,1,0,0,0), '1970-01-01T00:00:00.000+00:00');
    
    // negative timezones
    eq(utc(2017,0,1,17,1,1), '2017-01-01T09:01:01-08:00');
    eq(utc(2017,0,1,17,1,1), '2017-01-01T09:01:01.000-08:00');
    
     // leap year check
    eq(utc(1970,1,27,0,0,0), '1970-02-27T00:00:00Z');
    eq(utc(1970,1,28,0,0,0), '1970-02-28T00:00:00Z');
    eq(utc(1970,2,1,0,0,0), '1970-03-01T00:00:00Z');
    eq(utc(1972,1,27,0,0,0), '1972-02-27T00:00:00Z');
    eq(utc(1972,1,28,0,0,0), '1972-02-28T00:00:00Z');
    eq(utc(1972,1,29,0,0,0), '1972-02-29T00:00:00Z');
    eq(utc(1972,2,1,1,0,0), '1972-03-01T01:00:00Z');
    eq(utc(2003,1,27,1,0,0), '2003-02-27T01:00:00Z');
    eq(utc(2003,1,28,1,0,0), '2003-02-28T01:00:00Z');
    eq(utc(2003,2,1,1,0,0), '2003-03-01T01:00:00Z');
    eq(utc(2004,1,27,1,0,0), '2004-02-27T01:00:00Z');
    eq(utc(2004,1,28,1,0,0), '2004-02-28T01:00:00Z');
    eq(utc(2004,1,29,1,0,0), '2004-02-29T01:00:00Z');
    eq(utc(2004,2,1,1,0,0), '2004-03-01T01:00:00Z');
  }
  
  function testParseBool() {
    function bool(s:String):Bool
      return (s : Stringly);
      
    assertTrue(bool('true'));
    assertTrue(bool('yes'));
    assertTrue(bool('1'));
    assertTrue(bool('2'));
    assertTrue(bool('whatever'));
    
    assertFalse(bool('false'));
    assertFalse(bool('no'));
    assertFalse(bool('0'));
    assertFalse(bool(null));
  }
  
  function testCommaSeparatedArray() {
    function string(s:String):tink.stringly.CommaSeparatedArray<String>
      return (s : Stringly);
    function int(s:String):tink.stringly.CommaSeparatedArray<Int>
      return (s : Stringly);
    function float(s:String):tink.stringly.CommaSeparatedArray<Float>
      return (s : Stringly);
    function bool(s:String):tink.stringly.CommaSeparatedArray<Bool>
      return (s : Stringly);
    
    var v = string('a,b,c,d,e');
    for(i in 0...v.length) assertEquals(97 + i, v[i].charCodeAt(0));
    
    var v = int('1,2,3,4,5');
    for(i in 0...v.length) assertEquals(i + 1, v[i]);
    
    var v = float('1.1,2.2,3.3,4.4,5.5');
    for(i in 0...v.length) assertEquals((i + 1) + (i + 1) / 10, v[i]);
    
    var v = bool('true,yes,1,2,whatever');
    for(i in 0...v.length) assertTrue(v[i]);
    
    var v = bool('false,no,0');
    for(i in 0...v.length) assertFalse(v[i]);
  }

  function utc(y, m, d, H, M, S)
    return DateTools.delta(new Date(y, m, d, H, M, S), -Date.fromString('1970-01-01 00:00:00').getTime());
  
  static function main() {
    var runner = new TestRunner();
    runner.add(new RunTests());
    travix.Logger.exit(if (runner.run()) 0 else 500);
  }
  
}
