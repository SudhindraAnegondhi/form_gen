// **************************************************************************
// Generator: FieldDateTimePickerBuilder
// **************************************************************************
// ignore_for_file: lines_longer_than_80_chars, omit_local_variable_types, unnecessary_cast

import 'package:build/src/builder/build_step.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';
import 'package:form_gen/annotations/form_annotations.dart';
import '../generator_for_annotated_field.dart';
import '../helpers.dart';

class FieldDatePickerBuilder extends GeneratorForAnnotatedField<FieldDatePicker> {
  @override
  String generateForAnnotatedField(FieldElement element, ConstantReader annotation, BuildStep buildstep) {
    final buffer = StringBuffer();

    final properties = Helpers.getClassProperties(FieldDatePicker);
    final map = Helpers.annotationToJson<FieldDatePicker>(element, properties);
    buffer.write('''
      Widget ${element.name}FormField(BuildContext context, Map<String, dynamic> _formData, {required Function onSaved, required double width}) {
        String? initialDate = "${map['initialDate'] ?? ''}";
        if(initialDate.isEmpty) {
          initialDate = null;
        }
        String  firstDate = "${map['firstDate'] ?? ''}";
        String  lastDate = "${map['lastDate'] ?? ''}"; 
   
        // Condition # 1 - a  If firstDate is empty, then set firstDate
        //  if initialDate is not empty then before initialDate, else current date
        firstDate = firstDate.isEmpty ? (lastDate.isEmpty?
        DateTime.now().subtract(const Duration(days: 365)).toIso8601String() : DateTime.parse(lastDate).subtract(const Duration(days: 365)).toIso8601String()) : firstDate;
       
        // Condition # 2 initialDate is either null or on after firstDate.
        if(initialDate != null && DateTime.parse(initialDate).isBefore(DateTime.parse(firstDate))) {
          initialDate = null;
        }
        // Condition # 3 last date must be after firstDate
        if(lastDate.isEmpty || DateTime.parse(lastDate).isBefore(DateTime.parse(firstDate))) {
          lastDate = DateTime.parse(firstDate).add(const Duration(days: 1)).toIso8601String();
        } 
     
        return Padding(
          padding: const EdgeInsets.only(bottom: 15.0), 
          child: ${dateTimePickerField(element.name, element.type.toString(), map)},
        );
      }
    ''');
    return buffer.toString();
  }
}
