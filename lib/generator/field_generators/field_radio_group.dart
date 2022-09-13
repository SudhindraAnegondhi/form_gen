// **************************************************************************
// Generator: FieldRadioGroupBuilder
// **************************************************************************
// ignore_for_file: lines_longer_than_80_chars

import 'package:build/src/builder/build_step.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';
import 'package:form_gen/annotations/form_annotations.dart';
import '../generator_for_annotated_field.dart';
import '../helpers.dart';

class FieldRadioBuilder extends GeneratorForAnnotatedField<FieldRadio> {
  @override
  String generateForAnnotatedField(FieldElement element, ConstantReader annotation, BuildStep buildstep) {
    final buffer = StringBuffer();
    final properties = Helpers.getClassProperties(FieldRadio);
    final map = Helpers.annotationToJson<FieldRadio>(element, properties);

    buffer.write('''
      Widget ${element.name}FormField(BuildContext context, Map<String, dynamic> _formData, {required Function onSaved, required double width}) {
      
         ${radioField(element.name, element.type.toString(), map)};
      }
    ''');
    return buffer.toString();
  }
}
