import 'package:lpinyin/lpinyin.dart';

class MyStringUtil_c {
  static const int CODE_0 = 48,
      CODE_9 = 57,
      CODE_A = 65,
      CODE_Z = 90,
      CODE_a = 97,
      CODE_z = 122;

  MyStringUtil_c._();

  static bool isCode_num(int code) {
    return (code >= CODE_0 && code <= CODE_9);
  }

  static bool isCode_AZ(int code) {
    return (code >= CODE_A && code <= CODE_Z);
  }

  static bool isCode_az(int code) {
    return (code >= CODE_a && code <= CODE_z);
  }

  static bool isCode_AZaz(int code) {
    return (isCode_AZ(code) || isCode_az(code));
  }

  static int toCode_AZ(int code) {
    if (isCode_az(code)) {
      return code - (CODE_a - CODE_A);
    }
    assert(isCode_AZ(code));
    return code;
  }

  static int toCode_az(int code) {
    if (isCode_AZ(code)) {
      return code + (CODE_a - CODE_A);
    }
    assert(isCode_az(code));
    return code;
  }

  /// 会忽略[str]开头的空白符
  /// * 如果[str]的首字符为中文字符，将转换返回该字符的拼音
  /// * 如果 [str] 为字母，将转为[小写]并返回该字母
  /// * 如果 [str] 为数字，则返回数值
  /// * 如果 [str] 为空、无法转为拼音，则返回 null
  static String? getFirstCharPinyin(
    String str, {
    bool enableAZ = true,
    bool enableNum = true,
  }) {
    if (str.isEmpty) {
      return null;
    }
    // 移除开头的空白符
    str.replaceFirst(r"^\s+", "");
    if (str.isEmpty) {
      return null;
    }
    final code = str.codeUnitAt(0);
    if (isCode_num(code)) {
      if (enableNum) {
        return str[0];
      } else {
        return null;
      }
    } else if (isCode_az(code)) {
      if (enableAZ) {
        return str[0];
      } else {
        return null;
      }
    } else if (isCode_AZ(code)) {
      if (enableAZ) {
        return String.fromCharCode(code + (CODE_a - CODE_A));
      } else {
        return null;
      }
    } else {
      final result = PinyinHelper.getFirstWordPinyin(str);
      if (result.isNotEmpty) {
        // 非空
        final code = result.codeUnitAt(0);
        if (isCode_AZaz(code)) {
          // 第一个字符在 [A-Za-z]
          return result.toLowerCase();
        }
      }
      return null;
    }
  }

  /// 只返回[str]的第一个字符的类别
  /// * 如果是中文，转为拼音，并把拼音第一个字母返回
  /// * 如果是字母，返回小写字母
  /// * 如果是数字，则返回数字
  static String? getFirstCharPinyinFirstChar(String str) {
    final restr = getFirstCharPinyin(str);
    if (null != restr && restr.isNotEmpty) {
      return restr[0];
    }
    return null;
  }

