// ignore_for_file: lines_longer_than_80_chars, unused_element
import 'dart:convert';

enum FieldPropertyType {
  boolean,
  currency,
  date,
  doubleNumber,
  intNumber,
  imageList,
  list,
  map,
  string,
  email,
  name,
  multiLine,
  phone,
  streetAddress,
  url,
  object,
}


enum FormFieldType {
  text,
  textarea,
  dateTimePicker,
  dateRangePicker,
  slideSwitch,
  dropdown,
  radio,
  radioGroup,
  checkbox,
  checkboxGroup,
  filterChip,
  chioceChip,
  rangeSlider,
  object,
}
double max(double a, double b) => a > b ? a : b;
double min(double a, double b) => a < b ? a : b;


/// Returns TextInputType for the given [FormFieldType].
String getKeyboardType(String type) {
  var fieldType = FieldPropertyType.string;
  try {
    fieldType = FieldPropertyType.values.firstWhere((e) => e.toString().split('.').last == type.toLowerCase());
  } catch (e) {
    print('FieldPropertyType not found: $type');
  }
  switch (fieldType) {
    case FieldPropertyType.currency:
    case FieldPropertyType.doubleNumber:
    case FieldPropertyType.intNumber:
      return 'TextInputType.number';
    case FieldPropertyType.date:
      return 'TextInputType.datetime';
    case FieldPropertyType.email:
      return 'TextInputType.emailAddress';
    case FieldPropertyType.name:
      return 'TextInputType.name';
    case FieldPropertyType.phone:
      return 'TextInputType.phone';
    case FieldPropertyType.streetAddress:
      return 'TextInputType.streetAddress';
    case FieldPropertyType.url:
      return 'TextInputType.url';
    case FieldPropertyType.multiLine:
      return 'TextInputType.multiline';
    default:
      return 'TextInputType.text';
  }
}

String camelCaseToTitleCase(String label) => label
    .replaceAllMapped(RegExp(r'(?!^)([A-Z])'), (Match match) => ' ${match.group(1)}')
    .split(' ')
    .map((String s) => s[0].toUpperCase() + s.substring(1).toLowerCase())
    .join(' ');


bool hasSubAttributes(Map<String, dynamic> defs, FormFieldType fieldType, String key) {
  final field = defs[key] as Map<String, dynamic>;
  if (fieldType == FormFieldType.textarea ||
      fieldType == FormFieldType.dateTimePicker ||
      fieldType == FormFieldType.dateRangePicker ||
      fieldType == FormFieldType.rangeSlider) {
    if (fieldType == FormFieldType.textarea) {
      return field.containsKey('numberOfLines');
    }

    if (fieldType == FormFieldType.dateTimePicker && field.containsKey('datePickerMode')) {
      return true;
    }
    if (fieldType == FormFieldType.dateRangePicker &&
        field.containsKey('dateRange') &&
        ((field['dateRange'] as Map?) != null && ((field['dateRange'] as Map?)!['firstDate'] != null)) &&
        ((field['dateRange'] as Map?)!['lastDate'] != null)) {
      return true;
    }
    if (fieldType == FormFieldType.rangeSlider &&
        field.containsKey('sliderRange') &&
        (field['sliderRange'] as Map?) != null &&
        (field['sliderRange'] as Map).containsKey('min') &&
        (field['sliderRange'] as Map).containsKey('max') &&
        (field['sliderRange'] as Map).containsKey('divisions')) {
      return true;
    }
  }
  return false;
}

bool isValidType(String type) => FieldPropertyType.values.map((e) => e.toString().split('.').last).contains(type);

bool isValidAttribute(String attribute) => [
      'type',
      'enabled',
      'fieldType',
      'inputDecoration',
      'numberOfLines',
      'datePickerMode',
      'dateRangePicker',
      'sliderRange',
      'label',
      'hint',
      'values',
      'properties',
      'validators',
      'sequence'
    ].contains(attribute);

bool isValidFieldType(String fieldType) => FormFieldType.values.map((e) => e.toString()).contains(fieldType);

bool mustHaveValues(String fieldType) => ['dropdown', 'radio', 'radioGroup', 'checkbox', 'checkboxGroup', 'filterChip', 'chioceChip'].contains(fieldType);

bool isMeta(String key) => ['__sequence'].contains(key);

String valueToType(String? fieldType) {
  String response;
  switch (fieldType) {
    case 'int':
      response = 'int.tryParse(value)';
      break;
    case 'double':
      response = 'double.tryParse(value)';
      break;
    case 'bool':
      response = 'value == \'true\'';
      break;
    case 'DateTime':
      response = 'DateTime.tryParse(value)';
      break;
    case null:
    default:
      response = 'value';
  }
  return response + ';';
}

String typeToValue(String fieldType) {
  String response;
  switch (fieldType) {
    case 'int':
    case 'double':
    case 'bool':
      response = 'value.toString()';
      break;
    case 'DateTime':
      response = 'value.toIso8601String()';
      break;
    default:
      response = 'value';
  }
  return response;
}


dynamic stringToTypeValue(String type, String value) {
  switch (type) {
    case 'int':
      return int.parse(value);
    case 'double':
      return double.parse(value);
    case 'bool':
      return value == 'true';
    case 'DateTime':
      return DateTime.parse(value);
    case 'List<String>':
     return jsonDecode(value) as List<String>;
    case 'List<int>':
      return jsonDecode(value) as List<int>;
    case 'List<double>':
      return jsonDecode(value) as List<double>;
    case 'List<bool>':
      return jsonDecode(value) as List<bool>;
    case 'List<DateTime>':
      return jsonDecode(value) as List<DateTime>;
    case 'List<Map<String, dynamic>>':
      return jsonDecode(value) as List<Map<String, dynamic>>;
    case 'Map<String, dynamic>':
      return jsonDecode(value) as Map<String, dynamic>;
    default:
      return value;
  }
}

extension on String {
  bool get isEmail => RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+').hasMatch(this);
  bool get isPhone => RegExp(r'^[0-9]{10}').hasMatch(this);
  bool get isNumeric => RegExp(r'^[0-9.]*$').hasMatch(this);
  bool get isName => RegExp(r'^[a-zA-Z.]*$').hasMatch(this);
  bool get isDate => RegExp(r'^[0-9]{4}-[0-9]{2}-[0-9]{2}$').hasMatch(this);
  bool get isDateTime => RegExp(r'^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}$').hasMatch(this);
  bool get isTime => RegExp(r'^[0-9]{2}:[0-9]{2}:[0-9]{2}$').hasMatch(this);
  bool get isDateTimeRange => RegExp(r'^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}-[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}$').hasMatch(this);
  bool get isDateRange => RegExp(r'^[0-9]{4}-[0-9]{2}-[0-9]{2}-[0-9]{4}-[0-9]{2}-[0-9]{2}$').hasMatch(this);
  // ignore: unnecessary_this, prefer_single_quotes
  String get capitalize => "${this[0].toUpperCase()}${this.substring(1)}";
  // ignore: unnecessary_this
  String get capitalizeWords => this.split(' ').map((word) => word.capitalize).join(' ');
  // ignore: unnecessary_this
 
}
