import 'package:flutter_test/flutter_test.dart';
import 'package:my_string_util/MyStringUtil.dart';

void main() {
  test_compareExtend();
  test_toStandardPath();
  test_toUnixStandardPath();
  test_DirFilePath();
  test_removeSpace();
  test_isIgnoreCaseEqual();
  test_isIgnoreCaseContains();
}

void test_compareExtend() {
  test("compareExtend", () {
    // 0
    expect(MyStringUtil_c.compareExtend("", ""), 0);
    expect(MyStringUtil_c.compareExtend(" ", " "), 0);
    expect(MyStringUtil_c.compareExtend("123", "123"), 0);
    expect(MyStringUtil_c.compareExtend(" 123\t", " 123\t"), 0);
    expect(MyStringUtil_c.compareExtend(" #=k123abc\t\r\n", " #=k123abc\t\r\n"),
        0);
    expect(
        MyStringUtil_c.compareExtend("123 coolight 七千", "123 coolight 七千"), 0);
    // -1 左排前
    expect(MyStringUtil_c.compareExtend("", "   "), -1);
    expect(MyStringUtil_c.compareExtend(" ", "    "), -3);
    expect(MyStringUtil_c.compareExtend("1", "2"), -1);
    expect(MyStringUtil_c.compareExtend("1", "111"), 1 - 111);
    expect(MyStringUtil_c.compareExtend("2", "234"), 2 - 234);
    expect(MyStringUtil_c.compareExtend("77", "234"), 77 - 234);
    expect(MyStringUtil_c.compareExtend(" #= 你 77", " #= 你 234"), 77 - 234);
    expect(MyStringUtil_c.compareExtend(" #= 2 kkk", " #= 7"), 2 - 7);
    expect(MyStringUtil_c.compareExtend("123 cool 七", "123 cool z"), -1);
    expect(MyStringUtil_c.compareExtend("123 cool q", "123 cool 七八九"), -1);
    // +1 右排前
    expect(MyStringUtil_c.compareExtend("   ", ""), 1);
    expect(MyStringUtil_c.compareExtend("    ", " "), 3);
    expect(MyStringUtil_c.compareExtend("2", "1"), 1);
    expect(MyStringUtil_c.compareExtend("111", "1"), 111 - 1);
    expect(MyStringUtil_c.compareExtend("234", "2"), 234 - 2);
    expect(MyStringUtil_c.compareExtend("234", "77"), 234 - 77);
    expect(MyStringUtil_c.compareExtend(" #= 你 234", " #= 你 77"), 234 - 77);
    expect(MyStringUtil_c.compareExtend(" #= 7", " #= 2 kkk"), 7 - 2);
    expect(MyStringUtil_c.compareExtend("123 cool z", "123 cool 七"), 1);
    expect(MyStringUtil_c.compareExtend("123 cool 七八九", "123 cool q"), 1);
  });
}

