// ignore_for_file: lines_longer_than_80_chars

import 'validations.dart' as validations;

/// This enum should be used to specify the validation type.
/// The Field decorator has a property validator which
/// expects a List<Map<FieldValidator, dynamic>>.
///    validator: [
///     { FieldValidator.required: {'message': 'Fill this or else} },
///     { FieldValidator.minLength: {'length': 5, 'message': 'Too short'} },
/// ]
enum FieldValidator {
  alpha,
  alphanumeric,
  creditCard,
  custom,
  date,
  dateRange,
  dateBefore,
  dateAfter,
  divisibleBy,
  email,
  emailOrUrl,
  emailOrPhone,
  fixedLength,
  float,
  hex,
  integer,
  lowerCase,
  match,
  min,
  minLength,
  max,
  maxLength,
  name,
  notNull,
  nullValue,
  numeric,
  phone,
  range,
  required,
  simpleURL,
  strLength,
  upperCase,
  url,
}

class FormValidator {
  /// Checks if the  value is alphabetic, i.e., contains only letters.
  static String? alpha(String? value, {String? message}) =>
      value == null || value.isEmpty || validations.isAlpha(value) ? null : message ?? 'Please enter only alphabets';

  /// Checks if the  value is alphanumeric, i.e., contains only letters and numbers.
  static String? alphanumeric(String? value, {String? message}) =>
      value == null || value.isEmpty || validations.isAlphanumeric(value) ? null : message ?? 'Please enter only alphabets and numbers';

  /// Checks if the  value is a valid credit card number.
  static String? creditCard(String? value, {String? message}) =>
      value == null || value.isEmpty || validations.isCreditCard(value) ? null : message ?? 'Please enter a valid credit card number';

  /// Checks if the  value is a valid date.
  static String? date(String? value, {String? message}) =>
      value == null || value.isEmpty || validations.isDate(value) ? null : message ?? 'Please enter a valid date';

  /// Checks if the  value is a valid date range.
  static String? dateRange(String? value, {String? message, required min, required max}) =>
      value == null || value.isEmpty || validations.isDateRange(value, min, max) == true ? null : message ?? 'Please enter a valid date range';

  /// Checks if the  value is divisible by a given divisor
  static String? divisibleBy(String? value, {String? message, required int divisor}) =>
      value == null || value.isEmpty || validations.isDivisibleBy(value, divisor)
          ? null
          : message ?? 'Please enter a valid number that is divisible by $divisor';

  // Check if the  value is a valid email address.
  static String? email(String? value, {String? message}) =>
      value == null || value.isEmpty || validations.isEmail(value) ? null : message ?? 'Please enter a valid email';

  /// Check if the value is a valid email address or a phone number.
  static String? emailOrPhone(String? value, {String? message}) => value == null || value.isEmpty || validations.isEmail(value) || validations.isNumeric(value)
      ? null
      : message ?? 'Please enter a valid email or phone number';

  /// Check if the value is a valid email address or a url.
  static String? emailOrUrl(String? value, {String? message}) =>
      value == null || value.isEmpty || validations.isEmail(value) || validations.isURL(value) ? null : message ?? 'Please enter a valid email or URL';

  /// Check if the
  static String? fixedLength(String? value, {String? message, required int length}) =>
      value == null || value.isEmpty || value.length == length ? null : message ?? 'Please enter an input of valid length';

  /// Check if the value is a floating point number.
  static String? float(String? value, {String? message}) =>
      value == null || value.isEmpty || validations.isFloat(value) ? null : message ?? 'Please enter a valid double';

  /// Check if the value is a valid hexadecimal number.
  static String? hex(String? value, {String? message}) =>
      value == null || value.isEmpty || validations.isHexadecimal(value) ? null : message ?? 'Please enter a valid hexadecimal';

  /// Check if the value is an integer.
  static String? integer(String? value, {String? message}) =>
      value == null || value.isEmpty || validations.isInt(value) ? null : message ?? 'Please enter a valid integer';

  /// Check if the value (a Date) is after the given Date.
  static String? isAfter(String? value, {String? message, required min}) => value == null || value.isEmpty || validations.isAfter(value, min) == true
      ?  null
      : message ?? 'Please enter a date after ${min.runtimeType.toString() == 'DateTime' ? min.toString().substring(0, 10) : min}';

