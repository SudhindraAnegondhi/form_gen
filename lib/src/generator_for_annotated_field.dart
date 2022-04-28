// ignore_for_file: lines_longer_than_80_chars, omit_local_variable_types, unnecessary_statements
import 'dart:mirrors';
import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import '_validators.dart';

const _dartTypes = ['int', 'double', 'DateTime', 'String', 'bool', 'List', 'Map'];

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

  static bool classExists(String className) {
    try {
      if (_dartTypes.contains(className)) {
        return false;
      }
      final DeclarationMirror? cm = currentMirrorSystem().isolate.rootLibrary.declarations[Symbol(className)];
      if (cm != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Map<String, String> getClassNameProperties(String className) {
    final Map<String, String> properties = <String, String>{};
    final DeclarationMirror? cm = currentMirrorSystem().isolate.rootLibrary.declarations[Symbol(className)];
    if (cm is ClassMirror) {
      for (final DeclarationMirror dm in cm.declarations.values) {
        if (dm is VariableMirror) {
          final String name = MirrorSystem.getName(dm.simpleName);
          final String type = MirrorSystem.getName(dm.type.simpleName);
          properties[name] = type;
        }
      }
    }
    return properties;
  }
  

  Map<String, String> getClassProperties(Type type) {
    final Map<String, String> properties = {};
    for (final v in reflectClass(type).declarations.values) {
      final _name = MirrorSystem.getName(v.simpleName);
      if (v is VariableMirror) {
        properties[_name] = v.type.reflectedType.toString();
      }
    }
    return properties;
  }

  dynamic __decodeDartObject(DartObject? dartObject) {
    if (dartObject == null || dartObject.type == null) {
      return null;
    }
    if (dartObject.type?.toString() == 'String') {
      return dartObject.toStringValue();
    } else if (dartObject.type!.toString() == 'int') {
      return dartObject.toIntValue();
    } else if (dartObject.type!.toString() == 'double') {
      return dartObject.toDoubleValue();
    } else if (dartObject.type!.toString() == 'bool') {
      return dartObject.toBoolValue();
    } else if (dartObject.type!.toString().startsWith('List')) {
      final List<dynamic> list = [];
      for (final DartObject item in dartObject.toListValue() ?? []) {
        list.add(__decodeDartObject(item));
      }
      return list;
    } else if (dartObject.type!.toString().startsWith('Map')) {
      final Map<String, dynamic> map = {};
      for (final key in dartObject.toMapValue()!.keys.toList()) {
        map[key?.toStringValue() ?? ' '] = __decodeDartObject(dartObject.toMapValue()?[key]);
      }
      return map;
    } else {
      return null;
    }
  }

  Map<String, dynamic> annotationToJson(Element element, Map<String, dynamic> properties) {
    final json = <String, dynamic>{};
    final DartObject? annotation = getAnnotation(element);
    if (annotation != null) {
      for (final String property in properties.keys) {
       // final DartObject? value = annotation.getField(property);
        json['$property'] = __decodeDartObject(annotation.getField(property));
      }
    }
    return json;
  }

  /// Validators can be specified in two ways.
  /// 1. Using any of the documented validator types.
  ///    This is done by specifying the validator type in the annotation, followed by an
  ///    optional list of parameters.
  /// 2. Using a custom validator function. The function must be specified as
  ///    {"function": "myCustomValidatorFunction"}
  ///    The function must accept a single parameter, which is the value to validate.\
  ///    the function must return a null if the value is valid, or a string describing the error.
  ///
  // ignore: avoid_annotating_with_dynamic
  String composeValidators(dynamic validators) {
    if (validators is! List) {
      throw Exception('Validators must be a list, but got ${validators.runtimeType} : $validators');
    }
    final _validators = validators.map((e) {
      String? func;

      if ((e?['type'] ?? 'custom') == 'custom') {
        func = e?['function'] as String?;
      } else {
        for (final key in validatorsMap.keys) {
          if (key == 'required') {
            func = validatorsMap[key];
            break;
          } else if (key == e?['type'] as String) {
            func = key;
          }
        }
        if (func == null) {
          throw Exception('Unknown validator type: ${e?['type']}');
        }
      }

      if (['min', 'max', 'minLength', 'maxLength', 'range'].contains(e?['type'])) {
        return '''result = ${func}(${e?['length']});
         if (result != null) {
           const  message = '${e?['message']}';
            errors.add(message.isEmpty ? result : '${e?['message'] ?? ''}');
          }
        ''';
      } else {
        return '''
          result = $func;
          if (result != null) {
            const message = '${e?['message']}';
            errors.add(message.isEmpty ? result : '${e?['message'] ?? ''}');
          }
      ''';
      }
    }).toList();
    if (_validators.isEmpty) {
      return '';
    }
    return ''' 
    validator: (value) {
      List<String> errors =[];
      String? result;
      ${_validators.join('\n')}
      return errors.isEmpty ? null : errors.join('\\n');
    }
    ''';
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
        ${composeValidators(map['validators'] ?? [])}
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
