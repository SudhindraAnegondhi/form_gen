// ignore_for_file: lines_longer_than_80_chars, omit_local_variable_types, avoid_annotating_with_dynamic
import 'dart:convert';

import 'package:build/src/builder/build_step.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';

import 'package:flutter_form_annotations/flutter_form_annotations.dart';

import 'model_visitor.dart';

class FormGenerator extends GeneratorForAnnotation<GenerateForm> {
  // 1
  @override
  String generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) {
    // 2
    final ModelVisitor visitor = ModelVisitor();
    element.visitChildren(visitor); // Visits all the children of element in no particular order.

    // 3
    final className = '${visitor.className}Screen'; // EX: 'ModelScreen' for 'Model'.

    // 4
    final classBuffer = StringBuffer();
    Map<String, dynamic> defs = <String, dynamic>{};
    try {
      final gfield = annotation.objectValue.getField('defs');

      //  print(ovalue);
      final defString = annotation.read('defs').literalValue as String;
      defs = jsonDecode(defString) as Map<String, dynamic>;

      print('******\n\nDEFSTRING: ${defs.toString()}\n\n******');
    } catch (e) {}

    // 5
    //classBuffer.writeln("import 'package:flutter/material.dart';");
    //classBuffer.writeln('import \'package:flutter_form_builder/flutter_form_builder.dart\';');
    final model = visitor.className[0].toLowerCase() + visitor.className.substring(1);
    // *** Start class

    classBuffer.writeln('''
class $className extends StatefulWidget {
  const $className({ Key? key,  required this.$model, required this.add, this.showAppBar = false, this.appBar,}) : super(key: key);
  final ${visitor.className} $model;
  final bool add;
  final AppBar? appBar;
  final bool showAppBar;
  @override
  State<$className> createState() => _${className}State();
}

class _${className}State extends State<$className> {
  final formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return  Scaffold( 
      appBar: widget.showAppBar ? widget.appBar : null,
    body: FormBuilder(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Padding (
          padding: const EdgeInsets.all(8.0),
          child:
        Column(
          children:  <Widget>[ 
            Text(widget.add ? 'Add ${visitor.className}' : 'Edit ${visitor.className}'),
          ''');

    generateFormFields(visitor, classBuffer, model, defs);
    // add/edit cancel buttons
    classBuffer.writeln('''
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: <Widget>[
               ElevatedButton(
                 child: const Text('Cancel'),
                 onPressed: () {
                   Navigator.of(context).pop();
                 },
               ),
               ElevatedButton(
                 child: const Text('Save'),
                 onPressed: formKey.currentState?.saveAndValidate() ?? false  ?
                 () {
                   if (formKey.currentState?.saveAndValidate() ?? false) {
                     Navigator.of(context).pop(widget.$model);
                    }  
                 } : null,
               ),
             ],
           ),
    ''');

    classBuffer.write(''' 
            ],), // column
            ), // padding
          ), // formBuilder
        ); // scaffold
      } // build
    } // class
    ''');

    // 12
    return classBuffer.toString();
  }
}

void generateFormFields(ModelVisitor visitor, StringBuffer classBuffer, String model, Map<dynamic, dynamic> defs) {
  print(defs);
  print(defs.runtimeType.toString());
  for (final field in visitor.fields.keys) {
    // remove '_' from private variables
    final variable = field.startsWith('_') ? field.replaceFirst('_', '') : field;
    final type = defs[variable]?['type']?.toString() ?? visitor.fields[field]?.toString() ?? 'String';
/***  */
    print('$variable $type');

    generateFormField(classBuffer, variable, type, model, field, defs);
  }
}