  /// Check if the value (a Date) is before the given Date.
  static String? isBefore(String? value, {String? message, required max}) => value == null || value.isEmpty || validations.isBefore(value, max) == true
      ?  null
      : message ?? 'Please enter a date before ${max.runtimeType.toString() == 'DateTime' ? max.toString().substring(0, 10) : max}';

  /// Check if the value is in lowercase
  static String? lowerCase(String? value, {String? message}) =>
      value == null || value.isEmpty || validations.isLowerCase(value) ? null : message ?? 'Please enter only lowercase letters';

  /// Check if the value matches the given RegExp pattern.
  static String? match(String? value, {String? message, required String pattern}) =>
      value == null || value.isEmpty || validations.matches(value, pattern) == true ? null : message ?? 'The pattern "$pattern" does not match the input';

  /// Check if the value is less than the given maximum value.
  static String? max(String? value, {String? message, required int length}) =>
      value == null || value.isEmpty || value.length <= length ?  null : message ?? 'Please enter a value less than or equal to $length';

  /// Check if the value's length is less than or equal to the given maximum length.
  static String? maxLength(String? value, {String? message, required int length}) =>
      value == null || value.isEmpty || value.length <= length ? null : message ?? 'Please enter a valid length';

  /// Check if the value is more than or equal to the given minimum value.
  static String? min(String? value, {String? message, required int length}) =>
      value == null || value.isEmpty || value.length >= length ?  null : message ?? 'Please enter a value greater than or equal to $length';

  /// Check if the value's length is more than or equal to the given minimum length.
  static String? minLength(String? value, {String? message, required int length}) =>
      value == null || value.isEmpty || value.length >= length ?  null : message ?? 'Please enter an input of at least $length characters';

  /// Check if the value is an acceptable name string (alpha with '.' and  space characters).
  static String? name(String? value, {String? message}) =>
      value == null || value.isEmpty || validations.isName(value) ? null : message ?? 'Please enter a valid name';

  /// Check if the value is not null.
  static String? notNull(String? value, {String? message}) => value == null ? message ?? 'This field is required to have a value' : null;

  //  Check if the value is null.
  static String? nullValue(String? value, {String? message}) => value == null ? null : message ?? 'Please enter a valid value';

  // Check if the value is numeric.
  static String? numeric(String? value, {String? message}) =>
      value == null || value.isEmpty || validations.isNumeric(value) ? null : message ?? 'Please enter a valid number';

  /// Check if the value is a valid phone number.
  static String? phone(String? value, {String? message}) =>
      value == null || value.isEmpty || (validations.isNumeric(value) && value.length == 10) ? null : message ?? 'Please enter a valid phone number';

  /// Check if any value is entered.
  static String? required(String? value, {String? message}) => value == null || value.isNotEmpty ? null : message ?? 'This field is required';

  /// Check if the value is a valid URL. This is a simple check.
  static String? simpleURL(String? value, {String? message}) =>
      value == null || value.isEmpty || validations.isURL(value) ? null : message ?? 'Please enter a valid url';

  /// Check if the value is in upper case.
  static String? upperCase(String? value, {String? message}) =>
      value == null || value.isEmpty || validations.isUpperCase(value) ? null : message ?? 'Please enter only uppercase letters';

  /// Check if the value is a valid URL. This check is more elaborate than the simple check.
  /// it checks if the URL is valid and if it is, it checks  if the protocol is as expected,
  /// if the top level domain if specified matches and if underscores are allowed or not
  /// In addition the check also checks if the port is valid and you can specify
  /// whitelisted and backlisted hosts.
  static String? url(String? value,
          {String? message,
          List<String?> protocols = const ['http', 'https', 'ftp'],
          bool requireTld = true,
          bool requireProtocol = false,
          bool allowUnderscore = false,
          List<String> hostWhitelist = const [],
          List<String> hostBlacklist = const []}) =>
      value == null ||
              value.isEmpty ||
              validations.isURL(value,
                  protocols: protocols,
                  requireTld: requireTld,
                  requireProtocol: requireProtocol,
                  allowUnderscore: allowUnderscore,
                  hostWhitelist: hostWhitelist,
                  hostBlacklist: hostBlacklist)
          ? null
          : message ?? 'Please enter a valid URL';
}
