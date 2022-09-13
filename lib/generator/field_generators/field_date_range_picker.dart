// **************************************************************************
// Generator: FieldTextBuilder
// **************************************************************************
// ignore_for_file: lines_longer_than_80_chars

import 'package:build/src/builder/build_step.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';
import 'package:form_gen/annotations/form_annotations.dart';
import '../generator_for_annotated_field.dart';
import '../helpers.dart';

class FieldDateRangePickerBuilder extends GeneratorForAnnotatedField<FieldDateRangePicker> {
  @override
  String generateForAnnotatedField(FieldElement element, ConstantReader annotation, BuildStep buildstep) {
    final buffer = StringBuffer();
    final properties = Helpers.getClassProperties(FieldDateRangePicker);
    final map = Helpers.annotationToJson<FieldDateRangePicker>(element, properties);
    buffer.write('''
      Widget ${element.name}FormField(BuildContext context, Map<String, dynamic> _formData, {required Function onSaved, required double width}) {
        final initialStartDate = (_formData['${element.name}']?.split(',').first ??  "${map['startDate'] ?? DateTime.now().toIso8601String()}").substring(0, 10);
        final initialEndDate = (_formData['${element.name}']?.split(',')?.first ?? "${map['endDate'] ?? DateTime.now().toIso8601String()}").substring(0, 10);
        String firstDate = "${map['firstDate'] ?? ''}";
        String lastDate = "${map['lastDate'] ?? ''}";
        if(firstDate.isEmpty) {
          firstDate = DateTime.parse(initialStartDate).subtract(const Duration(days: 365)).toIso8601String().substring(0, 10);
        }
       if(lastDate.isEmpty) {
          lastDate = DateTime.parse(initialEndDate).add(const Duration(days: 365)).toIso8601String().substring(0, 10);
        }
         ${dateRangePickerField(element.name, element.type.toString(), map)};
        
      }
''');
    return buffer.toString();
  }
}
