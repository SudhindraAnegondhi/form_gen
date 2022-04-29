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
import '../helpers.dart';

class FieldImagePickerBuilder extends GeneratorForAnnotatedField<FieldImagePicker> {
 
  @override
  String generateForAnnotatedField(FieldElement element, ConstantReader annotation, BuildStep buildstep) {
    final buffer = StringBuffer();
    final properties = Helpers.getClassProperties(FieldImagePicker);
    final map = Helpers.annotationToJson<FieldImagePicker>(element, properties);
    buffer.write('''
      Widget ${element.name}FormField(BuildContext context) {
        return ImagePickerFormField(
          initialValue: _formData[${element.name}],
          decoration: InputDecoration(
            labelText: '${map['label']}',
            hintText: '${map['hint']}',
            helperText: '${map['helper']}',
            errorText: '${map['error']}',
          ),
          onSaved: (value) => _formData(${element.name}) = value,
          validator: (value) {
            if (value == null) {
              return '${map['error']}';
            }
            return null;
          },
        );
      }
    ''');
    return buffer.toString();
  }
}