void generateFormField(StringBuffer classBuffer, String variable, String type, String model, String field, Map<dynamic, dynamic> defs) {
  switch (type) {
    case 'String':
      classBuffer.write('''
         FormBuilderTextField(
              name: '$variable',
              decoration: const InputDecoration(
                labelText:
                    '${variable[0].toUpperCase() + variable.substring(1)}',
              ),
              initialValue: widget.$model.$variable,
              onChanged: (value) {
                  widget.$model.$variable = value ?? '';
              },
            ),\n
          ''');
      break;
    case 'int':
      classBuffer.write('''
         FormBuilderTextField(
              name: '$variable',
              initialValue: widget.$model.$variable.toString() ,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText:
                    '${variable[0].toUpperCase() + variable.substring(1)}',
              ),
              onChanged: (value) {
                widget.$model.$variable = int.tryParse(value ?? "0") ?? 0;
              },
            ),\n
          ''');
      break;
    case 'double':
      classBuffer.write('''
         FormBuilderTextField(
              name: '$variable',
              initialValue: widget.$model.$variable?.toString() ",
              inputType: TextInputType.number,
              decoration: const InputDecoration(
                labelText:
                    '${variable[0].toUpperCase() + variable.substring(1)}',
              ),
              onChanged: (value) {
                 widget.$model.$variable = double.tryParse(value ?? "0.0") ?? ;
              },
            ),\n
          ''');
      break;
    case 'bool':
      classBuffer.write('''
         FormBuilderCheckbox(
              name: '$variable',
              initialValue:  widget.$model.$variable,
              onChanged: (value) {
                 widget.$model.$variable = value ?? false;
              },
              title: Text('${variable[0].toUpperCase() + variable.substring(1)}'),
            ),\n
          ''');
      break;

    case 'DateTime':
      classBuffer.write('''
          FormBuilderDateTimePicker(
                name: '$variable',
                initialValue: widget.$model.$variable,
                decoration: const InputDecoration(
                  labelText:
                      '${variable[0].toUpperCase() + variable.substring(1)}',
                ),
                onChanged: (value) {
                  widget.$model.$variable = value ?? DateTime.now();
                },
              ),\n
            ''');
      break;
    case 'enum':
      final enumType = (defs[variable]?['values']?.first ?? '').toString().split('.').first;
      if (enumType.isEmpty) {
        print('enum type not found for $variable');
        break;
      }
      classBuffer.write('''
          FormBuilderDropdown(
                name: '$variable',
                initialValue: widget.$model.$variable,
                decoration: const InputDecoration(
                  labelText:
                      '${variable[0].toUpperCase() + variable.substring(1)}',
                ),
                onChanged: ($enumType? value) {
                  widget.$model.$variable = value ?? $enumType.values.first;
                },
                items: ${defs[variable]!['values']}.map<DropdownMenuItem<$enumType>>((value) {
                  return DropdownMenuItem<$enumType>(
                    value: $enumType.values.firstWhere((e) => e == value),
                    child: Text(value.toString().split('.').last),
                  );
                }).toList(),
              ),\n
            ''');
      break;
    case 'options':
      break;
    case 'object':
      final classType = defs[variable]?['class']?.toString();
      if (classType != null) {
        classBuffer.writeln('${classType}Widget(context, widget.$model.$variable)');
        break;
      } else {
        // ignore: avoid_annotating_with_dynamic
        defs[variable]?['properties']?.forEach((String key, dynamic value) {
          generateFormField(
            classBuffer,
            '$variable.$key',
            defs[variable]?['properties']?[key]?['type']?.toString() ?? 'String',
            model,
            field,
            defs,
          );
        });
      }
      break;
    default:
      break;
  }
}

class SubFormGenerator extends GeneratorForAnnotation<GenerateSubForm> {
  @override
  String generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) {
    final ModelVisitor visitor = ModelVisitor();
    element.visitChildren(visitor); // Visits all the children of element in no particular order.

    final widgetName = '${visitor.className}Widget'; // EX: 'ModelWidget' for 'Model'.

    final classBuffer = StringBuffer();
    Map<dynamic, dynamic> defs = <dynamic, dynamic>{};
    try {
      defs = annotation.read('defs').mapValue;
    } catch (e) {}
    final model = visitor.className[0].toLowerCase() + visitor.className.substring(1);
    // *** Start class

    classBuffer.write('''
     Widget $widgetName(BuildContext context, String  $model) {
       return  Column(
          children: <Widget>[
    ''');
    generateFormFields(visitor, classBuffer, model, defs);
    classBuffer.write('''
          ],
        );
      ''');

    return classBuffer.toString();
  }
}
