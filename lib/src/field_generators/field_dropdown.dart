// **************************************************************************
// Generator: FieldTextBuilder
// **************************************************************************
// ignore_for_file: lines_longer_than_80_chars

import 'package:build/src/builder/build_step.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';
import 'package:flutter_form_annotations/flutter_form_annotations.dart';
import '../generator_for_annotated_field.dart';
import '../model_visitor.dart';

class FieldDropdownBuilder extends GeneratorForAnnotatedField<FieldDropdown> {
  @override
  String generateForAnnotatedField(FieldElement element, ConstantReader annotation, BuildStep buildstep) {
    final buffer = StringBuffer();
    final map = annotationToJson(element, $properties);
    if (map['type'] == 'enum') {
      buffer.write('''
        Widget ${element.name}FormField(BuildContext context, Map<String, dynamic> _formData, {Function? onSaved}) {
          return DropdownButtonFormField<String>(
            value: _formData['${element.name}'],
            decoration: InputDecoration(
              labelText: '${map['label']}',
              hintText: '${map['hint']}',
              helperText: '${map['helper']}',
              errorText: '${map['error']}',
            ),
            items: ${element.name[0].toUpperCase() + element.name.substring(1)}.values.map((value) {
              return DropdownMenuItem(
                value: value.toString().split('.').last,
                child: Text(value.toString().split('.').last),
              );
            }).toList(),
            onChanged:  onSaved == null ? null : (value) => onSaved(value),
            validator: (value) {
              if (value == null) {
                return '${map['error']}';
              }
              return null;
            },
          );
        }
      ''');
    } else {
      final items = (map['options'] as List<Map<String, dynamic>>)
              .map((e) =>
                  'const DropdownMenuItem<String>(value: "${e['value'].toString().split('.').last}",' +
                  'child: const Text("${e['label'] ?? e['value'].toString().split('.').last}"))')
              .toList()
              .join(',\n') +
          ']';
      buffer.write('''
      Widget ${element.name}FormField(BuildContext context) {
        return DropdownButtonFormField(
          value: _formData[${element.name}],
          decoration: InputDecoration(
            labelText: '${map['label']}',
            hintText: '${map['hint']}',
            helperText: '${map['helper']}',
            errorText: '${map['error']}',
          ),
          items: $items,
          onChanged: (value) => _formData(${element.name}) = value,
          validator: (value) {
            if (value == null) {
              return '${map['error']}';
            }
            return null;
          },
        );
      }
    ''');
    }
    return buffer.toString();
  }
}
