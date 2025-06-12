import 'package:string_util_xx/StringUtilxx.dart';
import 'package:test/test.dart';

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
    expect(StringUtilxx_c.compareExtend("", ""), 0);
    expect(StringUtilxx_c.compareExtend(" ", " "), 0);
    expect(StringUtilxx_c.compareExtend("123", "123"), 0);
    expect(StringUtilxx_c.compareExtend(" 123\t", " 123\t"), 0);
    expect(StringUtilxx_c.compareExtend(" #=k123abc\t\r\n", " #=k123abc\t\r\n"),
        0);
    expect(
        StringUtilxx_c.compareExtend("123 coolight 七千", "123 coolight 七千"), 0);
    // -1 左排前
    expect(StringUtilxx_c.compareExtend("", "   "), -1);
    expect(StringUtilxx_c.compareExtend(" ", "    "), -3);
    expect(StringUtilxx_c.compareExtend("1", "2"), -1);
    expect(StringUtilxx_c.compareExtend("1", "111"), 1 - 111);
    expect(StringUtilxx_c.compareExtend("2", "234"), 2 - 234);
    expect(StringUtilxx_c.compareExtend("77", "234"), 77 - 234);
    expect(StringUtilxx_c.compareExtend(" #= 你 77", " #= 你 234"), 77 - 234);
    expect(StringUtilxx_c.compareExtend(" #= 2 kkk", " #= 7"), 2 - 7);
    expect(StringUtilxx_c.compareExtend("123 cool 七", "123 cool z"), -1);
    expect(StringUtilxx_c.compareExtend("123 cool q", "123 cool 七八九"), -1);
    // +1 右排前
    expect(StringUtilxx_c.compareExtend("   ", ""), 1);
    expect(StringUtilxx_c.compareExtend("    ", " "), 3);
    expect(StringUtilxx_c.compareExtend("2", "1"), 1);
    expect(StringUtilxx_c.compareExtend("111", "1"), 111 - 1);
    expect(StringUtilxx_c.compareExtend("234", "2"), 234 - 2);
    expect(StringUtilxx_c.compareExtend("234", "77"), 234 - 77);
    expect(StringUtilxx_c.compareExtend(" #= 你 234", " #= 你 77"), 234 - 77);
    expect(StringUtilxx_c.compareExtend(" #= 7", " #= 2 kkk"), 7 - 2);
    expect(StringUtilxx_c.compareExtend("123 cool z", "123 cool 七"), 1);
    expect(StringUtilxx_c.compareExtend("123 cool 七八九", "123 cool q"), 1);
  });
}

