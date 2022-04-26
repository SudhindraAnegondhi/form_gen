// ignore_for_file: lines_longer_than_80_chars, omit_local_variable_types, unnecessary_statements
import 'dart:mirrors';
import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'validators.dart' show validatorsMap;

const _dartTypes = ['int', 'double', 'DateTime', 'String', 'bool', 'List', 'Map'];

abstract class GeneratorForAnnotatedField<AnnotationType> extends Generator {
  /// Returns the annotation of type [AnnotationType] of the given [element],
  /// or [null] if it doesn't have any.
  DartObject? getAnnotation(Element element) {
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

  @override
  String generate(LibraryReader library, BuildStep buildStep) {
    final values = <String>{};

    for (final element in library.allElements) {
      if (element is ClassElement && !element.isEnum) {
        for (final field in element.fields) {
          final annotation = getAnnotation(field);
          if (annotation != null) {
            values.add(generateForAnnotatedField(
              field,
              ConstantReader(annotation),
              buildStep,
            ));
          }
        }
      }
    }

    return values.join('\n\n');
  }

  dynamic _annotationToValue(String property, String type, DartObject? annotation, Map<String, dynamic> properties) {
    if (type == 'String') {
      return annotation?.getField(property)?.toStringValue();
    } else if (type == 'bool') {
      return annotation?.getField(property)?.toBoolValue();
    } else if (type == 'int') {
      return annotation?.getField(property)?.toIntValue();
    } else if (type == 'double') {
      return annotation?.getField(property)?.toDoubleValue();
    } else if (type == 'List<String>') {
      return annotation?.getField(property)?.toListValue()?.map((e) => e.toStringValue()).toList();
    } else if (type == 'Map<String, dynamic>') {
      final mapObj = annotation?.getField(property)?.toMapValue();
      final mapObjKeys = mapObj?.keys.toList();
      final map = <String, dynamic>{};
      for (final DartObject? objKey in mapObjKeys ?? []) {
        final String strKey = objKey?.toStringValue() ?? '  ';
        map[strKey] = mapObj?[objKey]?.toStringValue();
      }
      return map;
    } else if (type == 'List<Map<String, dynamic>>' || type == 'List<Map<String, String>>') {
      final List<Map<String, dynamic>?> list = [];
      final items = annotation?.getField(property)?.toListValue();
      for (final item in items ?? []) {
        final map = <String, dynamic>{};
        final mapObj = item?.toMapValue();
        final mapObjKeys = mapObj?.keys.toList();
        for (final DartObject? objKey in mapObjKeys ?? []) {
          final String strKey = objKey?.toStringValue() ?? '  ';
          map[strKey] = mapObj?[objKey]
              ?.toStringValue(); // _annotationToValue(strKey, (properties[strKey] ?? 'String') as String, mapObj[objKey] as DartObject, properties);
        }
        list.add(map);
      }
      return list;
    } else if (type == 'unknown' || type == 'dynamic') {
      return annotation?.getField(property)?.toStringValue();
    } else {
      throw Exception('Unknown type: $type');
    }
  }

  static bool classExists(String className) {
    try {
      if (_dartTypes.contains(className)) {
        print('$className is a dart type');
        return false;
      }
      final DeclarationMirror? cm = currentMirrorSystem().isolate.rootLibrary.declarations[Symbol(className)];
      if (cm != null) {
        print('$className is a class');
        return true;
      } else {
        print('$className is not a class');
        return false;
      }
    } catch (e) {
      print(e);
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

  Map<String, String> getClassProperties(Type type) {
    final Map<String, String> properties = {};
    for (final v in reflectClass(type).declarations.values) {
      final _name = MirrorSystem.getName(v.simpleName);
      if (v is VariableMirror) {
        properties[_name] = v.type.reflectedType.toString();
      }
    }
    return properties;
  }

  Map<String, dynamic> annotationToJson(Element element, Map<String, dynamic> properties) {
    final json = <String, dynamic>{};
    final DartObject? annotation = getAnnotation(element);
    for (final property in properties.entries) {
      json[property.key] = _annotationToValue(property.key, property.value as String, annotation, properties);
    }
    return json;
  }

  String composeValidators(List<Map<String, dynamic>?> validators) {
    final _validators = validators.map((e) {
      final func = e!['type'] == null ? e['validator'] : validatorsMap[e['type'] as String];
      if (func == null) {
        throw Exception('Unknown validator type: ${e['type']}');
      }
      return '''
          result = $func(value);
          String  message = '${e['message'] ?? ''}';
          if (result != null) {
            errors.add(message.isEmpty ? result : message);
          }
      ''';
    }).toList();

    return ''' 
    {
      List<String> errors =[];
      ${_validators.join('\n')}
      return errors.isEmpty ? null : errors.join('\\n');
    }
    ''';
  }

  // text properties
  // inputDecorators - fillColor, filled, errorMaxLines, errorStyle
  // textInputAction
  // ignore: avoid_annotating_with_dynamic
  String textField(String elementName, String elementType, Map<String, dynamic> map, {String? parent}) {
    final initialValue = map['initialValue'] ?? '';
    final autovalidateMode = map['autovalidateMode'] ?? 'AutovalidateMode.onUserInteraction';
    return '''
  
   TextFormField(
        initialValue: ${parent == null ? "_formData['$elementName'] ?? '$initialValue'" : "_formData['$parent']?['$elementName'] ?? '$initialValue'"},
        autovalidateMode: $autovalidateMode,
        autoFocus: ${map['autoFocus'] ?? true},
        obscureText: ${map['obscureText'] ?? false},
        decoration: const InputDecoration(
          labelText: '${map['labelText'] ?? elementName[0].toUpperCase() + elementName.substring(1)}',
          labelStyle: ${map['labelStyle'] ?? 'TextStyle(fontSize: 16.0, color: Colors.black)'},
          floatingLabelBehavior: ${map['floatingLabelBehavior'] ?? 'FloatingLabelBehavior.auto'},
          hintText: '${map['hintText'] ?? ''}',
          helperText: '${map['helperText'] ?? ''}',
          errorText: '${map['error'] ?? ''}',
          fillColor: ${map['fillColor'] ?? 'Colors.white'},
          hoverColor: ${map['hoverColor'] ?? 'Color.fromARGB(255, 161, 179, 239)'},
          filled:${map['filled'] ?? 'true'},
          errorMaxLines: ${map['errorMaxLines'] ?? '1'},
          errorStyle: ${map['errorStyle'] ?? 'TextStyle( color: Colors.red, fontSize: 12.0 )'},
          border: ${map['border'] ?? 'OutlineInputBorder()'},
          enabledBorder: ${map['enabledBorder'] ?? 'OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1.0))'},
          focusedBorder: ${map['focusedBorder'] ?? 'OutlineInputBorder(borderSide: BorderSide(color: Colors.blue, width: 1.0))'},
          disabledBorder: ${map['disabledBorder'] ?? 'OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))'},
          enabled: ${map['enabled'] ?? 'true'},
          prefixIcon: ${map['prefixIcon'] ?? 'null'},
          prefixText: ${map['prefixText'] ?? 'null'},
          suffixIcon: ${map['suffixIcon'] ?? 'null'},
          suffixText: ${map['suffixText'] ?? 'null'},
          prefix: ${map['prefix'] ?? 'null'},
          suffix: ${map['suffix'] ?? 'null'},
          counterText: ${map['counterText'] ?? 'null'},
          counterStyle: ${map['counterStyle'] ?? 'null'},
          contentPadding: ${map['contentPadding'] ?? 'EdgeInsets.all(0.0)'},
          isDense: ${map['isDense'] ?? 'false'},
          alignLabelWithHint: ${map['alignLabelWithHint'] ?? 'false'},

        ),
        onSaved: (value) => onSaved('${elementName}', value, parent: '${parent ?? ''}'),
        onChanged:(value) => onSaved('${elementName}', value, parent: '${parent ?? ''}'),
        maxLines: ${map['maxLines'] ?? 1},
        keyboardType: TextInputType.${map['keyboardType'] ?? 'text'},
        inputFormatters: ${map['inputFormatters'] ?? 'null'},
      ) // TextFormField
    ''';
  }

  // ignore: avoid_annotating_with_dynamic
  String dropdownField(String elementName, String items, String initialValue, Map<String, dynamic> map, {String? parent}) {
    return '''
    DropdownButtonFormField(
          value: ${parent == null ? "_formData['$elementName'] ?? $initialValue" : "_formData['$parent']['$elementName'] ?? $initialValue"},
   
          decoration: const InputDecoration(
            labelText: '${map['label'] ?? elementName[0].toUpperCase() + elementName.substring(1)}',
            hintText: '${map['hint'] ?? ''}',
            helperText: '${map['helper'] ?? ''}',
            errorText: '${map['error'] ?? ''}',
          ),
          items: $items,
          onChanged:  (value) => onSaved('${elementName}', value, parent: '${parent ?? ''}'),
          validator: (value) {
            if (value == null) {
              return '${map['error']} ?? "Please select a value"';
            }
            return null;
          },
        )''';
  }

  String generateForAnnotatedField(FieldElement field, ConstantReader annotation, BuildStep buildStep);
}
