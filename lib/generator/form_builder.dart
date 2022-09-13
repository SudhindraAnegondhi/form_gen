// ignore_for_file: lines_longer_than_80_chars, omit_local_variable_types, non_constant_identifier_names, unnecessary_this, unused_element

import 'package:build/src/builder/build_step.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';
import 'package:form_gen/annotations/form_annotations.dart';
import 'model_visitor.dart';

import 'helpers.dart';

class FormBuilderGenerator extends GeneratorForAnnotation<FormBuilder> {
  @override
  String generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) {
    final buffer = StringBuffer();
    final properties = Helpers.getClassProperties(FormBuilder);
    final classMap = Helpers.annotationToJson<FormBuilder>(element, properties);
    final bool needScaffold = (classMap['needScaffold'] ?? true) as bool;
    final bool allowNullOrEmpty = (classMap['allowNullOrEmpty'] ?? true) as bool;
    final ModelVisitor visitor = ModelVisitor();
    element.visitChildren(visitor);
    final className = '${visitor.className}Form'; // EX: 'ModelForm' for 'Model'.
    final fields = '{' + visitor.fields.keys.map((key) => "'$key': null").toList().join(',\n') + '}';
    final formFieldList = visitor.fields.keys.map((key) => '${key}FormField(context, _formData, onSaved:onSaved,width: _width)').toList().join(',\n');

    buffer.writeln('class $className extends StatefulWidget {');
    buffer.write('''
      // ignore_for_file: unused_element, unnecessary_this, non_constant_identifier_names
      
        const $className({Key? key, this.model, this.onSubmit, this.allowNullOrEmpty = false, this.needScaffold= true,   this.showAppBar = true, this.appBar,
      this.size, this.textStyle, this.color, this.textColor, this.headlineStyle, 
      this.backgroundColor, this.backgroundImage, this.backgroundImageFit,}) : super(key: key);
        final ${visitor.className}? model;
        final Function? onSubmit;
        final AppBar? appBar;
        final bool showAppBar;
        final bool allowNullOrEmpty;
        final bool needScaffold;
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
        final bool _allowNullOrEmpty = $allowNullOrEmpty;
        double _width = 600;
        @override
        void initState() {
          super.initState();
         
          _formData.addAll(widget.model?.toJson() ?? $fields );
        }
        void setWidth() {
          _width = min(widget.size?.width ?? MediaQuery.of(context).size.width, 600);
        }
      @override
        void didChangeDependencies() {
          setWidth();
          super.didChangeDependencies();
        }
      
    ''');

    buffer.write('''
        void onSaved(String key, dynamic value, {String? parent}) {
          if(mounted){
            setState(() {
              if (parent != null && parent.isNotEmpty) {
                _formData[parent][key] = value;
              } else {
                _formData[key] = value;
              }
            });
          }
        }

        Future<void> alert(String title, List<String> messages, {String? okButtonText}) async {
          await showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                title:  Text(title, style: const TextStyle(fontSize: 20)),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: messages.map((String message) {
                      return Text(message);
                    }).toList(),
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child:  Text(okButtonText ?? 'OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }

        void onSubmit()  async {
          if (_formKey.currentState?.validate() ?? false) {
            _formKey.currentState?.save();
            if(!_allowNullOrEmpty && _formData.keys.toList().any((e) => _formData[e] == null || _formData[e].toString().isEmpty))  {
               await alert('Error', ['Please fill in all the required fields.']);
               return;
            }
           Navigator.of(context).pop(${visitor.className}.fromJson(_formData));
          }
        }

        @override
        Widget build(BuildContext context) {
          return 
          ''');
    if (needScaffold) {
      buffer.write('''
          Scaffold(
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
          body: 
          ''');
    }
    buffer.write('''
        SizedBox(
        height: widget.size?.height ??
            min(MediaQuery.of(context).size.height - (widget.showAppBar ? AppBar().preferredSize.height : 0), _formData.keys.toList().length * 85),
        width: widget.size?.width ?? MediaQuery.of(context).size.width,
        child:
           Center( 
              child: 
                Container(
                  width: min(widget.size?.width ?? MediaQuery.of(context).size.width, 600),
                  height: widget.size?.height ?? min(MediaQuery.of(context).size.height - (widget.showAppBar ? AppBar().preferredSize.height: 0), _formData.keys.toList().length  * 85),
                  color: widget.backgroundColor ?? Colors.white,
                  child: 
                        Card(  
                          elevation: 15,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          shadowColor: Colors.black,
                          child:  Padding(  
                            padding: const EdgeInsets.all(8.0),
                            child:  Form(
                              key: _formKey,
                              child: 
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  const SizedBox(height: 15),
                                  Expanded( 
                                    child: ListView(
                                      shrinkWrap: true,
                                      children: <Widget>[
                                        const SizedBox(height: 15),
                                        $formFieldList
                                      ],
                                    ),
                                  ),
                                  Padding( 
                                    padding: const EdgeInsets.all(8.0),
                                    child: 
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
                                            onPressed: _formKey.currentState?.validate() ?? false  ?
                                                () {
                                                  if (_formKey.currentState?.validate() ?? false) {
                                                    _formKey.currentState?.save();
                                                    Navigator.of(context).pop(${visitor.className}.fromJson(_formData));
                                                    }  
                                                } : null,
                                          ), 
                                        ], 
                                      ),
                                  ), 
                                ], 
                              ), 
                            ), // Form
                          ), // Padding
                        ), // Card
                  ), // Container
              ), // 0. Center
            ), // SizedBox
          ); // Scaffold
        } // build
      } // _${className}State

    extension on String {
        bool get isEmail => RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+').hasMatch(this);
        bool get isPhone => RegExp(r'^[0-9]{10}').hasMatch(this);
        bool get isNumeric => RegExp(r'^[0-9.]*\$').hasMatch(this);
        bool get isName => RegExp(r'^[a-zA-Z.]*\$').hasMatch(this);
        bool get isDate => RegExp(r'^[0-9]{4}-[0-9]{2}-[0-9]{2}\$').hasMatch(this);
        bool get isDateTime => RegExp(r'^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}\$').hasMatch(this);
        bool get isTime => RegExp(r'^[0-9]{2}:[0-9]{2}:[0-9]{2}\$').hasMatch(this);
        bool get isDateTimeRange => RegExp(r'^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}-[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}\$').hasMatch(this);
        bool get isDateRange => RegExp(r'^[0-9]{4}-[0-9]{2}-[0-9]{2}-[0-9]{4}-[0-9]{2}-[0-9]{2}\$').hasMatch(this);
        String get capitalize => '\${this[0].toUpperCase()}\${this.substring(1)}';
        String get capitalizeWords => this.split(' ').map((word) => word.capitalize).join(' ');
        String camelCase() => this.split(' ').map((word) => word.capitalize).join('');
        String get camelCaseToTitleCase => this.split(' ').map((word) => word.capitalize).join(' ');
    }

    extension on DateTime {
      String get dateTimeFormat =>  "\${this.day}-\${this.month}-\${this.year} \${this.hour}:\${this.minute}:\${this.second}";
      String get DMY =>  '\${this.day}-\${this.month}-\${this.year}';
      String get MDY =>  '\${this.month}-\${this.day}-\${this.year}';
      String get string => '\${this.year}-\${this.month}-\${this.day}';
    }
      
  ''');
    return buffer.toString();
  }
}
