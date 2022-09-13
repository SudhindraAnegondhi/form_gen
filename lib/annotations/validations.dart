// ignore_for_file: lines_longer_than_80_chars, avoid_annotating_with_dynamic, prefer_single_quotes, omit_local_variable_types
import 'dart:convert';

final RegExp _email = RegExp(
    r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$");

final RegExp _ipv4Maybe = RegExp(r'^(\d?\d?\d)\.(\d?\d?\d)\.(\d?\d?\d)\.(\d?\d?\d)$');
final RegExp _ipv6 = RegExp(r'^::|^::1|^([a-fA-F0-9]{1,4}::?){1,7}([a-fA-F0-9]{1,4})$');

final RegExp _surrogatePairsRegExp = RegExp(r'[\uD800-\uDBFF][\uDC00-\uDFFF]');
final RegExp _name = RegExp(r'^[a-zA-Z\s.]+$');
final RegExp _alpha = RegExp(r'^[a-zA-Z]+$');
final RegExp _alphanumeric = RegExp(r'^[a-zA-Z0-9]+$');
final RegExp _numeric = RegExp(r'^-?[0-9.]+$');
final RegExp _int = RegExp(r'^(?:-?(?:0|[1-9][0-9]*))$');
final RegExp _float = RegExp(r'^(?:-?(?:[0-9]+))?(?:\.[0-9]*)?(?:[eE][\+\-]?(?:[0-9]+))?$');
final RegExp _hexadecimal = RegExp(r'^[0-9a-fA-F]+$');
final RegExp _hexcolor = RegExp(r'^#?([0-9a-fA-F]{3}|[0-9a-fA-F]{6})$');

final RegExp _base64 = RegExp(r'^(?:[A-Za-z0-9+\/]{4})*(?:[A-Za-z0-9+\/]{2}==|[A-Za-z0-9+\/]{3}=|[A-Za-z0-9+\/]{4})$');

final RegExp _creditCard = RegExp(
    r'^(?:4[0-9]{12}(?:[0-9]{3})?|5[1-5][0-9]{14}|6(?:011|5[0-9][0-9])[0-9]{12}|3[47][0-9]{13}|3(?:0[0-5]|[68][0-9])[0-9]{11}|(?:2131|1800|35\d{3})\d{11})$');

final RegExp _isbn10Maybe = RegExp(r'^(?:[0-9]{9}X|[0-9]{10})$');
final RegExp _isbn13Maybe = RegExp(r'^(?:[0-9]{13})$');

final Map _uuid = {
  '3': RegExp(r'^[0-9A-F]{8}-[0-9A-F]{4}-3[0-9A-F]{3}-[0-9A-F]{4}-[0-9A-F]{12}$'),
  '4': RegExp(r'^[0-9A-F]{8}-[0-9A-F]{4}-4[0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}$'),
  '5': RegExp(r'^[0-9A-F]{8}-[0-9A-F]{4}-5[0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}$'),
  'all': RegExp(r'^[0-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{12}$')
};

final RegExp _multibyte = RegExp(r'[^\x00-\x7F]');
final RegExp _ascii = RegExp(r'^[\x00-\x7F]+$');
final RegExp _fullWidth = RegExp(r'[^\u0020-\u007E\uFF61-\uFF9F\uFFA0-\uFFDC\uFFE8-\uFFEE0-9a-zA-Z]');
final RegExp _halfWidth = RegExp(r'[\u0020-\u007E\uFF61-\uFF9F\uFFA0-\uFFDC\uFFE8-\uFFEE0-9a-zA-Z]');

/// check if the string is alpha 
bool isAlpha(String str) {
  return _alpha.hasMatch(str);
}

/// check if the string is ascii
bool isAscii(String str) {
  return _ascii.hasMatch(str);
}

/// check if the string is alphanumeric
bool isAlphanumeric(String str) {
  return _alphanumeric.hasMatch(str);
}

/// bool check if the string is numeric
bool isNumeric(String str) {
  return _numeric.hasMatch(str);
}

/// check if the string is hexadecimal
bool isHexadecimal(String str) {
  return _hexadecimal.hasMatch(str);
}
/// check if the string matches the comparison
bool equals(String? str, comparison) {
  return str == comparison.toString();
}

/// check if the string contains the seed
bool contains(String str, seed) {
  return str.indexOf(seed.toString()) >= 0;
}

/// check if string [str] matches the [pattern].
bool matches(String str, String pattern) => RegExp(pattern).hasMatch(str);

/// check if the string [str] is an email
bool isEmail(String str) => _email.hasMatch(str.toLowerCase());

/// check if the string [str] is a URL
///
/// * [protocols] sets the list of allowed protocols
/// * [requireTld] sets if TLD is required
/// * [requireProtocol] is a `bool` that sets if protocol is required for validation
/// * [allowUnderscore] sets if underscores are allowed
/// * [hostWhitelist] sets the list of allowed hosts
/// * [hostBlacklist] sets the list of disallowed hosts
bool isURL(String? str,
    /// sets the list of allowed protocols, currently only `http`, `https`, `ftp`, `ftps`, `file` and `git` are supported
    {List<String?> protocols = const ['http', 'https', 'ftp', 'ftps', 'file', 'git'],
    /// sets if TLD is required
    bool requireTld = true,
    /// is a `bool` that sets if protocol is required for validation
    bool requireProtocol = false,
    /// sets if underscores are allowed
    bool allowUnderscore = false,
    /// sets the list of allowed hosts
    List<String> hostWhitelist = const [],
    /// sets the list of disallowed hosts
    List<String> hostBlacklist = const []}) {
  if (str == null || str.length == 0 || str.length > 2083 || str.startsWith('mailto:')) {
    return false;
  }

  var protocol, user, auth, host, hostname, port, port_str, path, query, hash, split;

  // check protocol
  split = str.split('://');
  if (split.length > 1 == true) {
    protocol = shift<String>(split as List<String>);
    if (protocols.indexOf(protocol as String) == -1) {
      return false;
    }
  } else if (requireProtocol == true) {
    return false;
  }
  str = split.join('://') as String?;

  // check hash
  split = str!.split('#');
  str = shift<String>(split);
  hash = split.join('#');
  if (hash != null && hash != '' && RegExp(r'\s').hasMatch(hash as String)) {
    return false;
  }

  // check query params
  split = str!.split('?');
  str = shift<String>(split);
  query = split.join('?');
  if (query != null && query != "" && RegExp(r'\s').hasMatch(query as String)) {
    return false;
  }

  // check path
  split = str!.split('/');
  str = shift(split);
  path = split.join('/');
  if (path != null && path != "" && RegExp(r'\s').hasMatch(path as String)) {
    return false;
  }

  // check auth type urls
  split = str!.split('@');
  if (split.length > 1 == true) {
    auth = shift(split);
    if (auth.indexOf(':') >= 0 == true) {
      auth = auth.split(':');
      user = shift(auth as List);
      if (!RegExp(r'^\S+$').hasMatch(user as String)) {
        return false;
      }
      if (!RegExp(r'^\S*$').hasMatch(user)) {
        return false;
      }
    }
  }

  // check hostname
  hostname = split.join('@');
  split = hostname.split(':');
  host = shift(split as List);
  if (split.length > 0 == true) {
    port_str = split.join(':');
    try {
      port = int.parse(port_str as String, radix: 10);
    } catch (e) {
      return false;
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(port_str) || port as int <= 0 || port > 65535) {
      return false;
    }
  }

  if (!isIP(host as String?) && !isFQDN(host as String, requireTld: requireTld, allowUnderscores: allowUnderscore) && host != 'localhost') {
    return false;
  }

  if (hostWhitelist.isNotEmpty && !hostWhitelist.contains(host)) {
    return false;
  }

  if (hostBlacklist.isNotEmpty && hostBlacklist.contains(host)) {
    return false;
  }

  return true;
}

/// check if the string [str] is IP [version] 4 or 6
///
/// * [version] is a String or an `int`.
bool isIP(String? str, [/*<String | int>*/ version]) {
  version = version.toString();
  if (version == 'null') {
    return isIP(str, 4) || isIP(str, 6);
  } else if (version == '4') {
    if (!_ipv4Maybe.hasMatch(str!)) {
      return false;
    }
    final parts = str.split('.');
    parts.sort((a, b) => int.parse(a) - int.parse(b));
    return int.parse(parts[3]) <= 255;
  }
  return version == '6' && _ipv6.hasMatch(str!);
}

/// check if the string [str] is a fully qualified domain name (e.g. domain.com).
///
/// * [requireTld] sets if TLD is required
/// * [allowUnderscore] sets if underscores are allowed
bool isFQDN(
  String str, {
    /// sets if Top Level Domain is required
  bool requireTld = true,
  
      /// sets if underscores are allowed
  bool allowUnderscores = false,
}) {
  final parts = str.split('.');
  if (requireTld) {
    final tld = parts.removeLast();
    if (parts.length == 0 || !RegExp(r'^[a-z]{2,}$').hasMatch(tld)) {
      return false;
    }
  }

  for (final part in parts) {
    if (allowUnderscores) {
      if (part.contains('__')) {
        return false;
      }
    }
    if (!RegExp(r'^[a-z\\u00a1-\\uffff0-9-]+$').hasMatch(part)) {
      return false;
    }
    if (part[0] == '-' || part[part.length - 1] == '-' || part.indexOf('---') >= 0) {
      return false;
    }
  }
  return true;
}


/// check if the string [str] contains only letters or spaces or  periods
bool isName(String str) => _name.hasMatch(str);

/// check if a string [str] is base64 encoded
bool isBase64(String str) => _base64.hasMatch(str);

/// check if the string [str] is an integer
bool isInt(String str) => _int.hasMatch(str);

/// check if the string [str] is a float
bool isFloat(String str) => _float.hasMatch(str);

/// check if the string [str] is a hexadecimal color
bool isHexColor(String str) => _hexcolor.hasMatch(str);

/// check if the string [str] is lowercase
bool isLowerCase(String str) => str == str.toLowerCase();

/// check if the string [str] is uppercase
bool isUpperCase(String str) => str == str.toUpperCase();

/// check if the string [str] is a number that's divisible by another
///
/// [n] is a String or an int.
bool isDivisibleBy(String str, n) {
  try {
    return double.parse(str) % int.parse(n as String) == 0;
  } catch (e) {
    return false;
  }
}

/// check if the string [str] is null
bool isNull(String? str) => str == null || str.length == 0;

/// check if the length of the string [str] falls in a range
bool isLength(String str, int min, [int? max]) {
  final List surrogatePairs = _surrogatePairsRegExp.allMatches(str).toList();
  final int len = str.length - surrogatePairs.length;
  return len >= min && (max == null || len <= max);
}

/// check if the string's length (in bytes) falls in a range.
bool isByteLength(String str, int min, [int? max]) => str.length >= min && (max == null || str.length <= max);

/// check if the string is a UUID (version 3, 4 or 5).
bool isUUID(String? str, [version]) {
  if (version == null) {
    version = 'all';
  } else {
    version = version.toString();
  }

  final RegExp? pat = _uuid[version] as RegExp?;
  return (pat != null && pat.hasMatch(str!.toUpperCase()));
}

/// check if the string is a date
bool isDate(String str) {
  try {
    DateTime.parse(str);
    return true;
  } catch (e) {
    return false;
  }
}

/// check if the string is a date that's after the specified date
///
/// If `date` is not passed, it defaults to now.
bool isAfter(String? str, [date]) {
  if (date == null) {
    date = DateTime.now();
  } else if (isDate(date as String)) {
    date = DateTime.parse(date);
  } else {
    return false;
  }

  DateTime str_date;
  try {
    str_date = DateTime.parse(str!);
  } catch (e) {
    return false;
  }

  return str_date.isAfter(date as DateTime);
}

/// check if the string is a date that's before the specified date
///
/// If `date` is not passed, it defaults to now.
bool isBefore(String? str, [date]) {
  if (date == null) {
    date = DateTime.now();
  } else if (isDate(date as String)) {
    date = DateTime.parse(date);
  } else {
    return false;
  }

  DateTime str_date;
  try {
    str_date = DateTime.parse(str!);
  } catch (e) {
    return false;
  }

  return str_date.isBefore(date as DateTime);
}

bool isDateRange(String? str, [min, max]) {
  if (min == null) {
    min = DateTime.now();
  } else if (isDate(min as String)) {
    min = DateTime.parse(min);
  } else {
    return false;
  }

  if (max == null) {
    max = DateTime.now();
  } else if (isDate(max as String)) {
    max = DateTime.parse(max);
  } else {
    return false;
  }

  DateTime str_date;
  try {
    str_date = DateTime.parse(str!);
  } catch (e) {
    return false;
  }

  return str_date.isAfter(min as DateTime) && str_date.isBefore(max as DateTime);
}

/// check if the string is in a array of allowed values
bool? isIn(String? str, values) {
  if (values == null || values.length == 0) {
    return false;
  }

  if (values is List) {
    values = values.map((e) => e.toString()).toList();
  }

  return values.indexOf(str) >= 0 == true;
}

/// check if the string is a credit card
bool isCreditCard(String str) {
  final String sanitized = str.replaceAll(RegExp(r'[^0-9]+'), '');
  if (!_creditCard.hasMatch(sanitized)) {
    return false;
  }

  // Luhn algorithm
  int sum = 0;
  String digit;
  bool shouldDouble = false;

  for (int i = sanitized.length - 1; i >= 0; i--) {
    digit = sanitized.substring(i, (i + 1));
    int tmpNum = int.parse(digit);

    if (shouldDouble == true) {
      tmpNum *= 2;
      if (tmpNum >= 10) {
        sum += ((tmpNum % 10) + 1);
      } else {
        sum += tmpNum;
      }
    } else {
      sum += tmpNum;
    }
    shouldDouble = !shouldDouble;
  }

  return (sum % 10 == 0);
}

/// check if the string is an ISBN (version 10 or 13)
bool isISBN(String? str, [version]) {
  if (version == null) {
    return isISBN(str, '10') || isISBN(str, '13');
  }

  version = version.toString();

  final String sanitized = str!.replaceAll(RegExp(r'[\s-]+'), '');
  int checksum = 0;

  if (version == '10') {
    if (!_isbn10Maybe.hasMatch(sanitized)) {
      return false;
    }
    for (int i = 0; i < 9; i++) {
      checksum += (i + 1) * int.parse(sanitized[i]);
    }
    if (sanitized[9] == 'X') {
      checksum += 10 * 10;
    } else {
      checksum += 10 * int.parse(sanitized[9]);
    }
    return (checksum % 11 == 0);
  } else if (version == '13') {
    if (!_isbn13Maybe.hasMatch(sanitized)) {
      return false;
    }
    final factor = [1, 3];
    for (int i = 0; i < 12; i++) {
      checksum += factor[i % 2] * int.parse(sanitized[i]);
    }
    return (int.parse(sanitized[12]) - ((10 - (checksum % 10)) % 10) == 0);
  }

  return false;
}

/// check if the string is valid JSON
bool isJSON(String str) {
  try {
    jsonDecode(str);
  } catch (e) {
    return false;
  }
  return true;
}

/// check if the string contains one or more multibyte chars
bool isMultibyte(String str) => _multibyte.hasMatch(str);



/// check if the string contains any full-width chars
bool isFullWidth(String str) => _fullWidth.hasMatch(str);

/// check if the string contains any half-width chars
bool isHalfWidth(String str) => _halfWidth.hasMatch(str);

/// check if the string contains a mixture of full and half-width chars
bool isVariableWidth(String str) => isFullWidth(str) && isHalfWidth(str);

/// check if the string contains any surrogate pairs chars
bool isSurrogatePair(String str) => _surrogatePairsRegExp.hasMatch(str);

/// check if the string is a valid hex-encoded representation of \
/// a MongoDB ObjectId
bool isMongoId(String str) => (isHexadecimal(str) && str.length == 24);

final _threeDigit = RegExp(r'^\d{3}$');
final _fourDigit = RegExp(r'^\d{4}$');
final _fiveDigit = RegExp(r'^\d{5}$');
final _sixDigit = RegExp(r'^\d{6}$');
final _postalCodePatterns = {
  "AD": RegExp(r'^AD\d{3}$'),
  "AT": _fourDigit,
  "AU": _fourDigit,
  "BE": _fourDigit,
  "BG": _fourDigit,
  "CA": RegExp(r'^[ABCEGHJKLMNPRSTVXY]\d[ABCEGHJ-NPRSTV-Z][\s\-]?\d[ABCEGHJ-NPRSTV-Z]\d$', caseSensitive: false),
  "CH": _fourDigit,
  "CZ": RegExp(r'^\d{3}\s?\d{2}$'),
  "DE": _fiveDigit,
  "DK": _fourDigit,
  "DZ": _fiveDigit,
  "EE": _fiveDigit,
  "ES": _fiveDigit,
  "FI": _fiveDigit,
  "FR": RegExp(r'^\d{2}\s?\d{3}$'),
  "GB": RegExp(r'^(gir\s?0aa|[a-z]{1,2}\d[\da-z]?\s?(\d[a-z]{2})?)$', caseSensitive: false),
  "GR": RegExp(r'^\d{3}\s?\d{2}$'),
  "HR": RegExp(r'^([1-5]\d{4}$)'),
  "HU": _fourDigit,
  "ID": _fiveDigit,
  "IL": _fiveDigit,
  "IN": _sixDigit,
  "IS": _threeDigit,
  "IT": _fiveDigit,
  "JP": RegExp(r'^\d{3}\-\d{4}$'),
  "KE": _fiveDigit,
  "LI": RegExp(r'^(948[5-9]|949[0-7])$'),
  "LT": RegExp(r'^LT\-\d{5}$'),
  "LU": _fourDigit,
  "LV": RegExp(r'^LV\-\d{4}$'),
  "MX": _fiveDigit,
  "NL": RegExp(r'^\d{4}\s?[a-z]{2}$', caseSensitive: false),
  "NO": _fourDigit,
  "PL": RegExp(r'^\d{2}\-\d{3}$'),
  "PT": RegExp(r'^\d{4}\-\d{3}?$'),
  "RO": _sixDigit,
  "RU": _sixDigit,
  "SA": _fiveDigit,
  "SE": RegExp(r'^\d{3}\s?\d{2}$'),
  "SI": _fourDigit,
  "SK": RegExp(r'^\d{3}\s?\d{2}$'),
  "TN": _fourDigit,
  "TW": RegExp(r'^\d{3}(\d{2})?$'),
  "UA": _fiveDigit,
  "US": RegExp(r'^\d{5}(-\d{4})?$'),
  "ZA": _fourDigit,
  "ZM": _fiveDigit
};

bool isPostalCode(String? text, String locale, {bool orElse()?}) {
  final pattern = _postalCodePatterns[locale];
  return pattern != null
      ? pattern.hasMatch(text!)
      : orElse != null
          ? orElse()
          : throw const FormatException();
}

T? shift<T>(List<T> l) {
  if (l.isNotEmpty) {
    final first = l.first;
    l.removeAt(0);
    return first;
  }
  return null;
}

Map merge(Map? obj, Map? defaults) {
  obj ??= <dynamic, dynamic>{};
  defaults?.forEach((dynamic key, dynamic val) => obj!.putIfAbsent(key, () => val));
  return obj;
}
