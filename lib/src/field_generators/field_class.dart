// **************************************************************************
// Generator: FieldClassBuilder
// **************************************************************************
// ignore_for_file: lines_longer_than_80_chars

import 'package:build/src/builder/build_step.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';
import 'package:flutter_form_annotations/flutter_form_annotations.dart';
import '../generator_for_annotated_field.dart';

class FieldClassBuilder extends GeneratorForAnnotatedField<FieldClass> {
  @override
  String generateForAnnotatedField(
    FieldElement element,
    ConstantReader annotation,
    BuildStep buildstep,
  ) {
    final buffer = StringBuffer();
    final properties = getClassProperties(FieldClass);
    final classMap = annotationToJson(element, properties);
    // some prior preps
    buffer.write('''
      Widget ${element.name}FormField(BuildContext context,  Map<String, dynamic> _formData, {required Function onSaved}) {
        _formData['${element.name}'] ??= ${element.name[0].toUpperCase() + element.name.substring(1)}().toJson();
        return Column(
          children: <Widget>[
    ''');

    for (final Map<String, dynamic> map in classMap['properties'] ?? []) {
      switch (map['annotation']) {
        case 'FieldDropdown':
          String items;
          String initialValue;
          if (map['type'] == 'enum') {
            items = '''
            ${map['name'][0].toUpperCase() + map['name'].substring(1)}.values.map((value) {
                    return DropdownMenuItem(
                      value: value.toString().split('.').last,
                      child: Text(value.toString().split('.').last),
                    );
                  }).toList()
            ''';
            initialValue = '${map['name'][0].toUpperCase() + map['name'].substring(1)}.values.first.toString().split(\'.\').last';
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
          buffer.write('${dropdownField(map['name'] as String, items, initialValue, map)},\n');
          break;
        case 'FieldText':
        case 'FieldTextArea':
        default:
          buffer.writeln("${textField('${map['name']}', '${map['type'] ?? 'String'}', map, parent: element.name)},\n");
          break;
      }
    }
    buffer.write('''     
          ],
        );
      }
    ''');
    return buffer.toString();
  }
}
