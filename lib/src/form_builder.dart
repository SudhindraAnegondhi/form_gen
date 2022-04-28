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
                final properties = GeneratorForAnnotatedField.getClassNameProperties(field);
                return '"$key": {\n' + properties.keys.map((e) => '"$e": null').join(',\n') + '}\n';
              }
              return "'$key': null";
            })
            .toList()
            .join(',\n') +
        '}';
    final formFieldList = visitor.fields.keys.map((key) => '${key}FormField(context, _formData, onSaved:onSaved)').toList().join(',\n');

    buffer.writeln('class $className extends StatefulWidget {');
    buffer.write('''
      // ignore_for_file: unused_element, unnecessary_this
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
                  child:  Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            flex: 9,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  $formFieldList
                                ],
                              ), // Column
                            ), // SingleChildScrollView
                         ), // Expanded
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
                  ), // Padding
                ), // Card
              ), // Container
            ), // Center
          );
        }
      }
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
        // ignore: unnecessary_this, prefer_single_quotes
        String get capitalize => "\${this[0].toUpperCase()}\${this.substring(1)}";
        // ignore: unnecessary_this
        String get capitalizeWords => this.split(' ').map((word) => word.capitalize).join(' ');
    }
      
  ''');
    return buffer.toString();
  }
}
