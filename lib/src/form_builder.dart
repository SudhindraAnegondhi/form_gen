// ignore_for_file: lines_longer_than_80_chars, omit_local_variable_types

import 'package:build/src/builder/build_step.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';
import 'package:flutter_form_annotations/flutter_form_annotations.dart';
import 'generator_for_annotated_field.dart';
import 'model_visitor.dart';

class FormBuilderGenerator extends GeneratorForAnnotation<FormBuilder> {
  @override
  String generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) {
    final buffer = StringBuffer();
    final ModelVisitor visitor = ModelVisitor();
    element.visitChildren(visitor);
    final className = '${visitor.className}Form'; // EX: 'ModelForm' for 'Model'.
    final fields = '{' +
        visitor.fields.keys
            .map((key) {
              final field = visitor.fields[key] as String;
              final type = visitor.fields[field]?.toString() ?? 'Unknown';

              if (type == 'Unknown' && GeneratorForAnnotatedField.classExists(field)) {
                print('*** class exists: ${field}');
                final properties = GeneratorForAnnotatedField.getClassNameProperties(field);
                return '"$key": {\n' + properties.keys.map((e) => '"$e": null').join(',\n') + '}\n';
              }
              return "'$key': null";
            })
            .toList()
            .join(',\n') +
        '}';
    final String formFieldList =
        visitor.fields.keys.map((key) => '${key}FormField(context, _formData, onSaved:onSaved)').toList().join(',\n');

    buffer.writeln('class $className extends StatefulWidget {');
    buffer.write('''
        const $className({Key? key, this.model, this.onSubmit,   this.showAppBar = true, this.appBar,
      this.size, this.textStyle, this.color, this.textColor, this.headlineStyle, 
      this.backgroundColor, this.backgroundImage, this.backgroundImageFit,}) : super(key: key);
        final ${visitor.className}? model;
        final Function? onSubmit;
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
        _${className}State createState() => _${className}State();
      }

    ''');

    buffer.write('''
      class _${className}State extends State<$className> {
        final _formKey = GlobalKey<FormState>();
        final _formData = <String, dynamic>{};

        @override
        void initState() {
          super.initState();
          _formData.addAll(widget.model?.toJson() ?? $fields );
        }

        double min(double a, double b) => a < b ? a : b;

        void onSaved(String key, dynamic value, {String? parent}) {
          setState(() {
            if (parent != null && parent.isNotEmpty) {
              _formData[parent][key] = value;
            } else {
              _formData[key] = value;
            }
          });
        }

        void onSubmit() {
          if (_formKey.currentState?.validate() ?? false) {
            _formKey.currentState?.save();
           Navigator.of(context).pop(${visitor.className}.fromJson(_formData));
          }
        }

        @override
        Widget build(BuildContext context) {
          return Scaffold(
            appBar: widget.showAppBar ? widget.appBar ??
            AppBar(
              automaticallyImplyLeading: false,
              title:  Text(widget.model == null ? 'Add ${className}' : 'Edit ${className}',
                      style: widget.headlineStyle ?? Theme.of(context).textTheme.headline6,),
               leadingWidth: 70,
                leading: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child:
                      Text('Cancel', style: Theme.of(context).textTheme.button?.copyWith(color: widget.textColor ?? Theme.of(context).colorScheme.onPrimary)),
                ),
            ) : null,
          body: Center(
              child: Container(
                width: widget.size?.width ?? MediaQuery.of(context).size.width,
                height: widget.size?.height ?? min(MediaQuery.of(context).size.height - (widget.showAppBar ? AppBar().preferredSize.height: 0), _formData.keys.toList().length  * 85),
                color: widget.backgroundColor ?? Colors.white,
                child: Card(
                  elevation: 15,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  shadowColor: Colors.black,
                  child:  Padding(
                    padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          $formFieldList,
                          if(widget.appBar == null)
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
                                ), // ElevatedButton
                                ElevatedButton(
                                  child: const Text('Save'),
                                  onPressed: _formKey.currentState?.validate() ?? false  ?
                                  () {
                                    if (_formKey.currentState?.validate() ?? false) {
                                      _formKey.currentState?.save();
                                      Navigator.of(context).pop(${visitor.className}.fromJson(_formData));
                                      }  
                                  } : null,
                                ), // ElevatedButton
                              ], // Children
                            ), //Row
                          ), // Padding
                        ], //Children
                      ), // Column
                    ), //Form
                  ), // SingleChildSrcollView
                  ), // Padding
                ), // Card
              ), // Container
            ), // Center
          );
        }

        void _onChanged(String key, dynamic value) {
          setState(() {
            _formData[key] = value;
          });
        }

        void _onSaved(String key, dynamic value) {
          setState(() {
            _formData[key] = value;
          });
        } 

      
      }
  ''');
    return buffer.toString();
  }
