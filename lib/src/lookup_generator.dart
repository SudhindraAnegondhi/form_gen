// ignore_for_file: lines_longer_than_80_chars, omit_local_variable_types

import 'package:build/src/builder/build_step.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';
import 'package:flutter_form_annotations/flutter_form_annotations.dart';
import 'model_visitor.dart';

class LookupGenerator extends GeneratorForAnnotation<GenerateForm> {
  @override
  String generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) {
    /*
    final buffer = StringBuffer();

    generateFields(buffer, element as ClassElement, annotation);
    return buffer.toString();
    */
    final buffer = StringBuffer();
    final ModelVisitor visitor = ModelVisitor();
    element.visitChildren(visitor);
    final className = '${visitor.className}Screen'; // EX: 'ModelScreen' for 'Model'.
    final model = visitor.className[0].toLowerCase() + visitor.className.substring(1);
    final List<Map<String, dynamic>> fields = getModelFields(element as ClassElement, annotation);
    print(fields.toString());
    /*
    generateHeader(buffer, className, visitor.className, model, fields);
    print(buffer.toString());
    generateFields(buffer, fields);
    generateFooter(buffer, className);
    */
    return buffer.toString();
  }

  dynamic getValue(String annotation, FieldElement f, String arg) {
    final typeChecker = TypeChecker.fromRuntime(annotations[annotation]!);
    final argType = arg.split(' ').first.replaceAll('?', '');
    final argName = arg.split(' ').last;
    final argvalue = typeChecker.firstAnnotationOf(f)?.getField('$argName')?.toStringValue();
    if (argvalue != null) {
      return stringToTypeValue(argType, argvalue);
    }
  }

  List<Map<String, dynamic>> getModelFields(ClassElement element, ConstantReader annotation) {
    final List<Map<String, dynamic>> fields = [];
    for (final f in element.fields) {
      final Map<String, dynamic> field = <String, dynamic>{
        'name': f.name,
        'type': f.type.toString(),
      };

      final meta = f.metadata.map((e) => e.toString()).toList().toString();
    
      final annotation = meta.split(' ').first.substring(1); // skip the @
      if (annotations[annotation] == null) {
        // ignore unknown annotations
        continue;
      }
      field['annotation'] = annotation;
      final constructor = meta.split(' ').last;
      final args = constructor.split('(').sublist(1).join().split(')').first.split(',');
      for (final arg in args) {
        field['meta'][arg.split(' ').last] = getValue(annotation, f, arg);
      }
      fields.add(field);
    } // assembled fields - now to handle sorting, followed by nested fields
    print('fields: ${fields.toString()}');
    if (fields.any((f) => f['sequence'] != null)) {
      // sort fields by sequence even if one object's sequence is set
      // if sequence is null, set it to last number
      fields.sort((a, b) => (a['sequence'] == null ? fields.length : a['sequence']!).compareTo(b['sequence']!) as int);
    } else {
      // sort fields by name
      fields.sort((a, b) => a['name'].compareTo(b['name']) as int);
    }
    // generate a new sequence for each field
    for (int i = 0; i < fields.length; i++) {
      fields[i]['sequence'] = i;
    }
    // if any of the field['annotation'] have a 'FieldClass' annotation key set,
    // process the field's nested fields
    for (final field in fields) {
      if (field['annotation'] == 'FieldClass') {
        field['nestedFields'] = decodeMeta(field); // list from properites  of FieldClass
      }
    }
    return fields;
  }

  List<Map<String, dynamic>> decodeMeta(Map<String, dynamic> field) {
    final List<Map<String, dynamic>> nestedfields = [];
    double sequence = field['sequence'] as double;
    for (final key in field['meta']['properties'].keys) {
      sequence = sequence + 0.001;
      final Map<String, dynamic> nestedfield = <String, dynamic>{
        'name': key,
        'type': field['meta']['properties'][key]['type'],
        'annotation': field['meta']['properties'][key]['annotation'],
        'sequence': sequence,
      };
      nestedfields.add(nestedfield);
    }
    return nestedfields;
  }

  void generateFields(StringBuffer buffer, ClassElement element, ConstantReader annotation) {
    final List<Map<String, dynamic>> fields = [];
    for (final f in element.fields) {
      buffer.writeln('// ${f.name}\n//${f.metadata.map((e) => e.toString()).toList().join('\n//')}');
      final Map<String, dynamic> field = <String, dynamic>{
        'name': f.name,
        'type': f.type.toString(),
        'sequence': null,
        'annotation': [],
        'metadata': f.metadata,
      };
      final List<Map<String, dynamic>> props = [];
      for (final key in annotations.keys) {
        final typeChecker = TypeChecker.fromRuntime(annotations[key]!);
        if (typeChecker.hasAnnotationOfExact(f)) {
          var value;
          for (final prop in $properties.keys) {
            switch ($properties[prop]) {
              case String:
                value = typeChecker.firstAnnotationOfExact(f)?.getField(prop)?.toStringValue();
                break;
              case int:
                value = typeChecker.firstAnnotationOfExact(f)?.getField(prop)?.toIntValue();
                break;
              case bool:
                value = typeChecker.firstAnnotationOfExact(f)?.getField(prop)?.toBoolValue();
                break;
              case DateTime:
                value = DateTime.parse(typeChecker.firstAnnotationOfExact(f)?.getField(prop)?.toStringValue() ?? '');
                break;
              case List<Map<String, dynamic>>:
                value = List<Map<String, dynamic>>.from(typeChecker.firstAnnotationOfExact(f)?.getField(prop)?.toListValue() ?? []);
                break;
              case List<String>:
                value = List<String>.from(typeChecker.firstAnnotationOfExact(f)?.getField(prop)?.toListValue() ?? []);
                break;
              case Map<String, dynamic>:
                value = Map<String, dynamic>.from(typeChecker.firstAnnotationOfExact(f)?.getField(prop)?.toMapValue() ?? {});
                break;
            }
            if (prop == 'sequence' && field['sequence'] == null) {
              field['sequence'] = value;
            }
            props.add({
              'annotation': key,
              'property': prop,
              'type': $properties[prop],
              'value': value,
            });
          }
          field['annotation'].add({
            'name': key,
            'props': props,
          });
        }
      }
    } // assembled fields - now to handle sorting, followed by nested fields
    if (fields.any((f) => f['sequence'] != null)) {
      // sort fields by sequence even if one object's sequence is set
      // if sequence is null, set it to last number
      fields.sort((a, b) => (a['sequence'] == null ? fields.length : a['sequence']!).compareTo(b['sequence']!) as int);
    } else {
      // sort fields by name
      fields.sort((a, b) => a['name'].compareTo(b['name']) as int);
    }
    // generate a new sequence for each field
    for (int i = 0; i < fields.length; i++) {
      fields[i]['sequence'] = i;
    }
    // if any of the field['annotation'] have a 'FieldClass' annotation key set,
    // process the field's nested fields
    for (final field in fields) {
      buffer.writeln('${field.toString()}');
    }
  }

  void generateFieldsOld(StringBuffer buffer, ClassElement element, ConstantReader annotation) {
    //final List<Map<String, dynamic>> fields = [];
    for (final f in element.fields) {
      // first check if this is a class/object

      for (final key in annotations.keys) {
        final typeChecker = TypeChecker.fromRuntime(annotations[key]!);
        if (typeChecker.hasAnnotationOfExact(f)) {
          buffer.writeln('// found $key');
          for (final prop in $properties.keys) {
            final value = typeChecker.firstAnnotationOf(f)?.getField(prop)?.toStringValue();
            if (value != null) {
              buffer.writeln('// $key $prop: $value');
            }
          }
        }
      }
    }
  }
}
