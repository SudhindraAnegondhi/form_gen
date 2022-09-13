// **************************************************************************
// Generator: FieldSwitchBuilder
// **************************************************************************
// ignore_for_file: lines_longer_than_80_chars

import 'package:build/src/builder/build_step.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';
import 'package:form_gen/annotations/form_annotations.dart';
import 'package:form_gen/generator/generator_for_annotated_field.dart';
import 'package:form_gen/generator/helpers.dart';

class FieldSwitchBuilder extends GeneratorForAnnotatedField<FieldSwitch> {
  @override
  String generateForAnnotatedField(FieldElement element, ConstantReader annotation, BuildStep buildstep) {
    final buffer = StringBuffer();
    final properties = Helpers.getClassProperties(FieldSwitch);
    final map = Helpers.annotationToJson<FieldSwitch>(element, properties);
    buffer.write('''
      Widget ${element.name}FormField(BuildContext context, Map<String, dynamic> _formData, {required Function onSaved, reuired double width}) {
        return ${switchField(element.name, element.type.toString(), map)};
      }
    ''');
    return buffer.toString();
  }
}
