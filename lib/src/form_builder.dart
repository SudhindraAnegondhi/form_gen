// ignore_for_file: lines_longer_than_80_chars, omit_local_variable_types



import 'package:build/src/builder/build_step.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';
import 'package:flutter_form_annotations/flutter_form_annotations.dart';
import 'model_visitor.dart';

class FormBuilderGenerator extends GeneratorForAnnotation<FormBuilder> {
  @override
  String generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) {
    print('I Was Called');
    final buffer = StringBuffer();
  
    final ModelVisitor visitor = ModelVisitor();
    element.visitChildren(visitor);
    final className = '${visitor.className}Form'; // EX: 'ModelForm' for 'Model'.
    final fields = '{' + visitor.fields.keys.map((key) => "'$key': null").toList().join(',\n') + '}';
    print('ANN: ' + annotation.toString());

    final String formFieldList = visitor.fields.keys.map((key) => '${key}FormField(context, _formData, onSaved: (value) => _formData[\'$key\'])').toList().join(',\n');

    buffer.writeln('class $className extends StatefulWidget {');
    buffer.write('''
        const $className({Key? key, this.model, this.onSubmit}) : super(key: key);
        final ${visitor.className}? model;
        final Function? onSubmit;
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

        @override
        Widget build(BuildContext context) {
          return Form(
            key: _formKey,
            child: Column(
              children: [
                $formFieldList
              ],
            ),
          );
        }
      }


  ''');
    return buffer.toString();
  }
}

