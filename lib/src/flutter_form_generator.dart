// ignore_for_file: lines_longer_than_80_chars, omit_local_variable_types

import 'package:build/src/builder/build_step.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';
import 'package:flutter_form_annotations/flutter_form_annotations.dart';

import 'generator_for_annotated_field.dart';
import 'model_visitor.dart';
import 'helpers.dart';

class FlutterFormGenerator extends GeneratorForAnnotation<FormGenerator> {
  @override
  String generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) {
    final buffer = StringBuffer();
    final properties = Helpers.getClassProperties(FormBuilder);
    final classMap = Helpers.annotationToJson<FormBuilder>(element, properties);

    final bool needScaffold = (classMap['needScaffold'] ?? true) as bool;
    print('Need scaffold $needScaffold');
    final bool allowNullOrEmpty = (classMap['allowNullOrEmpty'] ?? true) as bool;
    final ModelVisitor visitor = ModelVisitor();
    element.visitChildren(visitor);
    final className = '${visitor.className}Form'; // EX: 'ModelForm' for 'Model'.
    final fields = '{' +
        visitor.fields.keys
            .map((key) {
              final field = visitor.fields[key] as String;
              final type = visitor.fields[field]?.toString() ?? 'Unknown';

              if (type == 'Unknown' && Helpers.classExists(field)) {
                final properties = Helpers.getClassNameProperties(field);
                return '"$key": {\n' + properties.keys.map((e) => '"$e": null').join(',\n') + '}\n';
              }
              return "'$key': null";
            })
            .toList()
            .join(',\n') +
        '}';
    final formFieldList = visitor.fields.keys.map((key) => '${key}FormField(context, _formData, onSaved:onSaved)').toList().join(',\n');
    _classHeader(buffer, className, visitor.className);
    _stateClassHeader(buffer, className, allowNullOrEmpty, fields);
    return buffer.toString();
  }
}

class FieldBuilder extends GeneratorForAnnotatedField<FieldBuilder> {
  @override
  String generateForAnnotatedField(FieldElement element, ConstantReader annotation, BuildStep buildstep) {
    final buffer = StringBuffer();
    final properties = Helpers.getClassProperties(FieldBuilder);
    final map = Helpers.annotationToJson<FieldText>(element, properties);
    buffer.write('''
      Widget ${element.name}FormField(BuildContext context, Map<String, dynamic> _formData, {required Function onSaved}) {
        return ${textField(element.name, element.type.toString(), map)};
      }
    ''');

    return buffer.toString();
  }
}

void _classHeader(StringBuffer buffer, String className, String modelName) {
  buffer.writeln('class $className extends StatefulWidget {');
  buffer.write('''
      // ignore_for_file: unused_element, unnecessary_this
        const $className({Key? key, this.model, this.onSubmit, this.allowNullOrEmpty = false, this.needScaffold= true,   this.showAppBar = true, this.appBar,
      this.size, this.textStyle, this.color, this.textColor, this.headlineStyle, 
      this.backgroundColor, this.backgroundImage, this.backgroundImageFit,}) : super(key: key);
        final ${modelName}? model;
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
}

void _stateClassHeader(StringBuffer buffer, String className, bool allowNullOrEmpty, String fields) {
   buffer.write('''
      class _${className}State extends State<$className> {
        final _formKey = GlobalKey<FormState>();
        final _formData = <String, dynamic>{};
        final bool _allowNullOrEmpty = $allowNullOrEmpty;
        @override
        void initState() {
          super.initState();
          _formData.addAll(widget.model?.toJson() ?? $fields );
        }

        double min(double a, double b) => a < b ? a : b;
    ''');
}
