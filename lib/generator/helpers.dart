// ignore_for_file: lines_longer_than_80_chars, omit_local_variable_types, unnecessary_this, unused_element

import 'dart:mirrors';
import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/src/type_checker.dart';

import '../validators.dart';

const _dartTypes = ['int', 'double', 'DateTime', 'String', 'bool', 'List', 'Map'];

class Helpers {
  static bool classExists(String className) {
    try {
      if (_dartTypes.contains(className)) {
        return false;
      }
      final DeclarationMirror? cm = currentMirrorSystem().isolate.rootLibrary.declarations[Symbol(className)];
      if (cm != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Map<String, String> getClassNameProperties(String className) {
    final Map<String, String> properties = <String, String>{};
    final DeclarationMirror? cm = currentMirrorSystem().isolate.rootLibrary.declarations[Symbol(className)];
    if (cm is ClassMirror) {
      for (final DeclarationMirror dm in cm.declarations.values) {
        if (dm is VariableMirror) {
          final String name = MirrorSystem.getName(dm.simpleName);
          final String type = MirrorSystem.getName(dm.type.simpleName);
          properties[name] = type;
        }
      }
    }
    return properties;
  }

  static Map<String, String> getClassProperties(Type type) {
    final Map<String, String> properties = {};
    for (final v in reflectClass(type).declarations.values) {
      final _name = MirrorSystem.getName(v.simpleName);
      if (v is VariableMirror) {
        properties[_name] = v.type.reflectedType.toString();
      }
    }
    return properties;
  }

  static dynamic decodeDartObject(DartObject? dartObject) {
    if (dartObject == null || dartObject.type == null) {
      return null;
    }
    if (dartObject.type?.toString() == 'String') {
      return dartObject.toStringValue();
    } else if (dartObject.type!.toString() == 'int') {
      return dartObject.toIntValue();
    } else if (dartObject.type!.toString() == 'double') {
      return dartObject.toDoubleValue();
    } else if (dartObject.type!.toString() == 'bool') {
      return dartObject.toBoolValue();
    } else if (dartObject.type!.toString().startsWith('List')) {
      final List<dynamic> list = [];
      for (final DartObject item in dartObject.toListValue() ?? []) {
        list.add(decodeDartObject(item));
      }
      return list;
    } else if (dartObject.type!.toString().startsWith('Map')) {
      final Map<String, dynamic> map = {};
      for (final key in dartObject.toMapValue()!.keys.toList()) {
        if (key?.type.toString() == 'FieldValidator') {
          final str = key!.getField('_name').toString().split("'")[1];
          map['$str'] = decodeDartObject(dartObject.toMapValue()?[key]);
          ////  print('Field Validator Map Value: ${map['$str'].toString()} keys: ${map['$str'].keys.toString()}');
        } else {
          map[key?.toStringValue() ?? ' '] = decodeDartObject(dartObject.toMapValue()?[key]);
        }
      }
      return map;
    } else {
      return null;
    }
  }

  static DartObject? getAnnotation<AnnotationType>(Element element) {
    final annotations = TypeChecker.fromRuntime(AnnotationType).annotationsOf(element);
    if (annotations.isEmpty) {
      return null;
    }
    if (annotations.length > 1) {
      throw Exception('You tried to add multiple @$AnnotationType() annotations to the '
          "same element (${element.name}), but that's not possible.");
    }
    return annotations.single;
  }

  static Map<String, dynamic> annotationToJson<AnnotationType>(Element element, Map<String, dynamic> properties) {
    final json = <String, dynamic>{};
    final DartObject? annotation = getAnnotation<AnnotationType>(element);
    if (annotation != null) {
      for (final String property in properties.keys) {
        // final DartObject? value = annotation.getField(property);
        json['$property'] = decodeDartObject(annotation.getField(property));
      }
    }
    return json;
  }

  /// Validators can be specified in two ways.
  /// 1. Using any of the documented validator types.
  ///    This is done by specifying the validator type in the annotation, followed by an
  ///    optional list of parameters.
  /// 2. Using a custom validator function. The function must be specified as
  ///    {"function": "myCustomValidatorFunction"}
  ///    The function must accept a single parameter, which is the value to validate.\
  ///    the function must return a null if the value is valid, or a string describing the error.
  ///
  // ignore: avoid_annotating_with_dynamic
  static String _composeValidators(dynamic validators) {
    if (validators is! List) {
      throw Exception('Validators must be a list, but got ${validators.runtimeType} : $validators');
    }
    final _validators = validators.map((e) {
      String? func;

      if ((e?['type'] ?? 'custom') == 'custom') {
        func = e?['function'] as String?;
      } else {
        for (final key in validatorsMap.keys) {
          if (key == 'required') {
            func = validatorsMap[key];
            break;
          } else if (key == e?['type'] as String) {
            func = key;
          }
        }
        if (func == null) {
          throw Exception('Unknown validator type: ${e?['type']}');
        }
      }

      if (['min', 'max', 'minLength', 'maxLength', 'range'].contains(e?['type'])) {
        return '''result = ${func}(${e?['length']})
         if (result != null) {
           const  message = '${e?['message']}';
            errors.add(message.isEmpty ? result : '${e?['message'] ?? ''}');
          }
        ''';
      } else {
        return '''
          result = $func
          if (result != null) {
            const message = '${e?['message']}';
            errors.add(message.isEmpty ? result : '${e?['message'] ?? ''}');
          }
      ''';
      }
    }).toList();
    if (_validators.isEmpty) {
      return '';
    }
    return ''' 
    validator: (value) {
      List<String> errors =[];
      String? result;
      ${_validators.join('\n')}
      return errors.isEmpty ? null : errors.join('\\n');
    }
    ''';
  }
}

extension on DateTime {
  String get dateTimeFormat => '${this.day}-${this.month}-${this.year} ${this.hour}:${this.minute}:${this.second}';
  String get DMY => '${this.day}-${this.month}-${this.year}';
  String get YMD => '${this.year}-${this.month}-${this.day}';
  String get MDY => '${this.month}-${this.day}-${this.year}';
}

extension on String {
  bool get isEmail => RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+.[a-zA-Z]+').hasMatch(this);
  bool get isPhone => RegExp(r'^[0-9]{10}').hasMatch(this);
  bool get isNumeric => RegExp(r'^[0-9.]*$').hasMatch(this);
  bool get isName => RegExp(r'^[a-zA-Z.]*$').hasMatch(this);
  bool get isDate => RegExp(r'^[0-9]{4}-[0-9]{2}-[0-9]{2}$').hasMatch(this);
  bool get isDateTime => RegExp(r'^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}$').hasMatch(this);
  bool get isTime => RegExp(r'^[0-9]{2}:[0-9]{2}:[0-9]{2}$').hasMatch(this);
  bool get isDateTimeRange =>
      RegExp(r'^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}-[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}$').hasMatch(this);
  bool get isDateRange => RegExp(r'^[0-9]{4}-[0-9]{2}-[0-9]{2}-[0-9]{4}-[0-9]{2}-[0-9]{2}$').hasMatch(this);
  String get capitalize => '${this[0].toUpperCase()}${this.substring(1)}';
  String get capitalizeWords => this.split(' ').map((word) => word.capitalize).join(' ');
  String camelCase() => this.split(' ').map((word) => word.capitalize).join('');
  String get camelCaseToTitleCase => this.split(' ').map((word) => word.capitalize).join(' ');
}