void test_toStandardPath() {
  test("toStandardPath", () {
    expect(StringUtilxx_c.toStandardPath(r"//////"), "/");
    expect(StringUtilxx_c.toStandardPath(r"\\\\\"), r"\");
    expect(StringUtilxx_c.toStandardPath(r"\\\\\/\/\////\/"), r"\");
    expect(StringUtilxx_c.toStandardPath(r"a/b\d"), r"a/b\d");
    expect(StringUtilxx_c.toStandardPath(r"a///b\d"), r"a/b\d");
    expect(StringUtilxx_c.toStandardPath(r"a/b\\\d"), r"a/b\d");
    expect(StringUtilxx_c.toStandardPath(r"a/////b\\d"), r"a/b\d");
    expect(StringUtilxx_c.toStandardPath(r"///a/b\d"), r"/a/b\d");
    expect(StringUtilxx_c.toStandardPath(r"//a///b\\\\d/////"), r"/a/b\d/");
    expect(StringUtilxx_c.toStandardPath(r"\\\a///b\\\\d\\\"), r"\a/b\d\");
    expect(StringUtilxx_c.toStandardPath(r"/\\\a//b\/\\///d\\\/"), r"\a/b\d\");
  });
}

void test_toUnixStandardPath() {
  test("test_toUnixStandardPath", () {
    expect(StringUtilxx_c.toUnixStandardPath(r"\\\\\"), r"/");
    expect(StringUtilxx_c.toUnixStandardPath(r"\\\\\//////\/\/\/"), r"/");
    expect(StringUtilxx_c.toUnixStandardPath(r"a/b/d"), r"a/b/d");
    expect(StringUtilxx_c.toUnixStandardPath(r"a/b\d"), r"a/b/d");
    expect(StringUtilxx_c.toUnixStandardPath(r"\a\b/d\"), r"/a/b/d/");
    expect(
      StringUtilxx_c.toUnixStandardPath(r"\\\/\/\a/\\b\\\/\/d\//\/\\\"),
      r"/a/b/d/",
    );
  });
}

void test_DirFilePath() {
  test("getFileName", () {
    expect(StringUtilxx_c.getFileName(""), "");
    expect(StringUtilxx_c.getFileName("."), ".");
    expect(StringUtilxx_c.getFileName("..."), "...");
    expect(StringUtilxx_c.getFileName("...///\\"), "...");
    expect(StringUtilxx_c.getFileName("/"), "/");
    expect(StringUtilxx_c.getFileName("/////"), "/////");
    expect(StringUtilxx_c.getFileName("\\"), "\\");
    expect(StringUtilxx_c.getFileName("\\\\\\"), "\\\\\\");
    expect(StringUtilxx_c.getFileName("///\\\\//\\"), "///\\\\//\\");
    expect(StringUtilxx_c.getFileName(".", removeEXT: true), ".");
    expect(StringUtilxx_c.getFileName("./.", removeEXT: true), ".");
    expect(StringUtilxx_c.getFileName("abc/..", removeEXT: true), "..");
    expect(StringUtilxx_c.getFileName("abc..123", removeEXT: true), "abc.");
    expect(StringUtilxx_c.getFileName("abc.123.tar.gz"), "abc.123.tar.gz");
    expect(StringUtilxx_c.getFileName("123"), "123");
    expect(StringUtilxx_c.getFileName("123/"), "123");
    expect(StringUtilxx_c.getFileName("123\\"), "123");
    expect(StringUtilxx_c.getFileName("./123"), "123");
    expect(StringUtilxx_c.getFileName(".\\123"), "123");
    expect(
      StringUtilxx_c.getFileName("./123.456/", removeEXT: true),
      "123.456",
    );
    expect(StringUtilxx_c.getFileName("\\//455//\\123/\\//\\/\\\\"), "123");
    expect(StringUtilxx_c.getFileName(".///\\//\\/\\123"), "123");
    expect(StringUtilxx_c.getFileName("///\\//\\/\\\\//"), "///\\//\\/\\\\//");
    expect(StringUtilxx_c.getFileName(".///\\//\\/\\\\//"), ".");
  });
  test("getFileNameEXT", () {
    expect(StringUtilxx_c.getFileNameEXT(""), null);
    expect(StringUtilxx_c.getFileNameEXT("."), null);
    expect(StringUtilxx_c.getFileNameEXT("..."), null);
    expect(StringUtilxx_c.getFileNameEXT("abc.name"), "name");
    expect(StringUtilxx_c.getFileNameEXT("abc.name/"), null);
    expect(StringUtilxx_c.getFileNameEXT(r"abc.name\"), null);
    expect(StringUtilxx_c.getFileNameEXT("./../..."), null);
    expect(StringUtilxx_c.getFileNameEXT("./../...name"), "name");
    expect(StringUtilxx_c.getFileNameEXT("./../name..."), null);

    expect(StringUtilxx_c.replaceOrAppendExt("hello", "wav"), "hello.wav");
    expect(StringUtilxx_c.replaceOrAppendExt("hello.mp3", "wav"), "hello.wav");
    expect(StringUtilxx_c.replaceOrAppendExt("hello.f", "wav"), "hello.wav");
    expect(StringUtilxx_c.replaceOrAppendExt("hello.flac", "wav"), "hello.wav");
    expect(StringUtilxx_c.replaceOrAppendExt("hello.", "wav"), "hello.wav");
    expect(StringUtilxx_c.replaceOrAppendExt(".hello", "wav"), ".hello.wav");
    expect(StringUtilxx_c.replaceOrAppendExt(".hello.", "wav"), ".hello.wav");
  });

  test("getParentDirPath", () {
    expect(StringUtilxx_c.getParentDirPath(""), null);
    expect(StringUtilxx_c.getParentDirPath("."), null);
    expect(StringUtilxx_c.getParentDirPath("..."), null);
    expect(StringUtilxx_c.getParentDirPath("...xx./"), null);
    expect(StringUtilxx_c.getParentDirPath("/...xx."), "/");
    expect(StringUtilxx_c.getParentDirPath("/...xx./"), "/");
    expect(StringUtilxx_c.getParentDirPath("/...xx./xxx"), "/...xx./");
    expect(StringUtilxx_c.getParentDirPath("./xxx"), "./");
    expect(StringUtilxx_c.getParentDirPath("../xxx"), "../");
  });
}

void test_removeSpace() {
  test("removeAllSpace", () {
    expect(StringUtilxx_c.removeAllSpace(""), "");
    expect(StringUtilxx_c.removeAllSpace("  \t \t     "), "");
    expect(StringUtilxx_c.removeAllSpace("   1 2   3 "), "123");
    expect(StringUtilxx_c.removeAllSpace("\t   1\t  \t2   3 \t"), "123");
  });
  test("removeAllSpaceMayNull", () {
    expect(StringUtilxx_c.removeAllSpaceMayNull(""), null);
    expect(StringUtilxx_c.removeAllSpaceMayNull("     "), null);
    expect(StringUtilxx_c.removeAllSpaceMayNull("\t  \t  \t   \t"), null);
    expect(StringUtilxx_c.removeAllSpaceMayNull("   1 2   3 "), "123");
    expect(StringUtilxx_c.removeAllSpaceMayNull("\t   1\t  \t2   3 \t"), "123");
  });
  test("removeBetweenSpace", () {
    expect(StringUtilxx_c.removeBetweenSpace(""), "");
    expect(StringUtilxx_c.removeBetweenSpace("  "), "");
    expect(StringUtilxx_c.removeBetweenSpace("\t\t\t"), "");
    expect(StringUtilxx_c.removeBetweenSpace("\t   \t      \t"), "");
    expect(StringUtilxx_c.removeBetweenSpace("   1 2   3 "), "1 2   3");
    expect(
      StringUtilxx_c.removeBetweenSpace("\t   1\t  \t2   3 \t"),
      "1\t  \t2   3",
    );
    expect(
      StringUtilxx_c.removeBetweenSpace(" \n \r  1 2   3 \n\r",
          removeLine: false),
      "\n \r  1 2   3 \n\r",
    );
    expect(
      StringUtilxx_c.removeBetweenSpace("\n \r  1 2   3\n\r",
          removeLine: false),
      "\n \r  1 2   3\n\r",
    );
    expect(
      StringUtilxx_c.removeBetweenSpace("\n \r  1 2   3\n\r  ",
          removeLine: false),
      "\n \r  1 2   3\n\r",
    );
    expect(
      StringUtilxx_c.removeBetweenSpace(" \n \r  1 2   3 \n\r"),
      "1 2   3",
    );
    expect(
      StringUtilxx_c.removeBetweenSpace("\n \r  1 2   3\n\r  "),
      "1 2   3",
    );
    expect(
      StringUtilxx_c.removeBetweenSpace(
        "\n \r  1 2   3\n\r  ",
        subLeft: false,
      ),
      "\n \r  1 2   3",
    );
    expect(
      StringUtilxx_c.removeBetweenSpace(
        "\n \r  1 2   3\n\r  ",
        subRight: false,
      ),
      "1 2   3\n\r  ",
    );
  });
  test("removeBetweenSpace", () {
    expect(StringUtilxx_c.removeBetweenSpaceMayNull(null), null);
    expect(StringUtilxx_c.removeBetweenSpaceMayNull(""), null);
    expect(StringUtilxx_c.removeBetweenSpaceMayNull("  "), null);
    expect(StringUtilxx_c.removeBetweenSpaceMayNull("\t\t\t"), null);
    expect(StringUtilxx_c.removeBetweenSpaceMayNull("\t   \t      \t"), null);
    expect(StringUtilxx_c.removeBetweenSpaceMayNull("   1 2   3 "), "1 2   3");
    expect(
      StringUtilxx_c.removeBetweenSpaceMayNull("\t   1\t  \t2   3 \t"),
      "1\t  \t2   3",
    );
  });
}

void test_isIgnoreCaseEqual() {
  test("isIgnoreCaseEqual", () {
    // true
    expect(StringUtilxx_c.isIgnoreCaseEqual("", ""), true);
    expect(StringUtilxx_c.isIgnoreCaseEqual(" ", " "), true);
    expect(StringUtilxx_c.isIgnoreCaseEqual("123abcABC", "123abcABC"), true);
    expect(StringUtilxx_c.isIgnoreCaseEqual("123abcABC", "123ABCabc"), true);
    expect(StringUtilxx_c.isIgnoreCaseEqual("abc", "AbC"), true);
    expect(StringUtilxx_c.isIgnoreCaseEqual("你 好abc\n", "你 好AbC\n"), true);
    // false
    expect(StringUtilxx_c.isIgnoreCaseEqual("", "     "), false);
    expect(StringUtilxx_c.isIgnoreCaseEqual("你 好abc\n\r", "不 好ABC"), false);
  });
}

void test_isIgnoreCaseContains() {
  test("isIgnoreCaseContains", () {
    // true
    expect(StringUtilxx_c.isIgnoreCaseContains("", ""), true);
    expect(StringUtilxx_c.isIgnoreCaseContains(" ", " "), true);
    expect(StringUtilxx_c.isIgnoreCaseContains("   ", ""), true);
    expect(StringUtilxx_c.isIgnoreCaseContains("123abcABC +++ ", "123abcABC"),
        true);
    expect(StringUtilxx_c.isIgnoreCaseContains("abcAbC", "AbC"), true);
    expect(StringUtilxx_c.isIgnoreCaseContains("AbCabc", "AbC"), true);
    expect(
      StringUtilxx_c.isIgnoreCaseContains(
          "  你 好 你 好AbC\n1fdfaf56as", "你 好AbC\n"),
      true,
    );
    // false
    expect(StringUtilxx_c.isIgnoreCaseContains("123abcABC", "123abcABC +++ "),
        false);
    expect(StringUtilxx_c.isIgnoreCaseContains("", "     "), false);
    expect(StringUtilxx_c.isIgnoreCaseContains("你 好abc\n\r", "不 好ABC"), false);
  });
  test("isIgnoreCaseContainsAny", () {
    // true
    expect(StringUtilxx_c.isIgnoreCaseContainsAny("", ""), true);
    expect(StringUtilxx_c.isIgnoreCaseContainsAny(" ", " "), true);
    expect(StringUtilxx_c.isIgnoreCaseContainsAny("", "     "), true);
    expect(
        StringUtilxx_c.isIgnoreCaseContainsAny("123abcABC", "123abcABC"), true);
    expect(StringUtilxx_c.isIgnoreCaseContainsAny(" dddabc", "AbC"), true);
    expect(StringUtilxx_c.isIgnoreCaseContainsAny("AbC", " dddabc"), true);
    expect(StringUtilxx_c.isIgnoreCaseContainsAny("ABCddd ", "AbC"), true);
    expect(StringUtilxx_c.isIgnoreCaseContainsAny("AbC", "ABCddd "), true);
    expect(
      StringUtilxx_c.isIgnoreCaseContainsAny(
        "  你 好 你 好aBc\n1fdfaf56as",
        "你 好AbC\n",
      ),
      true,
    );
    expect(
      StringUtilxx_c.isIgnoreCaseContainsAny(
        "你 好AbC\n",
        "  你 好 你 好aBc\n1fdfaf56as",
      ),
      true,
    );
    // false
    expect(StringUtilxx_c.isIgnoreCaseContainsAny("你  好abc", "不 好ABC"), false);
    expect(
        StringUtilxx_c.isIgnoreCaseContainsAny("你 好abc\n\r", "不 好ABC"), false);
  });

  test("isNotEmptyAndIgnoreCaseContainsAny", () {
    // true
    expect(StringUtilxx_c.isNotEmptyAndIgnoreCaseContainsAny(" ", " "), true);
    expect(
        StringUtilxx_c.isNotEmptyAndIgnoreCaseContainsAny(
            "123abcABC", "123abcABC"),
        true);
    expect(StringUtilxx_c.isNotEmptyAndIgnoreCaseContainsAny(" dddabc", "AbC"),
        true);
    expect(StringUtilxx_c.isNotEmptyAndIgnoreCaseContainsAny("AbC", " dddabc"),
        true);
    expect(StringUtilxx_c.isNotEmptyAndIgnoreCaseContainsAny("ABCddd ", "AbC"),
        true);
    expect(StringUtilxx_c.isNotEmptyAndIgnoreCaseContainsAny("AbC", "ABCddd "),
        true);
    expect(
      StringUtilxx_c.isNotEmptyAndIgnoreCaseContainsAny(
          "  你 好 你 好AbC\n1fdfaf56as", "你 好AbC\n"),
      true,
    );
    // false
    expect(StringUtilxx_c.isNotEmptyAndIgnoreCaseContainsAny("", ""), false);
    expect(StringUtilxx_c.isNotEmptyAndIgnoreCaseContainsAny("   ", ""), false);
    expect(
      StringUtilxx_c.isNotEmptyAndIgnoreCaseContainsAny("", "     "),
      false,
    );
    expect(
        StringUtilxx_c.isNotEmptyAndIgnoreCaseContainsAny("你  好abc", "不 好ABC"),
        false);
    expect(
        StringUtilxx_c.isNotEmptyAndIgnoreCaseContainsAny(
            "你 好abc\n\r", "不 好ABC"),
        false);
  });
}
