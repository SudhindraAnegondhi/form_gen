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
      final defString = annotation.read('defs').literalValue as String;
      defs = jsonDecode(defString) as Map<String, dynamic>;
    } catch (e) {}

    // 5
    //classBuffer.writeln("import 'package:flutter/material.dart';");
    //classBuffer.writeln('import \'package:flutter_form_builder/flutter_form_builder.dart\';');
    final model = visitor.className[0].toLowerCase() + visitor.className.substring(1);
    // *** Start class
    classBuffer.writeln('''
class $className extends StatefulWidget {
  const $className({ Key? key,   this.$model, required this.add, this.showAppBar = false, this.appBar,
  this.size, this.textStyle, this.color, this.textColor, this.headlineStyle, 
  this.backgroundColor, this.backgroundImage, this.backgroundImageFit,
  }) : super(key: key);
  final ${visitor.className}? $model;
  final bool add;
  final AppBar? appBar;
  final bool showAppBar;
  final Size? size;
  final TextStyle? textStyle;
  final Color? color;
  final Color? textColor;
  final Color? backgroundColor;
  final Image? backgroundImage;
  final BoxFit? backgroundImageFit;
  final TextStyle? headlineStyle;
  @override
  State<$className> createState() => _${className}State();
}

class _${className}State extends State<$className> {
  final formKey = GlobalKey<FormBuilderState>();
   Map<String, dynamic> modelMap = <String, dynamic>{};

  @override
  void initState() {
    super.initState();
    modelMap = widget.$model?.toJson() ?? <String, dynamic>{};
    initModel();
  }

  ''');


  initModel(visitor, classBuffer, model, defs);

  classBuffer.writeln('''
  double min(double a, double b) => a < b ? a : b;
  
  @override
  Widget build(BuildContext context) {
    return  Scaffold( 
      appBar: widget.showAppBar ? widget.appBar : null,
    body: Center(child:
    Container(
      width: widget.size?.width ?? MediaQuery.of(context).size.width * 0.8,
      height: widget.size?.height ?? min(MediaQuery.of(context).size.height * 0.8, ${visitor.fields.keys.length}  * 85),
      color: widget.backgroundColor ?? Colors.white,
      child: Card(
        elevation: 15,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        shadowColor: Colors.black,
        child:  
        SingleChildScrollView (
    child: FormBuilder(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Padding (
          padding: const EdgeInsets.all(20.0),
          child:
        Column(
          children:  <Widget>[ 
            Text(widget.add ? 'Add ${visitor.className}' : 'Edit ${visitor.className}',
            style: widget.headlineStyle ?? Theme.of(context).textTheme.headline6,
            ),
          ''');

    generateFormFields(visitor, classBuffer, model, defs);
    // add/edit cancel buttons
    classBuffer.writeln('''
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
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
                      Navigator.of(context).pop(${visitor.className}.fromJson(modelMap));
                      }  
                  } : null,
                ),
              ],
            ),
          ),
    ''');

    classBuffer.write(''' 
            ],), // column
            ), // padding
          ), // formBuilder
        ), // singleChildScrollView
          ), // card
        ), // container
      ), // center
        ); // scaffold
      } // build
    } // class
    ''');

    // 12
    return classBuffer.toString();
  }
}

void initModel(ModelVisitor visitor, StringBuffer classBuffer, String model, Map<String, dynamic> defs) {
  classBuffer.write('''
     void initModel() {    
  ''');
  for (final field in visitor.fields.keys) {
    // remove '_' from private variables
    final variable = field.startsWith('_') ? field.replaceFirst('_', '') : field;
    final type = defs[variable]?['type']?.toString() ?? visitor.fields[field]?.toString() ?? 'String';
    final fieldname = 'modelMap["$variable"]';
    initProperty(classBuffer, fieldname, variable, type, model, defs);
  }
  classBuffer.write('''
   }
  ''');
}

void initProperty(StringBuffer classBuffer, String fieldname, String parentField, String type, String model, Map<String, dynamic> defs) {
  switch (type) {
    case 'String':
      classBuffer.writeln('''$fieldname ??= ''; ''');
      break;
    case 'int':
      classBuffer.writeln('''$fieldname ??= 0;''');
      break;
    case 'double':
      classBuffer.writeln('''$fieldname ??= 0.0;''');
      break;
    case 'bool':
      classBuffer.writeln('''    $fieldname ??= false; ''');
      break;
    case 'DateTime':
      classBuffer.writeln('''   $fieldname ??= DateTime.now(); ''');
      break;
    case 'List':
      classBuffer.writeln('''   $fieldname ??= <dynamic>[]; ''');
      break;
    case 'Map':
      classBuffer.writeln('''   $fieldname ??= <String, dynamic>{}; ''');
      break;
    case 'object':
      final Map<String, dynamic> properties = (defs[parentField]?['properties'] ?? {}) as Map<String, dynamic>;

      classBuffer.write('''
           $fieldname  = <String, dynamic> {};
          ''');
      properties.forEach((String key, dynamic value) {
        final type = properties['type']?.toString() ?? 'String';
        final newFieldmame = '$fieldname["$key"]';
        initProperty(classBuffer, newFieldmame, key, type, model, defs);
      });
  }
}



