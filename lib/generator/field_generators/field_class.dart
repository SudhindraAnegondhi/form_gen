// **************************************************************************
// Generator: FieldClassBuilder
// **************************************************************************
// ignore_for_file: lines_longer_than_80_chars

import 'package:build/src/builder/build_step.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';
import 'package:form_gen/annotations/form_annotations.dart';
import '../generator_for_annotated_field.dart';
import '../helpers.dart';

class FieldClassBuilder extends GeneratorForAnnotatedField<FieldClass> {
  @override
  String generateForAnnotatedField(
    FieldElement element,
    ConstantReader annotation,
    BuildStep buildstep,
  ) {
    final buffer = StringBuffer();
    final properties = Helpers.getClassProperties(FieldClass);
    final classMap = Helpers.annotationToJson<FieldClass>(element, properties);

    // some prior preps
    buffer.write('''
      Widget ${element.name}FormField(BuildContext context,  Map<String, dynamic> _formData, {required Function onSaved, required double width}) {
        _formData['${element.name}'] ??= ${element.name[0].toUpperCase() + element.name.substring(1)}().toJson();
        return Column(
          children: <Widget>[
    ''');

    for (final Map<String, dynamic> map in classMap['properties'] ?? []) {
      switch (map['annotation']) {
        case 'FieldDropdown':
          buffer.writeln('${dropdownField(map['name'] as String, map['type'] as String, map)},\n');
          break;
        case 'FieldText':
        case 'FieldTextArea':
        default:
          buffer.writeln("${textFormField('${map['name']}', '${map['type'] ?? 'String'}', map, parent: element.name)},\n");
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