/*
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
  
  List<Map<String, dynamic>> decodeMeta(Map<String, dynamic> field) {
    final List<Map<String, dynamic>> nestedfields = [];
    double sequence = (field['sequence'] ?? 0) as double;
    for (final key in field['meta']['properties']?.keys ?? []) {
      sequence = sequence + 0.1;
      final Map<String, dynamic> nestedField = <String, dynamic>{
        'name': key,
        'type': field['meta']?['properties']?[key]?['type'] ?? 'String',
        'annotation': field['meta']?['properties']?[key]?['annotation'] ?? 'FieldText',
        'sequence': sequence,
      };
      nestedfields.add(nestedField);
    }
    return nestedfields;
  }

  void generateFields(StringBuffer buffer, ClassElement element, ConstantReader annotation) {
    final List<Map<String, dynamic>> fields = [];
    for (final f in element.fields) {
      buffer.writeln('// ${f.name}\n//${f.metadata.map((e) => e.toString()).toList().join('\n//')}');
      final Map<String, dynamic> field = <String, dynamic>{
        'name': f.name,
        'type': f.type.toString(),
        'sequence': null,
        'annotation': [],
        'metadata': f.metadata,
      };
      final List<Map<String, dynamic>> props = [];
      for (final key in annotations.keys) {
        final typeChecker = TypeChecker.fromRuntime(annotations[key]!);
        if (typeChecker.hasAnnotationOfExact(f)) {
          var value;
          for (final prop in $properties.keys) {
            switch ($properties[prop]) {
              case String:
                value = typeChecker.firstAnnotationOfExact(f)?.getField(prop)?.toStringValue();
                break;
              case int:
                value = typeChecker.firstAnnotationOfExact(f)?.getField(prop)?.toIntValue();
                break;
              case bool:
                value = typeChecker.firstAnnotationOfExact(f)?.getField(prop)?.toBoolValue();
                break;
              case DateTime:
                value = DateTime.parse(typeChecker.firstAnnotationOfExact(f)?.getField(prop)?.toStringValue() ?? '');
                break;
              case List<Map<String, dynamic>>:
                value = List<Map<String, dynamic>>.from(typeChecker.firstAnnotationOfExact(f)?.getField(prop)?.toListValue() ?? []);
                break;
              case List<String>:
                value = List<String>.from(typeChecker.firstAnnotationOfExact(f)?.getField(prop)?.toListValue() ?? []);
                break;
              case Map<String, dynamic>:
                value = Map<String, dynamic>.from(typeChecker.firstAnnotationOfExact(f)?.getField(prop)?.toMapValue() ?? {});
                break;
            }
            if (prop == 'sequence' && field['sequence'] == null) {
              field['sequence'] = value;
            }
            props.add({
              'annotation': key,
              'property': prop,
              'type': $properties[prop],
              'value': value,
            });
          }
          field['annotation'].add({
            'name': key,
            'props': props,
          });
        }
      }
    } // assembled fields - now to handle sorting, followed by nested fields
    if (fields.any((f) => f['sequence'] != null)) {
      // sort fields by sequence even if one object's sequence is set
      // if sequence is null, set it to last number
      fields.sort((a, b) => (a['sequence'] == null ? fields.length : a['sequence']!).compareTo(b['sequence']!) as int);
    } else {
      // sort fields by name
      fields.sort((a, b) => a['name'].compareTo(b['name']) as int);
    }
    // generate a new sequence for each field
    for (int i = 0; i < fields.length; i++) {
      fields[i]['sequence'] = i;
    }
    // if any of the field['annotation'] have a 'FieldClass' annotation key set,
    // process the field's nested fields
    for (final field in fields) {
      buffer.writeln('${field.toString()}');
    }
  }
  */
}
