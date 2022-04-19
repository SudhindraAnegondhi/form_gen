// ignore_for_file: lines_longer_than_80_chars, omit_local_variable_types

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
      final map = annotation?.getField(property)?.toMapValue()?.map((k, v) {
        final key = k?.toStringValue() ?? '';
        final type = (properties[property]?[key] ?? '') as String;
        final props = (properties[property]?[key] ?? {}) as Map<String, dynamic>;
        return MapEntry('"$key"', _annotationToValue(key, 'unknown', v, props));
      });
      return map;
    } else if (type == 'List<Map<String, dynamic>>') {
      final List<Map<String, dynamic>?> list = [];
      final items = annotation?.getField(property)?.toListValue();
      items?.forEach((item) {
        final map = item.getField(property)?.toMapValue()?.map((k, v) {
          final key = k?.toStringValue() ?? '';
          final type = (properties[property]?[key] ?? '') as String;
          final props = (properties[property]?[key] ?? {}) as Map<String, dynamic>;
          return MapEntry('"$key"', _annotationToValue(key, 'unknown', item, props));
        });
        list.add(map);
      });
      return list;
    } else if (type == 'unknown') {
      return annotation?.getField(property)?.toStringValue();
    } else {
      throw Exception('Unknown type: $type');
    }
  }

  Map<String, dynamic> annotationToJson(Element element, Map<String, dynamic> properties) {
    final json = <String, dynamic>{};
    final  DartObject? annotation = getAnnotation(element);
    for (final property in properties.entries) {
      json[property.key] = _annotationToValue(property.key, property.value as String, annotation, properties);
    }
    return json;
  }

  String generateForAnnotatedField(FieldElement field, ConstantReader annotation, BuildStep buildStep);
}

