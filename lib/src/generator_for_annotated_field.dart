// ignore_for_file: lines_longer_than_80_chars, omit_local_variable_types, unnecessary_statements
import 'dart:mirrors';
import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

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
    } else if (type == 'List<Map<String, dynamic>>') {
      final List<Map<String, dynamic>?> list = [];
      final items = annotation?.getField(property)?.toListValue();
      print('ITEMS:' + items.toString());
      for (final item in items ?? []) {
        final map = <String, dynamic>{};
        final mapObj = item?.toMapValue();
        final mapObjKeys = mapObj?.keys.toList();
        for (final DartObject? objKey in mapObjKeys ?? []) {
          final String strKey = objKey?.toStringValue() ?? '  ';
          map[strKey] = mapObj?[objKey]
              ?.toStringValue();  // _annotationToValue(strKey, (properties[strKey] ?? 'String') as String, mapObj[objKey] as DartObject, properties);
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

  String textField(String elementName, Map<String, dynamic> map) {
    return '''
     TextFormField(
        initialValue: _formData['${elementName}'] ?? '',
        decoration: const InputDecoration(
          labelText: '${map['label'] ?? elementName[0].toUpperCase() + elementName.substring(1)}',
          hintText: '${map['hint'] ?? ''}',
          helperText: '${map['helper'] ?? ''}',
          errorText: '${map['error'] ?? ''}',
        ),
        onSaved: onSaved == onSaved ? null :  (value) => onSaved!(value),
        maxLines: ${map['maxLines'] ?? 1},
        validator: (value) {
          if (value == null) {
            return '${map['error']}';
          }
          return null;
        },
      )''';
  }

  // ignore: avoid_annotating_with_dynamic
  String dropdownField(String elementName, String items, String initialValue, Map<String, dynamic> map) {
    return '''
    DropdownButtonFormField(
          value: _formData['$elementName'] ?? $initialValue,
          decoration: const InputDecoration(
            labelText: '${map['label'] ?? elementName[0].toUpperCase() + elementName.substring(1)}',
            hintText: '${map['hint'] ?? ''}',
            helperText: '${map['helper'] ?? ''}',
            errorText: '${map['error'] ?? ''}',
          ),
          items: $items,
          onChanged: onSaved == null ? null : (value) => onSaved(value),
          validator: (value) {
            if (value == null) {
              return '${map['error']}';
            }
            return null;
          },
        )''';
  }

  String generateForAnnotatedField(FieldElement field, ConstantReader annotation, BuildStep buildStep);
}