  /// 扩展名称排序
  /// * 支持数值排序
  ///   * 得到 1，2，3，...，11，12，13，...
  ///   * 而非 1，11，12，13，2，3，
  /// * 支持中文转拼音后排序
  /// * 整体顺序：
  ///   * 数值
  ///   * 特殊字符
  ///   * A-Z（中英文字符混合排序）
  static int compareExtend(String left, String right) {
    // 左排前，返回-1
    // 右排前，返回1
    // 相等返回0
    if (left.isEmpty) {
      if (right.isEmpty) {
        return 0;
      } else {
        // 左空，右非空；左排前
        return -1;
      }
    } else if (right.isEmpty) {
      // 左非空，右空；右排前
      return 1;
    }
    int leftSum = 0;
    int rightSum = 0;
    for (int i = 0, j = 0; i < left.length && j < right.length; ++i, ++j) {
      final leftItem = left[i].toLowerCase();
      final rightItem = right[j].toLowerCase();
      final leftCode = leftItem.codeUnitAt(0);
      final rightCode = rightItem.codeUnitAt(0);
      final leftIsNum = isCode_num(leftCode);
      final rightIsNum = isCode_num(rightCode);
      if (leftIsNum != rightIsNum) {
        // 一方是数值，一方非数值，将非数值放前
        if (leftIsNum) {
          // 左数值，右非数值；右排前
          return -1;
        } else {
          // 左非数值，右数值；左排前
          return 1;
        }
      } else {
        if (leftIsNum) {
          // 都是数值
          for (; i < left.length; ++i) {
            final item = left.codeUnitAt(i) - CODE_0;
            if (item >= 0 && item <= 9) {
              leftSum *= 10;
              leftSum += item;
            } else {
              break;
            }
          }
          for (; j < right.length; ++j) {
            final item = right.codeUnitAt(j) - CODE_0;
            if (item >= 0 && item <= 9) {
              rightSum *= 10;
              rightSum += item;
            } else {
              break;
            }
          }
        } else {
          // 都不是数值
          if (leftSum != rightSum) {
            // 前面已经积攒了数值，且不相等
            return (leftSum - rightSum);
          }
          leftSum = 0;
          rightSum = 0;

          /// 判断中英文字符，尝试转为拼音进行比较
          final leftPinyin = getFirstCharPinyin(
            leftItem,
          );
          final rightPinyin = getFirstCharPinyin(
            rightItem,
          );
          if (null != leftPinyin) {
            // 左是中英文字符
            if (null != rightPinyin) {
              // 右 也是中英文字符
              final result = leftPinyin.compareTo(rightPinyin);
              if (result != 0) {
                // 不相同
                return result;
              } else {
                // 相同，进入下一次循环
                continue;
              }
            } else {
              // 右 非中英文字符
              // 让右排前
              return 1;
            }
          } else {
            // 左 非中英文字符
            if (null != rightPinyin) {
              // 右 是中英文字符
              // 让左排前
              return -1;
            }
          }

          /// 都不是中英文字符
          final result = leftCode - rightCode;
          if (result != 0) {
            return result;
          }
        }
      }
    }
    if (leftSum != rightSum) {
      return leftSum - rightSum;
    }
    return (left.length - right.length);
  }

  /// 将 路径 规范化，去除多余的 / 或 \
  static String toStandardPath(String path) {
    return path
        .replaceAll(RegExp(r'\\{2,}'), r'\')
        .replaceAll(RegExp(r'/{2,}'), '/');
  }

  /// 将路径unix标准化
  static String toUnixStandardPath(String path) {
    return path.replaceAll(RegExp(r'[/\\]+'), '/');
  }

  /// 移除所有空白符号
  static String removeAllSpace(String str) {
    return str.replaceAll(RegExp(r"\s+"), "");
  }

  /// 移除[str]所有空白符号，如果str为[null]或移除空白符号后是[空字符串]则返回[null]
  static String? removeAllSpaceMayNull(String? str) {
    if (null == str || str.isEmpty) {
      return null;
    }
    final result = removeAllSpace(str);
    if (result.isEmpty) {
      return null;
    }
    return result;
  }

  /// 移除[str]两边的（空格|制表符\t）
  static String removeBetweenSpace(String str) {
    if (str.isEmpty) {
      return str;
    }
    int left = 0, right = str.length - 1;
    for (; right >= left; --right) {
      if (str[right] != ' ' && str[right] != '\t') {
        break;
      }
    }
    for (; left <= right; ++left) {
      if (str[left] != ' ' && str[left] != '\t') {
        break;
      }
    }
    if (left <= right) {
      return str.substring(left, right + 1);
    } else {
      return "";
    }
  }

  /// 移除[str]两端的（空格|制表符\t），
  /// 如果[str]为[null]或移除空白符号后得到[空字符串]则返回[null]
  static String? removeBetweenSpaceMayNull(String? str) {
    if (null == str) {
      return null;
    }
    final result = removeBetweenSpace(str);
    if (result.isEmpty) {
      return null;
    }
    return result;
  }

  /// 判断[longStr]是否包含[shortStr]，忽略大小写
  static bool isIgnoreCaseContains(String longStr, String shortStr) {
    return longStr.toLowerCase().contains(shortStr.toLowerCase());
  }

  /// 判断[str1]和[str2]中长的字符串是否包含短的字符串，忽略大小写
  static bool isIgnoreCaseContainsAny(String str1, String str2) {
    return (str1.length >= str2.length)
        ? isIgnoreCaseContains(str1, str2)
        : isIgnoreCaseContains(str2, str1);
  }

  /// 是否[str1]和[str2]都非空，并且其中长的字符串包含端的字符串，忽略大小写
  static bool isNotEmptyAndIgnoreCaseContainsAny(String str1, String str2) {
    if (str1.isEmpty || str2.isEmpty) {
      return false;
    }
    return isIgnoreCaseContainsAny(str1, str2);
  }
}
