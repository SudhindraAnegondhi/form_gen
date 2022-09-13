// **************************************************************************
// Generator: FieldRangeSliderBuilder
// **************************************************************************
// ignore_for_file: lines_longer_than_80_chars

import 'package:build/src/builder/build_step.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';
import 'package:form_gen/annotations/form_annotations.dart';
import '../generator_for_annotated_field.dart';
import '../helpers.dart';

class FieldRangeSliderBuilder extends GeneratorForAnnotatedField<FieldRangeSlider> {
  @override
  String generateForAnnotatedField(FieldElement element, ConstantReader annotation, BuildStep buildstep) {
    final buffer = StringBuffer();
    final properties = Helpers.getClassProperties(FieldRangeSlider);
    print('PROPERTIES: ${properties.toString()}');
    final map = Helpers.annotationToJson<FieldRangeSlider>(element, properties);
    print('MAP: ${map.toString()}');
    buffer.write('''
      Widget ${element.name}FormField(BuildContext context, Map<String, dynamic> _formData, {required Function onSaved, required double width}) {
        late RangeLabels rangeLabels;
        const configuredLabels = '${map['labels'] ?? ','}';
        // formatter for labels
        String __semanticFormatter(RangeValues value) {
          Future.delayed(Duration.zero, () => onSaved('${element.name}', '\${value.start.toString()},\${value.end.toString()}', parent: '${map['parent'] ?? ''}'));
          ${map['semanticFormatterStart'] == null ? '' : '''
          String callback(double value) ${map['semanticFormatterStart']}
            callback(value);
          '''}
          rangeLabels = RangeLabels(configuredLabels.split(',').first +  value.start.round().toString(), 
          configuredLabels.split(',').last + value.end.round().toString()); 
          return '\${value.start.round().toString()} - \${value.end.round().toString()}';
        }
        
         double? start =_formData['${element.name}'] == null ? null : 
         double.tryParse(_formData['${element.name}']?.split(',').first ?? \"${map['start']?.toString() ?? '0.0'}\");
         double? end =  _formData['${element.name}'] == null ? null : double.tryParse(_formData['${element.name}']?.split(',').last ?? \"${map['end']?.toString() ?? '0.0'}\");
        const double? min =${map['min'] ?? 0.0};
        const double? max =${map['max'] ?? 100.0};
        if((start ?? 0.0) < min) start = min;
        if((end ?? 0.0) > max) end = max;
        RangeValues _currentRangeValues = RangeValues(start ?? min,end ?? max);
        __semanticFormatter(_currentRangeValues);
        
        _formData['${element.name}'] = _formData['${element.name}'] ?? '\${_currentRangeValues.start.round().toString()},\${_currentRangeValues.end.round().toString()}';
        ${rangeSliderField(element.name, element.type.toString(), map)};
      }
    ''');
    return buffer.toString();
  }
}
