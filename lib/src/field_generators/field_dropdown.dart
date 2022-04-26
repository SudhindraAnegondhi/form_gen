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
    final properties = getClassProperties(FieldDropdown);
    final map = annotationToJson(element, properties);
    String items;
    String initialValue;
    if (map['type'] == 'enum') {
      items = '''
       ${element.name[0].toUpperCase() + element.name.substring(1)}.values.map((value) {
              return DropdownMenuItem(
                value: value.toString().split('.').last,
                child: Text(value.toString().split('.').last),
              );
            }).toList()
      ''';
      initialValue = '${element.name[0].toUpperCase() + element.name.substring(1)}.values.first.toString().split(\'.\').last';
    } else {
      items = '[' +
          (map['options'] as List<Map<String, dynamic>>)
              .map((e) =>
                  'const DropdownMenuItem<String>(value: "${e['value'].toString().split('.').last}",' +
                  'child: const Text("${e['label'] ?? e['value'].toString().split('.').last}"))')
              .toList()
              .join(',\n') +
          ']';
      initialValue = (map['options'] as List<Map<String, dynamic>>).map((e) => "'e['value'].toString()'").toList().first;
    }
    buffer.write('''
      Widget ${element.name}FormField(BuildContext context, Map<String, dynamic> _formData, {required Function onSaved}) {
        return ${dropdownField(element.name, items, initialValue, map)};
      }
    ''');

    return buffer.toString();
  }
}