void generateFormFields(ModelVisitor visitor, StringBuffer classBuffer, String model, Map<dynamic, dynamic> defs) {
  for (final field in visitor.fields.keys) {
    // remove '_' from private variables
    final variable = field.startsWith('_') ? field.replaceFirst('_', '') : field;
    final type = defs[variable]?['type']?.toString() ?? visitor.fields[field]?.toString() ?? 'String';
    final fieldname = 'modelMap["$variable"]';
    generateFormField(classBuffer, variable, type, 'modelMap', fieldname, defs);
  }
}

void generateFormField(StringBuffer classBuffer, String variable, String type, String parent, String fieldname, Map<dynamic, dynamic> defs) {
  //final parent = 'modelMap!' + (model.isEmpty ? '' : '${model.split('.').map((e) => '["$e"]').toList().join()}');
  //final fieldname = parent + '["$variable"]';

  switch (type) {
    case 'String':
      classBuffer.write('''
         FormBuilderTextField(
              name: '$variable',
              decoration: const InputDecoration(
                labelText:
                    '${variable[0].toUpperCase() + variable.substring(1)}',
              ),
              initialValue: $fieldname,
              onChanged: (value) {
                setState(() {
                  $fieldname = value;
                });
              },
            ),\n
          ''');
      break;
    case 'int':
      classBuffer.write('''
         FormBuilderTextField(
              name: '$variable',
              initialValue: $fieldname?.toString() ??  '',
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText:
                    '${variable[0].toUpperCase() + variable.substring(1)}',
              ),
              onChanged: (value) {
                  $parent ??= <String, dynamic>{};
                setState(() {
                  $fieldname = int.tryParse(value) ;
                });
               
              },
            ),\n
          ''');
      break;
    case 'double':
      classBuffer.write('''
         FormBuilderTextField(
              name: $fieldname?.toString() ?? '',
              initialValue: ,
              inputType: TextInputType.number,
              decoration: const InputDecoration(
                labelText:
                    '${variable[0].toUpperCase() + variable.substring(1)}',
              ),
              onChanged: (value) {
                if($parent == null) {
                  $parent = <String, dynamic>{};
                }
                setState(() {
                  $fieldname = double.tryParse(value) ?? 0.0;
                });
              },
            ),\n
          ''');
      break;
    case 'bool':
      classBuffer.write('''
         FormBuilderCheckbox(
              name: '$variable',
              initialValue:  $fieldname ?? false,
              onChanged: (value) {
                if($parent == null) {
                  $parent = <String, dynamic>{};
                }
                setState(() {
                  $fieldname = value ?? false;
                });

              },
              title: Text('${variable[0].toUpperCase() + variable.substring(1)}'),
            ),\n
          ''');
      break;

    case 'DateTime':
      classBuffer.write('''
          FormBuilderDateTimePicker(
                name: '$variable',
                initialValue: $fieldname,
                decoration: const InputDecoration(
                  labelText:
                      '${variable[0].toUpperCase() + variable.substring(1)}',
                ),
                onChanged: (value) {
                  if($parent == null) {
                    $parent = <String, dynamic>{};
                  }
                  setState(() {
                    $fieldname = value ?? DateTime.now();
                  });
                },
              ),\n
            ''');
      break;
    case 'enum':
      final enumType = (defs[variable]?['values']?.first ?? '').toString().split('.').first;
      if (enumType.isEmpty) {
        break;
      }
      classBuffer.write('''
          FormBuilderDropdown(
                name: '$variable',
                initialValue: $fieldname,
                decoration: const InputDecoration(
                  labelText:
                      '${variable[0].toUpperCase() + variable.substring(1)}',
                ),
                onChanged: ($enumType? value) {
                  if($parent == null) {
                    $parent = <String, dynamic>{};
                  }
                  setState(() {
                    $fieldname = value ?? $enumType.values.first;
                  });
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
      final newParent = parent == 'modelMap' ? ' $fieldname' : '$parent["$variable"]';
      if (classType != null) {
        classBuffer.writeln('${classType}Widget(context, modelMap($variable), modelMap)');
        break;
      } else {
        final Map<String, dynamic> properties = (defs[variable]?['properties'] ?? {}) as Map<String, dynamic>;
      
        properties.forEach((String key, dynamic value) {
          final type = properties['type']?.toString() ?? 'String';
         // generateFormField(classBuffer, fieldName, type, newParent, key, properties);
          generateFormField(classBuffer, key, type, parent, '$newParent["$key"]', properties);
        });
      }
      break;
    default:
      break;
  }
}

/********** REWRITE THIS *********/

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
