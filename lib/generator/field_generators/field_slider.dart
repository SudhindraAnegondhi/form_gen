// **************************************************************************
// Generator: FieldSliderBuilder
// **************************************************************************
// ignore_for_file: lines_longer_than_80_chars

import 'package:build/src/builder/build_step.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';
import 'package:form_gen/annotations/form_annotations.dart';
import '../generator_for_annotated_field.dart';
import '../helpers.dart';

class FieldSliderBuilder extends GeneratorForAnnotatedField<FieldSlider> {
  @override
  String generateForAnnotatedField(FieldElement element, ConstantReader annotation, BuildStep buildstep) {
    final buffer = StringBuffer();
    final properties = Helpers.getClassProperties(FieldSlider);
    final map = Helpers.annotationToJson<FieldSlider>(element, properties);
    String? parent; // FOR NOW
    buffer.write('''
      Widget ${element.name}FormField(BuildContext context, Map<String, dynamic> _formData, {required Function onSaved,
       required double width}) {
        String semanticLabel = '\${_formData['${element.name}'] ?? ${map['value'] ?? map['min'] ?? 0.0}}';
        String __semanticFormatter(double value) {
         Future.delayed(Duration.zero, () => onSaved('${element.name}', value, parent: '${parent ?? ''}'));
         ${map['semanticFormatter'] == null ? "return '\${value.toStringAsFixed(0)}';" : '''
         String callback(double value) ${map['semanticFormatter']}
         semanticLabel = callback(value);
         return semanticLabel;
         '''}
        }
        _formData['${element.name}'] = _formData['${element.name}'] ?? ${map['value'] ?? map['min'] ?? 0.0};
        return ${sliderField(element.name, element.type.toString(), map)};
      }
    ''');

    return buffer.toString();
  }
}