void test_toStandardPath() {
  test("toStandardPath", () {
    expect(MyStringUtil_c.toStandardPath(r"//////"), "/");
    expect(MyStringUtil_c.toStandardPath(r"\\\\\"), r"\");
    expect(MyStringUtil_c.toStandardPath(r"\\\\\/\/\////\/"), r"\");
    expect(MyStringUtil_c.toStandardPath(r"a/b\d"), r"a/b\d");
    expect(MyStringUtil_c.toStandardPath(r"a///b\d"), r"a/b\d");
    expect(MyStringUtil_c.toStandardPath(r"a/b\\\d"), r"a/b\d");
    expect(MyStringUtil_c.toStandardPath(r"a/////b\\d"), r"a/b\d");
    expect(MyStringUtil_c.toStandardPath(r"///a/b\d"), r"/a/b\d");
    expect(MyStringUtil_c.toStandardPath(r"//a///b\\\\d/////"), r"/a/b\d/");
    expect(MyStringUtil_c.toStandardPath(r"\\\a///b\\\\d\\\"), r"\a/b\d\");
    expect(MyStringUtil_c.toStandardPath(r"/\\\a//b\/\\///d\\\/"), r"\a/b\d\");
  });
}

void test_toUnixStandardPath() {
  test("test_toUnixStandardPath", () {
    expect(MyStringUtil_c.toUnixStandardPath(r"\\\\\"), r"/");
    expect(MyStringUtil_c.toUnixStandardPath(r"\\\\\//////\/\/\/"), r"/");
    expect(MyStringUtil_c.toUnixStandardPath(r"a/b/d"), r"a/b/d");
    expect(MyStringUtil_c.toUnixStandardPath(r"a/b\d"), r"a/b/d");
    expect(MyStringUtil_c.toUnixStandardPath(r"\a\b/d\"), r"/a/b/d/");
    expect(
      MyStringUtil_c.toUnixStandardPath(r"\\\/\/\a/\\b\\\/\/d\//\/\\\"),
      r"/a/b/d/",
    );
  });
}

void test_DirFilePath() {
  test("测试目录文件路径相关工具", () {
    expect(MyStringUtil_c.getFileName(""), "");
    expect(MyStringUtil_c.getFileName("."), ".");
    expect(MyStringUtil_c.getFileName("..."), "...");
    expect(MyStringUtil_c.getFileName("...///\\"), "...");
    expect(MyStringUtil_c.getFileName("/"), "/");
    expect(MyStringUtil_c.getFileName("/////"), "/////");
    expect(MyStringUtil_c.getFileName("\\"), "\\");
    expect(MyStringUtil_c.getFileName("\\\\\\"), "\\\\\\");
    expect(MyStringUtil_c.getFileName("///\\\\//\\"), "///\\\\//\\");
    expect(MyStringUtil_c.getFileName(".", removeEXT: true), ".");
    expect(MyStringUtil_c.getFileName("./.", removeEXT: true), ".");
    expect(MyStringUtil_c.getFileName("abc/..", removeEXT: true), "..");
    expect(MyStringUtil_c.getFileName("abc..123", removeEXT: true), "abc.");
    expect(MyStringUtil_c.getFileName("abc.123.tar.gz"), "abc.123.tar.gz");
    expect(MyStringUtil_c.getFileName("123"), "123");
    expect(MyStringUtil_c.getFileName("123/"), "123");
    expect(MyStringUtil_c.getFileName("123\\"), "123");
    expect(MyStringUtil_c.getFileName("./123"), "123");
    expect(MyStringUtil_c.getFileName(".\\123"), "123");
    expect(
      MyStringUtil_c.getFileName("./123.456/", removeEXT: true),
      "123.456",
    );
    expect(MyStringUtil_c.getFileName("\\//455//\\123/\\//\\/\\\\"), "123");
    expect(MyStringUtil_c.getFileName(".///\\//\\/\\123"), "123");
    expect(MyStringUtil_c.getFileName("///\\//\\/\\\\//"), "///\\//\\/\\\\//");
    expect(MyStringUtil_c.getFileName(".///\\//\\/\\\\//"), ".");
  });
}

void test_removeSpace() {
  test("removeAllSpace", () {
    expect(MyStringUtil_c.removeAllSpace(""), "");
    expect(MyStringUtil_c.removeAllSpace("  \t \t     "), "");
    expect(MyStringUtil_c.removeAllSpace("   1 2   3 "), "123");
    expect(MyStringUtil_c.removeAllSpace("\t   1\t  \t2   3 \t"), "123");
  });
  test("removeAllSpaceMayNull", () {
    expect(MyStringUtil_c.removeAllSpaceMayNull(""), null);
    expect(MyStringUtil_c.removeAllSpaceMayNull("     "), null);
    expect(MyStringUtil_c.removeAllSpaceMayNull("\t  \t  \t   \t"), null);
    expect(MyStringUtil_c.removeAllSpaceMayNull("   1 2   3 "), "123");
    expect(MyStringUtil_c.removeAllSpaceMayNull("\t   1\t  \t2   3 \t"), "123");
  });
  test("removeBetweenSpace", () {
    expect(MyStringUtil_c.removeBetweenSpace(""), "");
    expect(MyStringUtil_c.removeBetweenSpace("  "), "");
    expect(MyStringUtil_c.removeBetweenSpace("\t\t\t"), "");
    expect(MyStringUtil_c.removeBetweenSpace("\t   \t      \t"), "");
    expect(MyStringUtil_c.removeBetweenSpace("   1 2   3 "), "1 2   3");
    expect(
      MyStringUtil_c.removeBetweenSpace("\t   1\t  \t2   3 \t"),
      "1\t  \t2   3",
    );
  });
  test("removeBetweenSpace", () {
    expect(MyStringUtil_c.removeBetweenSpaceMayNull(null), null);
    expect(MyStringUtil_c.removeBetweenSpaceMayNull(""), null);
    expect(MyStringUtil_c.removeBetweenSpaceMayNull("  "), null);
    expect(MyStringUtil_c.removeBetweenSpaceMayNull("\t\t\t"), null);
    expect(MyStringUtil_c.removeBetweenSpaceMayNull("\t   \t      \t"), null);
    expect(MyStringUtil_c.removeBetweenSpaceMayNull("   1 2   3 "), "1 2   3");
    expect(
      MyStringUtil_c.removeBetweenSpaceMayNull("\t   1\t  \t2   3 \t"),
      "1\t  \t2   3",
    );
  });
}

void test_isIgnoreCaseEqual() {
  test("isIgnoreCaseEqual", () {
    // true
    expect(MyStringUtil_c.isIgnoreCaseEqual("", ""), true);
    expect(MyStringUtil_c.isIgnoreCaseEqual(" ", " "), true);
    expect(MyStringUtil_c.isIgnoreCaseEqual("123abcABC", "123abcABC"), true);
    expect(MyStringUtil_c.isIgnoreCaseEqual("123abcABC", "123ABCabc"), true);
    expect(MyStringUtil_c.isIgnoreCaseEqual("abc", "AbC"), true);
    expect(MyStringUtil_c.isIgnoreCaseEqual("你 好abc\n", "你 好AbC\n"), true);
    // false
    expect(MyStringUtil_c.isIgnoreCaseEqual("", "     "), false);
    expect(MyStringUtil_c.isIgnoreCaseEqual("你 好abc\n\r", "不 好ABC"), false);
  });
}

void test_isIgnoreCaseContains() {
  test("isIgnoreCaseContains", () {
    // true
    expect(MyStringUtil_c.isIgnoreCaseContains("", ""), true);
    expect(MyStringUtil_c.isIgnoreCaseContains(" ", " "), true);
    expect(MyStringUtil_c.isIgnoreCaseContains("   ", ""), true);
    expect(MyStringUtil_c.isIgnoreCaseContains("123abcABC +++ ", "123abcABC"),
        true);
    expect(MyStringUtil_c.isIgnoreCaseContains("abcAbC", "AbC"), true);
    expect(MyStringUtil_c.isIgnoreCaseContains("AbCabc", "AbC"), true);
    expect(
      MyStringUtil_c.isIgnoreCaseContains(
          "  你 好 你 好AbC\n1fdfaf56as", "你 好AbC\n"),
      true,
    );
    // false
    expect(MyStringUtil_c.isIgnoreCaseContains("123abcABC", "123abcABC +++ "),
        false);
    expect(MyStringUtil_c.isIgnoreCaseContains("", "     "), false);
    expect(MyStringUtil_c.isIgnoreCaseContains("你 好abc\n\r", "不 好ABC"), false);
  });
  test("isIgnoreCaseContainsAny", () {
    // true
    expect(MyStringUtil_c.isIgnoreCaseContainsAny("", ""), true);
    expect(MyStringUtil_c.isIgnoreCaseContainsAny(" ", " "), true);
    expect(MyStringUtil_c.isIgnoreCaseContainsAny("", "     "), true);
    expect(
        MyStringUtil_c.isIgnoreCaseContainsAny("123abcABC", "123abcABC"), true);
    expect(MyStringUtil_c.isIgnoreCaseContainsAny(" dddabc", "AbC"), true);
    expect(MyStringUtil_c.isIgnoreCaseContainsAny("AbC", " dddabc"), true);
    expect(MyStringUtil_c.isIgnoreCaseContainsAny("ABCddd ", "AbC"), true);
    expect(MyStringUtil_c.isIgnoreCaseContainsAny("AbC", "ABCddd "), true);
    expect(
      MyStringUtil_c.isIgnoreCaseContainsAny(
        "  你 好 你 好aBc\n1fdfaf56as",
        "你 好AbC\n",
      ),
      true,
    );
    expect(
      MyStringUtil_c.isIgnoreCaseContainsAny(
        "你 好AbC\n",
        "  你 好 你 好aBc\n1fdfaf56as",
      ),
      true,
    );
    // false
    expect(MyStringUtil_c.isIgnoreCaseContainsAny("你  好abc", "不 好ABC"), false);
    expect(
        MyStringUtil_c.isIgnoreCaseContainsAny("你 好abc\n\r", "不 好ABC"), false);
  });

  test("isNotEmptyAndIgnoreCaseContainsAny", () {
    // true
    expect(MyStringUtil_c.isNotEmptyAndIgnoreCaseContainsAny(" ", " "), true);
    expect(
        MyStringUtil_c.isNotEmptyAndIgnoreCaseContainsAny(
            "123abcABC", "123abcABC"),
        true);
    expect(MyStringUtil_c.isNotEmptyAndIgnoreCaseContainsAny(" dddabc", "AbC"),
        true);
    expect(MyStringUtil_c.isNotEmptyAndIgnoreCaseContainsAny("AbC", " dddabc"),
        true);
    expect(MyStringUtil_c.isNotEmptyAndIgnoreCaseContainsAny("ABCddd ", "AbC"),
        true);
    expect(MyStringUtil_c.isNotEmptyAndIgnoreCaseContainsAny("AbC", "ABCddd "),
        true);
    expect(
      MyStringUtil_c.isNotEmptyAndIgnoreCaseContainsAny(
          "  你 好 你 好AbC\n1fdfaf56as", "你 好AbC\n"),
      true,
    );
    // false
    expect(MyStringUtil_c.isNotEmptyAndIgnoreCaseContainsAny("", ""), false);
    expect(MyStringUtil_c.isNotEmptyAndIgnoreCaseContainsAny("   ", ""), false);
    expect(
      MyStringUtil_c.isNotEmptyAndIgnoreCaseContainsAny("", "     "),
      false,
    );
    expect(
        MyStringUtil_c.isNotEmptyAndIgnoreCaseContainsAny("你  好abc", "不 好ABC"),
        false);
    expect(
        MyStringUtil_c.isNotEmptyAndIgnoreCaseContainsAny(
            "你 好abc\n\r", "不 好ABC"),
        false);
  });
}
