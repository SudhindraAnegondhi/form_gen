// ignore_for_file: lines_longer_than_80_chars, omit_local_variable_types
import 'package:build/src/builder/build_step.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';
import 'package:flutter_form_annotations/flutter_form_annotations.dart';
import 'model_visitor.dart';

class GenerateForm extends GeneratorForAnnotation<GenerateForm> {
  @override
  String generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) {
    print('GenerateForm');
    final buffer = StringBuffer();
    final ModelVisitor visitor = ModelVisitor();
    element.visitChildren(visitor);
    print(element.toString());
    final className = '${visitor.className}Screen'; // EX: 'ModelScreen' for 'Model'.
    final model = visitor.className[0].toLowerCase() + visitor.className.substring(1);
    print(model);
    /*
    final List<Map<String, dynamic>> fields = getModelFields(element as ClassElement, annotation);
    
    generateHeader(buffer, className, visitor.className, model, fields);
    print(buffer.toString());
    generateFields(buffer, fields);
    generateFooter(buffer, className);
    */
    return buffer.toString();
  }

  void generateHeader(StringBuffer buffer, String className, String modelClassName, String model, List<Map<String, dynamic>> fields) {
    buffer.writeln('''
    // ignore_for_file: unnecessary_const, prefer_const_literals_to_create_immutables, prefer_const_constructors
   
    class $className extends StatefulWidget {
      const $className({ Key? key,   this.$model, required this.add, this.showAppBar = false, this.appBar,
      this.size, this.textStyle, this.color, this.textColor, this.headlineStyle, 
      this.backgroundColor, this.backgroundImage, this.backgroundImageFit,
      }) : super(key: key);
      final ${modelClassName}? $model;
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
        if(widget.$model != null) {
          modelMap = widget.$model!.toJson();
        } else {
          initModel();
        }
      
      }

  
     void initModel() {    
  ''');

    for (final field in fields) {
      if (field['annotation'] == 'FIeldClass') {
        final name = field['name'];
        for (final prop in field['meta']['properties']) {
          buffer.writeln('modelMap[\'$name}\'][\'${prop['name']}\']; = null;');
        }
      } else {
        buffer.writeln('modelMap[\'${field['name']}\'] = null;');
      }
    }
    buffer.writeln('}');

    buffer.writeln('''
  double min(double a, double b) => a < b ? a : b;
  
  @override
  Widget build(BuildContext context) {
    return  Scaffold( 
      appBar: widget.showAppBar ? widget.appBar : null,
    body: Center(child:
    Container(
      width: widget.size?.width ?? MediaQuery.of(context).size.width,
      height: widget.size?.height ?? min(MediaQuery.of(context).size.height - (widget.showAppBar ? AppBar().preferredSize.height: 0), ${fields.length}  * 85),
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
            Text(widget.add ? 'Add ${className}' : 'Edit ${className}',
            style: widget.headlineStyle ?? Theme.of(context).textTheme.headline6,
            ),
          ''');
  } // End header

  dynamic getValue(String annotation, FieldElement f, String arg) {
    final typeChecker = TypeChecker.fromRuntime(annotations[annotation]!);
    final argType = arg.split(' ').first.replaceAll('?', '');
    final argName = arg.split(' ').last;
    final argvalue = typeChecker.firstAnnotationOf(f)?.getField('$argName')?.toStringValue();
    if (argvalue != null) {
      return stringToTypeValue(argType, argvalue);
    }
  }

  List<Map<String, dynamic>> getModelFields(ClassElement element, ConstantReader annotation) {
    final List<Map<String, dynamic>> fields = [];
    for (final f in element.fields) {
      final Map<String, dynamic> field = <String, dynamic>{
        'name': f.name,
        'type': f.type.toString(),
      };

      final meta = f.metadata.toString();
      final annotation = meta.split(' ').first.substring(1); // skip the @
      if (annotations[annotation] == null) {
        // ignore unknown annotations
        continue;
      }
      field['annotation'] = annotation;
      final constructor = meta.split(' ').last;
      final args = constructor.split('(').sublist(1).join().split(')').first.split(',');
      for (final arg in args) {
        field['meta'][arg.split(' ').last] = getValue(annotation, f, arg);
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
      if (field['annotation'] == 'FieldClass') {
        field['nestedFields'] = decodeMeta(field); // list from properites  of FieldClass
      }
    }
    return fields;
  }

  List<Map<String, dynamic>> decodeMeta(Map<String, dynamic> field) {
    final List<Map<String, dynamic>> nestedfields = [];
    double sequence = field['sequence'] as double;
    for (final key in field['meta']['properties'].keys) {
      sequence = sequence + 0.001;
      final Map<String, dynamic> nestedfield = <String, dynamic>{
        'name': key,
        'type': field['meta']['properties'][key]['type'],
        'annotation': field['meta']['properties'][key]['annotation'],
        'sequence': sequence,
      };
      nestedfields.add(nestedfield);
    }
    return nestedfields;
  }

  void generateFields(StringBuffer buffer, List<Map<String, dynamic>> fields) {
    for (final field in fields) {
      if (field['annotation'] == 'FieldClass') {
        generateFields(buffer, field['nestedFields']! as List<Map<String, dynamic>>);
      } else {
        generateField(buffer, field);
      }
    }
  }

  void generateField(StringBuffer buffer, Map<String, dynamic> field) {
    switch (field['annotation']) {
      case 'FieldText':
        buffer.write('''
        FormBuilderTextField(
            name: '${field['name'] as String}',
            enabled: ${field['meta']['enabled'] ?? true},
            keyboardType: ${getKeyboardType(field['type'] as String)},
            decoration: const InputDecoration(
              labelText: '${field['meta']['label'] ?? camelCaseToTitleCase(field['name'] as String)}',
            ),
            initialValue: modelMap['${field['name'] as String}'] ?? '${field['meta']['initialValue']}',
           
            onChanged: (value) {
              setState(() {
                modelMap['${field['name'] as String}'] = ${valueToType('${field['type'] as String}')};
              });
            },
          ),\n
        ''');
        break;
      case 'FieldDropdown':
        if (field['meta']['options'] != null) {
          final items = (field['meta']['options'] as List<dynamic>)
                  .map((e) =>
                      'const DropdownMenuItem<String>(value: "${e['value'].toString().split('.').last}",' +
                      'child: const Text("${e['label'] ?? e['value'].toString().split('.').last}"))')
                  .toList()
                  .join(',\n') +
              ']';
          buffer.write('''
          FormBuilderDropdown(
            name: '${field['name'] as String}',
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required( errorText: ${field['meta']['label'] ?? camelCaseToTitleCase(field['name'] as String)} is required'), 
            ]),
            onChanged: (value) {
              setState(() {
                modelMap['${field['name'] as String}'] = ${valueToType('${field['type'] as String}')}
              });
            },
            initialValue: modelMap['${field['name'] as String}'].split('.').last},
            decoration: const InputDecoration(
              labelText: '${field['meta']['label'] ?? camelCaseToTitleCase(field['name'] as String)}',
            ),
            items:  $items,
          ),
          ''');
        }
        break;
      case 'FieldFiterChip':
        //generateFieldFilterChip(buffer, f);
        break;
      case 'FieldChoiceChip':
        //generateFieldChoiceChip(buffer, f);
        break;
      case 'FieldCheckbox':
        //generateFieldCheckbox(buffer, f);
        break;
      case 'FieldDateTimePicker':
        //generateFieldDateTimePicker(buffer, f);
        break;
      case 'FieldDateRangePicker':
        //generateFieldDateRangePicker(buffer, f);
        break;
      case 'FieldRangeSlider':
        //generateFieldRangeSlider(buffer, f);
        break;
      case 'FieldRadio':
        //generateFieldRadio(buffer, f);
        break;
      case 'FieldSwitch':
        //getModelFieldswitch(buffer, f);
        break;
      case 'FieldRadioGroup':
        //generateFieldRadioGroup(buffer, f);
        break;
    }
  }

  void generateFooter(StringBuffer buffer, String className) {
    buffer.writeln('''
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
                      Navigator.of(context).pop(${className}.fromJson(modelMap));
                      }  
                  } : null,
                ),
              ],
            ),
          ),
    ''');

    buffer.write(''' 
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
  }
}
