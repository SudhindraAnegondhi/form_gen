// ignore_for_file: lines_longer_than_80_chars, omit_local_variable_types, unnecessary_statements

import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'helpers.dart';


abstract class GeneratorForAnnotatedField<AnnotationType> extends Generator {
  /// Returns the annotation of type [AnnotationType] of the given [element],
  /// or [null] if it doesn't have any.
  DartObject? getAnnotation(Element element) {
    final annotations = TypeChecker.fromRuntime(AnnotationType).annotationsOf(element);
    if (annotations.isEmpty) {
      return null;
    }
    if (annotations.length > 1) {
      throw Exception('You tried to add multiple @$AnnotationType() annotations to the '
          "same element (${element.name}), but that's not possible.");
    }
    return annotations.single;
  }

  @override
  String generate(LibraryReader library, BuildStep buildStep) {
    final values = <String>{};

    for (final element in library.allElements) {
      if (element is ClassElement && !element.isEnum) {
        for (final field in element.fields) {
          final annotation = getAnnotation(field);
          if (annotation != null) {
            values.add(generateForAnnotatedField(
              field,
              ConstantReader(annotation),
              buildStep,
            ));
          }
        }
      }
    }

    return values.join('\n\n');
  }

  String textField(String elementName, String elementType, Map<String, dynamic> map, {String? parent}) {
    final initialValue = map['initialValue'] ?? '';
    final autovalidateMode = map['autovalidateMode'] ?? 'AutovalidateMode.onUserInteraction';
    return '''
   SizedBox(
     height: 60,
     child:
   TextFormField(
        initialValue: ${parent == null ? "_formData['$elementName'] ?? '$initialValue'" : "_formData['$parent']?['$elementName'] ?? '$initialValue'"},
        autovalidateMode: $autovalidateMode,
        autofocus: ${map['autoFocus'] ?? true},
        obscureText: ${map['obscureText'] ?? false},
        scrollPadding: const EdgeInsets.all(5.0),
        decoration: const InputDecoration(
          labelText: '${map['labelText'] ?? elementName[0].toUpperCase() + elementName.substring(1)}',
          labelStyle: ${map['labelStyle'] ?? 'TextStyle(fontSize: 16.0, color: Colors.black)'},
          floatingLabelBehavior: ${map['floatingLabelBehavior'] ?? 'FloatingLabelBehavior.auto'},
          hintText: '${map['hintText'] ?? ''}',
          helperText: '${map['helperText'] ?? ''}',
          errorText: '${map['error'] ?? ''}',
          fillColor: ${map['fillColor'] ?? 'Colors.white'},
          hoverColor: ${map['hoverColor'] ?? 'Color.fromARGB(255, 161, 179, 239)'},
          filled:${map['filled'] ?? 'true'},
          errorMaxLines: ${map['errorMaxLines'] ?? '1'},
          errorStyle: ${map['errorStyle'] ?? 'TextStyle( color: Colors.red, fontSize: 12.0 )'},
          border: ${map['border'] ?? 'InputBorder.none'},
          enabledBorder: ${map['enabledBorder'] ?? 'OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1.0))'},
          focusedBorder: ${map['focusedBorder'] ?? 'OutlineInputBorder(borderSide: BorderSide(color: Colors.blue, width: 1.0))'},
          disabledBorder: ${map['disabledBorder'] ?? 'OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))'},
          enabled: ${map['enabled'] ?? 'true'},
          prefixIcon: ${map['prefixIcon'] ?? 'null'},
          prefixText: ${map['prefixText'] ?? 'null'},
          suffixIcon: ${map['suffixIcon'] ?? 'null'},
          suffixText: ${map['suffixText'] ?? 'null'},
          prefix: ${map['prefix'] ?? 'null'},
          suffix: ${map['suffix'] ?? 'null'},
          counterText: ${map['counterText'] ?? 'null'},
          counterStyle: ${map['counterStyle'] ?? 'null'},
          contentPadding: ${map['contentPadding'] ?? 'EdgeInsets.all(5.0)'},
          isDense: ${map['isDense'] ?? 'false'},
          alignLabelWithHint: ${map['alignLabelWithHint'] ?? 'false'},

        ),
        onSaved: (value) => onSaved('${elementName}', value, parent: '${parent ?? ''}'),
        onChanged:(value) => onSaved('${elementName}', value, parent: '${parent ?? ''}'),
        maxLines: ${map['maxLines'] ?? 1},
        keyboardType: TextInputType.${map['keyboardType'] ?? 'text'},
        inputFormatters: ${map['inputFormatters'] ?? 'null'},
        ${Helpers.composeValidators(map['validators'] ?? [])}
      ), // TextFormField
    ) // SizedBox
    ''';
  }

  // ignore: avoid_annotating_with_dynamic
  String dropdownField(String elementName, String items, String initialValue, Map<String, dynamic> map, {String? parent}) {
    return '''
    DropdownButtonFormField(
          value: ${parent == null ? "_formData['$elementName'] ?? $initialValue" : "_formData['$parent']['$elementName'] ?? $initialValue"},
   
          decoration: const InputDecoration(
            labelText: '${map['label'] ?? elementName[0].toUpperCase() + elementName.substring(1)}',
            hintText: '${map['hint'] ?? ''}',
            helperText: '${map['helper'] ?? ''}',
            errorText: '${map['error'] ?? ''}',
          ),
          items: $items,
          onChanged:  (value) => onSaved('${elementName}', value, parent: '${parent ?? ''}'),
          validator: (value) {
            if (value == null) {
              return '${map['error']} ?? "Please select a value"';
            }
            return null;
          },
        )''';
  }

  String generateForAnnotatedField(FieldElement field, ConstantReader annotation, BuildStep buildStep);
}
