字符串处理工具

## Features
* 该插件主要用于处理一些字符串操作：
  * 中文拼音排序；将中文字符转拼音得到首字母后可与英文混合排序
  * 数值排序；支持按数值大小排下序，如 1,2,3,11,12,13,777 ...；而不是 1,11,12,13,2,3,777
  * 路径标准化；
    * 将 `a/////b\\/\/c\\` 转为 `a/b\c\`
    * 将 `a/////b\\/\/c\\` 按unix标准路径格式转为 `a/b/c/`
  * 移除字符串内的所有空白符号、仅移除两端的空白符号
  * 忽略大小写的比较相等、互相包含

## Getting started

* 在`pubspec.yaml`中导入本插件:
```yaml
  dependencies:
    my_string_util:  # 在`dependencies`下添加这一行，注意缩进是必要的
```
* 在你希望使用的地方import:
```dart
import 'package:my_string_util/MyStringUtil.dart';
```

## Usage

### 中文拼音排序/数值排序
* 将`MyStringUtil_c.compareExtend`传递给排序算法即可，比如内置的`sort`：
```dart
final list = <String>[
    "77",
    "123",
    "#*-",
    "abc",
    "azcc",
    "bzz",
    "bbb",
    "艾莉", // A L
    "爱心", // A X
    "哀愁", // A C
    "玻璃", // B L
    "博主", // B Z
    "博爱", // B A
    "第123天",
    "第77天",
];
// 排序
list.sort(MyStringUtil_c.compareExtend);
// 即可得到排序后的`list`，结果为:
[
  77, 
  123, 
  #*-, 
  abc, 
  azcc, 
  哀愁, // A C
  艾莉, // A L
  爱心, // A X
  bbb, 
  bzz, 
  博爱, // B A
  玻璃, // B L
  博主, // B Z
  第77天, 
  第123天
]
```
* 整体顺序：
  * 数值
  * 特殊字符
  * A-Z（中英文字符混合排序；但拼音首字母和英文字母相同时英文排前）

### 路径标准化
* 合并多余的`/`或`\`:
  * 对于连续的`/`，合并为`/`
  * 对于连续的`\`，合并为`\`
  * 对于连续的`/`和`\`，合并为`\`；因为路径会出现分隔符`\`一般是win端，合并为`\`较好
```dart
String result = MyStringUtil_c.toStandardPath("//a//b//"); // result = "/a/b/";
String result = MyStringUtil_c.toStandardPath("\\\\\\a\\\\b\\"); // result = "\a\b\";
String result = MyStringUtil_c.toStandardPath("//a//\\//\\/\b/\\/"); // result = "/a\b\";
```
* 统一合并为`/`:
  * 无论连续的`/`和`\`，都合并为`/`
```dart
String result = MyStringUtil_c.toUnixStandardPath("//a//b//"); // result = "/a/b/";
String result = MyStringUtil_c.toUnixStandardPath("\\\\\\a\\\\b\\"); // result = "/a/b/";
String result = MyStringUtil_c.toUnixStandardPath("//a//\\//\\/\b/\\/"); // result = "/a/b/";
```

### 移除空白符号
```dart
// 移除所有空白符号
String result = MyStringUtil_c.removeAllSpace("\t   1\t  \t2   3 \t") // result = "123";
String result = MyStringUtil_c.removeAllSpace("  \t \t     "); // result = "";
// 移除后如果是空字符串会返回null
String? result = MyStringUtil_c.removeAllSpaceMayNull("\t   1\t  \t2   3 \t") // result = "123";
String? result = MyStringUtil_c.removeAllSpaceMayNull("  \t \t     "); // result = null;
// 仅移除两端的空白符号
String result = MyStringUtil_c.removeBetweenSpace("\t  1 2 \t 3 "); // result = "1 2 \t 3";
String result = MyStringUtil_c.removeBetweenSpace("  \t \t     "); // result = "";
// 仅移除两端的空白符号，但移除后如果是空字符串会返回null
String result = MyStringUtil_c.removeBetweenSpaceMayNull("\t  1 2 \t 3 "); // result = "1 2 \t 3";
String result = MyStringUtil_c.removeBetweenSpaceMayNull("  \t \t     "); // result = null;
```

### 忽略大小写比较
```dart
// 忽略大小写比较相等
MyStringUtil_c.isIgnoreCaseEqual("", ""); // true
MyStringUtil_c.isIgnoreCaseEqual(" ", " "); // true
MyStringUtil_c.isIgnoreCaseEqual("123abcABC", "123ABCabc"); // true
// 忽略大小写，比较左边是否包含右边
MyStringUtil_c.isIgnoreCaseContains("123abcABC  +++ ", "123ABCabc") // true
MyStringUtil_c.isIgnoreCaseContains("123ABCabc"，"123abcABC  +++ ") // false
MyStringUtil_c.isIgnoreCaseContains("", ""); // true
MyStringUtil_c.isIgnoreCaseContains(" ", " ") // true
MyStringUtil_c.isIgnoreCaseContains("   ", "") // true
// 忽略大小写，比较是否有一方包含另一方
MyStringUtil_c.isIgnoreCaseContainsAny("123abcABC  +++ ", "123ABCabc") // true
MyStringUtil_c.isIgnoreCaseContainsAny("123ABCabc"，"123abcABC  +++ ") // true
MyStringUtil_c.isIgnoreCaseContainsAny("", ""); // true
MyStringUtil_c.isIgnoreCaseContainsAny(" ", " ") // true
MyStringUtil_c.isIgnoreCaseContainsAny("   ", "") // true
// 忽略大小写，比较是否两者都不为空字符串，且有一方包含另一方
MyStringUtil_c.isNotEmptyAndIgnoreCaseContainsAny("123abcABC  +++ ", "123ABCabc") // true
MyStringUtil_c.isNotEmptyAndIgnoreCaseContainsAny("123ABCabc"，"123abcABC  +++ ") // true
MyStringUtil_c.isNotEmptyAndIgnoreCaseContainsAny("", ""); // false
MyStringUtil_c.isNotEmptyAndIgnoreCaseContainsAny(" ", " ") // true
MyStringUtil_c.isNotEmptyAndIgnoreCaseContainsAny("   ", "") // false
MyStringUtil_c.isNotEmptyAndIgnoreCaseContainsAny("", "   ") // false

```

## 其他
* 该插件来自[拟声](https://github.com/coolight7/MimicryMusic)的开发。
* 如果希望改进该插件，可提交issue或pr。