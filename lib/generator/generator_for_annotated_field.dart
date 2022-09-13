// ignore_for_file: lines_longer_than_80_chars, omit_local_variable_types, unnecessary_statements, unnecessary_this

import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:dart_style/dart_style.dart';

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
      // ignore: deprecated_member_use
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

  String buildValidator(List? validators, {bool functionOnly = false}) {
    // ignore: avoid_annotating_with_dynamic
    dynamic _quoteIfNeeded(dynamic value) {
      if (value?.runtimeType.toString() == 'String') {
        if (RegExp(r'^".*"$').hasMatch(value as String)) {
          return value;
        }
        return '\"$value\"';
      }
      return value;
    }

    final validatorList = <String>[];
    final List<String> customFunctions = [];

    if (validators == null || validators.isEmpty) {
      return '';
    }
    for (final validator in validators) {
      final args = validator[validator.keys.first];
      if (args is! Map) {
        throw Exception('Args is not a map: $args');
      }
      //  print('validator:' + validator.toString());
      final String? customFunction = args.remove('function') as String?;
      final argList = args.keys.map((key) => '$key: ${_quoteIfNeeded(args[key])}').join(',');
      if (validator.keys.first == 'custom') {
        if (customFunction == null || customFunction.trim().isEmpty || !customFunction.startsWith('custom(String? value')) {
          throw Exception('You must specify a function to validate the field.\n$customFunction');
        }
        try {
          customFunction.replaceAll('custom(String?', '_custom${customFunctions.length}(String?');
          customFunctions.add(DartFormatter().format('$customFunction'));
        } catch (e) {
          throw Exception('You must specify a valid function to validate the field.\n$customFunction');
        }
        for (int index = 0; index < customFunctions.length; index++) {
          validatorList.add('result = _custom${index}(value, $argList);');
        }
      } else {
        //  print('argList: $argList');
        validatorList.add('result = FormValidator.${validator.keys.first}(value, $argList);\n');
      }
      validatorList.add('''
        if (result != null) {
          errorList.add(result);
        }
      ''');
    }
    final result = '''
     ${functionOnly ? 'String? validator' : 'validator:'} (value) {
        final errorList = <String>[];
        String? result;
        ${customFunctions.join('\n')}
        ${validatorList.join('\n')}
        return errorList.isEmpty ? null : errorList.join('\\n');
      ${functionOnly ? '}' : '},'}
    ''';
    return result;
  }

  String dateRangePickerField(String elementName, String type, Map<String, dynamic> map, {String? parent}) {
    return '''
     void save(DateTime date, bool start) {
       final dates = _formData['$elementName']?.split(',') ?? [];
      dates[start ? 0 : 1] = date.toIso8601String().substring(0, 10);
      onSaved('$elementName', dates.join(','));
     }
      return SizedBox(
        height: 100,
        child: Column(
          children: [
          Row(children: const [Text('${map['label'] ?? elementName}')]),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 100,
                child: InputDatePickerFormField(
                  fieldLabelText: "${map['fieldLabelStartText'] ?? 'Start Date'}",
                  initialDate: DateTime.parse(initialStartDate),
                  firstDate: DateTime.parse(firstDate),
                  lastDate: DateTime.parse(lastDate),
                  onDateSaved: (date) => save(date, true),
                  onDateSubmitted: (date) => save(date, true),
                ),
              ), // Start Date field
              SizedBox(
                width: 100,
                child: InputDatePickerFormField(
                  fieldLabelText: "${map['fieldLabelEndText'] ?? 'End Date'}",
                  initialDate: DateTime.parse(initialEndDate),
                  firstDate: DateTime.parse(firstDate),
                  lastDate: DateTime.parse(lastDate),
                  onDateSaved: (date) => save(date, false),
                  onDateSubmitted: (date) => save(date, false),
                ), 
              ), // End Date field
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed:  () async {
                    final DateTimeRange? date = await showDateRangePicker(
                      context: context,
                      initialDateRange: DateTimeRange(
                          start: DateTime.parse(initialStartDate),
                          end: DateTime.parse(initialEndDate),
                        ),
                      firstDate: DateTime.parse(firstDate),
                      lastDate: DateTime.parse(lastDate),
                      helpText: '${map['helpText'] ?? 'Select ' + elementName[0].toUpperCase() + elementName.substring(1) + ' dates'}',
                      cancelText: '${map['cancelText'] ?? 'Cancel'}',
                      confirmText: '${map['confirmText'] ?? 'Confirm'}',
                      saveText: '${map['saveText'] ?? 'Done'}',
                      errorFormatText: "${map['errorFormat'] ?? 'Invalid date format'}",
                      errorInvalidText: "${map['errorInvalidText'] ?? 'Invalid date'}",
                      errorInvalidRangeText: "${map['errorInvalidRange'] ?? 'Invalid date range'}",
                      fieldStartHintText: "${map['fieldStartHintText'] ?? 'Start date'}",
                      fieldEndHintText: "${map['fieldEndHintText'] ?? 'End date'}",
                      fieldStartLabelText: "${map['fieldStartLabelText'] ?? '$elementName start'}",
                      fieldEndLabelText: "${map['fieldEndLabelText'] ?? '$elementName end'}",
                      textDirection: TextDirection.${map['textDirection'] ?? 'ltr'},
                      builder: (context, child) {
                        return Column(
                          children: [
                            SizedBox(height:  MediaQuery.of(context).size.height * 0.1),
                            ConstrainedBox(
                              constraints:  BoxConstraints(
                                maxWidth: 400.0,
                                maxHeight: MediaQuery.of(context).size.height * 0.8,
                              ),
                              child: child,
                            )  // ConstrainedBox
                          ], // Column
                        ); // Column
                      },
                    ); // showDateRangePicker
                    // user picked a date, probably
                    if (date != null) {
                      save(date.start, true);
                      save(date.end, false);
                    }
                  },
                ),
              ), // End of Date Range Picker
            ], // end Row children
          ),  // end Row
        ], // end Column children
      ), // end Column 
    ) // end SizedBox
''';
  }

  String dateTimePickerField(String elementName, String type, Map<String, dynamic> map, {String? parent}) {
    return '''
      SizedBox(
        height: 60,
        child: Row(
          children: [
            SizedBox(
              width: 100,
              child: InputDatePickerFormField(
                  autofocus: ${map['autofocus'] ?? false},
                  errorFormatText: "${map['errorFormatText'] ?? 'Invalid Date format'}",
                  errorInvalidText: "${map['errorInvalidText'] ?? 'The date is not valid. It is earlier than first date, later than last date, or doesn\'t pass the selectable day test.'}",
                  fieldHintText: "${map['fieldHintText'] ?? 'Select a date'}",
                  fieldLabelText:" ${map['fieldLabelText'] ?? '$elementName'}",
                  initialDate: DateTime.parse(
                    _formData['$elementName'] ?? initialDate
                  ),
                  firstDate: DateTime.parse(firstDate),
                  lastDate: DateTime.parse(lastDate),
                  onDateSaved: (DateTime date) {
                    _formData['$elementName'] = date.toIso8601String();
                    onSaved('$elementName', date.toIso8601String());
                  },
                  selectableDayPredicate: ${map['selectableDayPredicate'] ?? 'null'},
                ), // end InputDatePickerFormField
            ), // end SizedBox
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: IconButton(
                  onPressed: () async {
                    DateTime? date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.parse(
                    _formData['$elementName'] ?? initialDate
                  ),
                  firstDate: DateTime.parse(firstDate ),
                  lastDate: DateTime.parse(lastDate),
                      selectableDayPredicate: null,
                    );
                    if (date != null) {
                      _formData['$elementName'] = date.toIso8601String();
                      onSaved('$elementName', date.toIso8601String());
                    }
                  },
                  icon: const Icon(Icons.calendar_today)),
            ),
          ],
        ), // end Row
      )
''';
  }

  String radioField(String elementName, String elementType, Map<String, dynamic> map, {String? parent}) {
    String items;
    if (map['type'] == 'enum') {
      items = '''
       ${elementType}.values.map((value) {
              return ListTile(
                title: const Text(value.toString().split('.').last),
                leading: Radio(
                  value: value.toString().split('.').last,
                  groupValue: _selectedValue,
                  onChanged: (value) {
                    setState(() {
                      _selectedValue = value;
                    });
                    onSaved('${elementName}', value);
                  },
                
              );
            }).toList()
      ''';
    } else {
      items = '[' + (map['options'] as List<Map<String, dynamic>>).map((e) => '''ListTile(
                title: const Text("${e['label'] ?? e['value'].toString()}"),
                leading: Radio(
                  value: "${e['value'].toString()}",
                  groupValue: _selectedValue,
                  onChanged: (value) {
                    setState(() {
                      _selectedValue = value;
                    });
                    onSaved('${elementName}', value);
                  },
                ),
              )''').toList().join(',\n') + ']';
    }

    return ''' 
       var _selectedValue = _formData['${elementName}'];
      return Column(
        children: $items,
      )
      ''';
  }

  String choiceChipField(String elementName, String type, Map<String, dynamic> map, {String? parent}) {
    String items;
    // choicechip properties
    final properties = '''
      autofocus: ${map['autofocus'] ?? false},
      avatar: ${map['avatar']},
      ${map['avatarBorder'] != null ? 'avatarBorder:${map['avatarBorder']})' : ''}
      backgroundColor: ${map['backgroundColor']},
      ${map['clipBehinity'] != null ? 'clipBehinity:${map['clipBehinity']})' : ''}
      disabledColor: ${map['disabledColor']},
      elevation: ${map['elevation']},
      ${map['focusNode'] != null ? 'focusNode: FocusNode(),\n' : ''}
      labelPadding: ${map['labelPadding']},
      labelStyle: ${map['labelStyle']},
      materialTapTargetSize: ${map['materialTapTargetSize']},
      padding: ${map['padding']},
      pressElevation: ${map['pressElevation']},
      selectedColor: ${map['selectedColor']},
      selectedShadowColor: ${map['selectedShadowColor']},
      shape: ${map['shape']},
      side: ${map['side']},
      tooltip: ${map['tooltip']},
      visualDensity: ${map['visualDensity']},
''';
    if (map['type'] == 'enum') {
      items = '''
       ${type}.values.map((value) {
              return ChoiceChip(
                $properties
                label:  Text(value.toString().split('.').last),
                selected: _selectedValue == value.toString().split('.').last,
                onSelected: (bool selected) {
                  _selectedValue = value.toString().split('.').last;
                  onSaved('${elementName}', value);
                },
              );
            }).toList()
      ''';
    } else {
      items = '[' + (map['options'] as List<Map<String, dynamic>>).map((e) => '''ChoiceChip(
                $properties
                label:  Text("${e['label'] ?? e['value'].toString()}"),
                selected: _selectedValue == "${e['value'].toString()}",
                onSelected: (bool selected) {
                  _selectedValue = "${e['value'].toString()}";
                  onSaved('${elementName}', "${e['value'].toString()}");
                },
              )''').toList().join(',\n') + ']';
    }

    return ''' 
       var _selectedValue = _formData['${elementName}'];
      return Wrap(
        children: $items
      );
      ''';
  }

  String filterChipField(String elementName, String type, Map<String, dynamic> map, {String? parent}) {
    String items;
    // choicechip properties
    final properties = '''
      autofocus: ${map['autofocus'] ?? false},
      avatar: ${map['avatar']},
      ${map['avatarBorder'] != null ? 'avatarBorder:${map['avatarBorder']})' : ''}
      backgroundColor: ${map['backgroundColor']},
      ${map['clipBehinity'] != null ? 'clipBehinity:${map['clipBehinity']})' : ''}
      disabledColor: ${map['disabledColor']},
      elevation: ${map['elevation']},
      ${map['focusNode'] != null ? 'focusNode: FocusNode(),\n' : ''}
      labelPadding: ${map['labelPadding']},
      labelStyle: ${map['labelStyle']},
      materialTapTargetSize: ${map['materialTapTargetSize']},
      padding: ${map['padding']},
      pressElevation: ${map['pressElevation']},
      selectedColor: ${map['selectedColor']},
      selectedShadowColor: ${map['selectedShadowColor']},
      shape: ${map['shape']},
      side: ${map['side']},
      tooltip: ${map['tooltip']},
      visualDensity: ${map['visualDensity']},
''';
    if (map['type'] == 'enum') {
      items = '''
       ${type}.values.map((value) {
              return FilterChip(
                $properties
                label:  Text(value.toString().split('.').last),
                selected: _selectedValue == value.toString().split('.').last,
                onSelected: (bool selected) {gene
                  _selectedValue = value.toString().split('.').last;
                  onSaved('${elementName}', value);
                },
              );
            }).toList()
      ''';
    } else {
      items = '[' + (map['options'] as List<Map<String, dynamic>>).map((e) => '''FilterChip(
                $properties
                label:  Text("${e['label'] ?? e['value'].toString()}"),
                selected: _selectedValue == "${e['value'].toString()}",
                onSelected: (bool selected) {
                  _selectedValue = "${e['value'].toString()}";
                  onSaved('${elementName}', "${e['value'].toString()}");
                },
              )''').toList().join(',\n') + ']';
    }

    return ''' 
       var _selectedValue = _formData['${elementName}'];
      return Wrap(
        children: $items
      );
      ''';
  }

  String checkboxField(String elementName, String type, Map<String, dynamic> map, {String? parent}) {
    return '''
      return Checkbox(
        activeColor: ${map['activeColor']},
        autofocus: ${map['autofocus'] ?? 'false'},
        checkColor: ${map['checkColor']},
        fillColor: ${map['fillColor']},
        focusColor: ${map['focusColor']},
        ${map['focusNode'] != null ? 'focusNode: FocusNode(),' : ''}
        hoverColor: ${map['hoverColor']},
        ${map['materialTapTargetSize'] != null ? 'materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,' : ''}
        ${map['mouseCursor'] != null ? 'mouseCursor: MouseCursor.defer,,' : ''}
        overlayColor: ${map['overlayColor']},
        shape: ${map['shape']},
        side: ${map['side']},
        splashRadius: ${map['splashRadius']},
        tristate: ${map['tristate'] ?? 'false'},
        value: _formData['$elementName'] ?? false,
        onChanged: (bool? value) {
          onSaved('$elementName', value, parent: '${parent ?? ''}');
        },
      );
      ''';
  }

  String switchField(String elementName, String type, Map<String, dynamic> map, {String? parent}) {
    final initialValue = map['initialValue'] ?? 0.0;
    final autovalidateMode = map['autovalidateMode'] ?? 'AutovalidateMode.onUserInteraction';
    return '''
      SizedBox(
        height: 60,
        child: SwitchFormField(
          initialValue: $initialValue,
          autovalidateMode: $autovalidateMode,
          onSaved: (value) => onSaved('${elementName}', value, parent: '${parent ?? ''}'),
          ${buildValidator(map['validators'] as List<Map<String, dynamic>>?)},
          onChanged: (value) => onSaved('${elementName}', value, parent: '${parent ?? ''}'),
          label: '${map['label'] ?? elementName}',
          hint: '${map['hint'] ?? ''}',
          suffix: '${map['suffix'] ?? ''}',
          prefix: '${map['prefix'] ?? ''}',
          icon: '${map['icon'] ?? ''}',
          iconSize: ${map['iconSize'] ?? 24},
          iconColor: ${map['iconColor'] ?? 'Colors.grey[600]'},
          iconTooltip: '${map['iconTooltip'] ?? ''}',
          iconOnTap: () => ${map['iconOnTap'] ?? null},
          iconOnLongPress: () => ${map['iconOnLongPress'] ?? null},
          iconOnDoubleTap: () => ${map['iconOnDoubleTap'] ?? null},
          color: ${map['color'] ?? 'Colors.grey[300]'},
          colorActive: ${map['colorActive'] ?? 'Colors.grey[500]'},
          colorHover: ${map['colorHover'] ?? 'Colors.grey[400]'},
          colorDisabled: ${map['colorDisabled'] ?? 'Colors.grey[100]'},
          colorFocus: ${map['colorFocus'] ?? 'Colors.grey[200]'},
          colorError: ${map['colorError'] ?? 'Colors.red[300]'},
          enabled: ${map['enabled'] ?? true},
          hide: ${map['hide'] ?? false},
          readOnly: ${map['readOnly'] ?? false},
          autofocus: ${map['autofocus'] ?? false},


          

      )
''';
  }

  String rangeSliderField(String elementName, String elementType, Map<String, dynamic> map, {String? parent}) {
    return '''
      return SizedBox(
        height: ${map['suffix'] == null ? '60' : '80'},
        child: 
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ${map['suffix'] == null ? "const Text('${map['fieldLabel'] ?? elementName}')," : '''
                Expanded(flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 25),
                      const Text('${map['fieldLabel'] ?? elementName}'),
                      Text(__semanticFormatter(_currentRangeValues), style: const TextStyle(fontSize: 10)),
                    ],
                  ),
                ), //SizedBox
                '''}
                Expanded(
                  flex: 4,
                  child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    ${map['sliderThemeData']?['activeTrackColor'] != null ? 'activeTrackColor: ${map['sliderThemeData']?['activeTrackColor']},' : ''}
                    ${map['sliderThemeData']?['inactiveTrackColor'] != null ? 'inactiveTrackColor: ${map['sliderThemeData']?['inactiveTrackColor']},' : ''}
                    ${map['sliderThemeData']?['disabledActiveTrackColor'] != null ? 'disabledActiveTrackColor: ${map['sliderThemeData']?['disabledActiveTrackColor']},' : ''}
                    ${map['sliderThemeData']?['disabledInactiveTrackColor'] != null ? 'disabledInactiveTrackColor: ${map['sliderThemeData']?['disabledInactiveTrackColor']},' : ''}
                    ${map['sliderThemeData']?['activeTickMarkColor'] != null ? 'activeTickMarkColor: ${map['sliderThemeData']?['activeTickMarkColor']},' : ''}
                    ${map['sliderThemeData']?['inactiveTickMarkColor'] != null ? 'inactiveTickMarkColor: ${map['sliderThemeData']?['inactiveTickMarkColor']},' : ''}
                    ${map['sliderThemeData']?['disabledActiveTickMarkColor'] != null ? 'disabledActiveTickMarkColor: ${map['sliderThemeData']?['disabledActiveTickMarkColor']},' : ''}
                    ${map['sliderThemeData']?['disabledInactiveTickMarkColor'] != null ? 'disabledInactiveTickMarkColor: ${map['sliderThemeData']?['disabledInactiveTickMarkColor']},' : ''}
                    ${map['sliderThemeData']?['thumbColor'] != null ? 'thumbColor: ${map['sliderThemeData']?['thumbColor']},' : ''}
                    ${map['sliderThemeData']?['disabledThumbColor'] != null ? 'disabledThumbColor: ${map['sliderThemeData']?['disabledThumbColor']},' : ''}
                    ${map['sliderThemeData']?['overlayColor'] != null ? 'overlayColor: ${map['sliderThemeData']?['overlayColor']},' : ''}
                    ${map['sliderThemeData']?['valueIndicatorColor'] != null ? 'valueIndicatorColor: ${map['sliderThemeData']?['valueIndicatorColor']},' : ''}
                    ${map['sliderThemeData']?['overlayShape'] != null ? 'overlayShape: ${map['sliderThemeData']?['overlayShape']},' : ''}
                    ${map['sliderThemeData']?['tickMarkShape'] != null ? 'tickMarkShape: ${map['sliderThemeData']?['tickMarkShape']},' : ''}
                    ${map['sliderThemeData']?['thumbShape'] != null ? 'thumbShape: ${map['sliderThemeData']?['thumbShape']},' : ''}
                    ${map['sliderThemeData']?['trackShape'] != null ? 'trackShape: ${map['sliderThemeData']?['trackShape']},' : ''}
                    ${map['sliderThemeData']?['valueIndicatorShape'] != null ? 'valueIndicatorShape: ${map['sliderThemeData']?['valueIndicatorShape']},' : ''}
                    ${map['sliderThemeData']?['rangeTickMarkShape'] != null ? 'rangeTickMarkShape: ${map['sliderThemeData']?['rangeTickMarkShape']},' : ''}
                    ${map['sliderThemeData']?['rangeThumbShape'] != null ? 'rangeThumbShape: ${map['sliderThemeData']?['rangeThumbShape']},' : ''}
                    ${map['sliderThemeData']?['rangeTrackShape'] != null ? 'rangeTrackShape: ${map['sliderThemeData']?['rangeTrackShape']},' : ''}
                    ${map['sliderThemeData']?['rangeValueIndicatorShape'] != null ? 'rangeValueIndicatorShape: ${map['sliderThemeData']?['rangeValueIndicatorShape']},' : ''}
                    ${map['sliderThemeData']?['showValueIndicator'] != null ? 'showValueIndicator: ${map['sliderThemeData']?['showValueIndicator']},' : ''}
                    ${map['sliderThemeData']?['valueIndicatorTextStyle'] != null ? 'valueIndicatorTextStyle: ${map['sliderThemeData']?['valueIndicatorTextStyle']},' : ''}
                    ${map['sliderThemeData']?['minThumbSeparation'] != null ? 'minThumbSeparation: ${map['sliderThemeData']?['minThumbSeparation']},' : ''}
                    ${map['sliderThemeData']?['thumbSelector'] != null ? 'thumbSelector: ${map['sliderThemeData']?['thumbSelector']},' : ''}
                    ${map['sliderThemeData']?['mouseCursor'] != null ? 'mouseCursor: ${map['sliderThemeData']?['mouseCursor']},' : ''}
                  ),
                  child: RangeSlider(
                    activeColor: ${map['activeColor']},
                    divisions: ${map['divisions']},
                    inactiveColor: ${map['inactiveColor']},
                    labels: rangeLabels,
                    min: min,
                    max: max,
                    onChanged:(RangeValues values)   {
                      __semanticFormatter(values);
                    },
                    onChangeStart: ${map['onChangeStart']},
                    onChangeEnd: ${map['onChangeEnd']},
                    values: _currentRangeValues,
                  ),
                ), // SliderTheme
                ),
              ],
            ), // Row
           
      ) 
    ''';
  }

  String sliderField(String elementName, String elementType, Map<String, dynamic> map, {String? parent}) {
    final initialValue = map['value'] ?? map['min'] ?? 0.0;
    return '''
      SizedBox(
        height: 60,
        child: Row(
          children: [
            const Text('${map['label'] ?? elementName}'),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                ${map['sliderThemeData']?['activeTrackColor'] != null ? 'activeTrackColor: ${map['sliderThemeData']?['activeTrackColor']},' : ''}
                ${map['sliderThemeData']?['inactiveTrackColor'] != null ? 'inactiveTrackColor: ${map['sliderThemeData']?['inactiveTrackColor']},' : ''}
                ${map['sliderThemeData']?['disabledActiveTrackColor'] != null ? 'disabledActiveTrackColor: ${map['sliderThemeData']?['disabledActiveTrackColor']},' : ''}
                ${map['sliderThemeData']?['disabledInactiveTrackColor'] != null ? 'disabledInactiveTrackColor: ${map['sliderThemeData']?['disabledInactiveTrackColor']},' : ''}
                ${map['sliderThemeData']?['activeTickMarkColor'] != null ? 'activeTickMarkColor: ${map['sliderThemeData']?['activeTickMarkColor']},' : ''}
                ${map['sliderThemeData']?['inactiveTickMarkColor'] != null ? 'inactiveTickMarkColor: ${map['sliderThemeData']?['inactiveTickMarkColor']},' : ''}
                ${map['sliderThemeData']?['disabledActiveTickMarkColor'] != null ? 'disabledActiveTickMarkColor: ${map['sliderThemeData']?['disabledActiveTickMarkColor']},' : ''}
                ${map['sliderThemeData']?['disabledInactiveTickMarkColor'] != null ? 'disabledInactiveTickMarkColor: ${map['sliderThemeData']?['disabledInactiveTickMarkColor']},' : ''}
                ${map['sliderThemeData']?['thumbColor'] != null ? 'thumbColor: ${map['sliderThemeData']?['thumbColor']},' : ''}
                ${map['sliderThemeData']?['disabledThumbColor'] != null ? 'disabledThumbColor: ${map['sliderThemeData']?['disabledThumbColor']},' : ''}

              ),
              child: Slider(
                value: ${parent == null ? "_formData['$elementName'] ?? $initialValue" : "_formData['$parent']?['$elementName'] ?? $initialValue"},
                min: ${map['min']},
                max: ${map['max']},
                divisions: ${map['divisions']},
                label: semanticLabel,
                onChanged:(value) => onSaved('${elementName}', value, parent: '${parent ?? ''}'),
                activeColor: ${map['activeColor'] ?? 'Colors.blue'},
                inactiveColor: ${map['inactiveColor'] ?? 'Colors.grey'},
                thumbColor: ${map['thumbColor'] ?? 'Colors.amber'},
                mouseCursor: ${map['mouseCursor']},
                semanticFormatterCallback: (double value) => __semanticFormatter(value),
                onChangeStart: ${map['onChangeStart']},
                onChangeEnd: ${map['onChangeEnd']},
              ), // Slider
            ), // SliderTheme
            ${(map['suffix'] ?? false) == true ? '' : 'Text(semanticLabel),'}
          ],
        ), // Row
      ) // SizedBox
''';
  }

  String keyboardType(String type) {
    switch (type) {
      case 'number':
        return 'TextInputType.number';

      case 'multiline':
        return 'TextInputType.multiline';
      case 'phone':
        return 'TextInputType.phone';
      case 'emailAddress':
        return 'TextInputType.emailAddress';
      case 'url':
        return 'TextInputType.url';
      case 'datetime':
        return 'TextInputType.datetime';
      case 'visiblePassword':
        return 'TextInputType.visiblePassword';
      case 'name':
        return 'TextInputType.name';
      case 'streetAddress':
        return 'TextInputType.streetAddress';
      case 'none':
      case 'text':
      default:
        return 'TextInputType.text';
    }
  }

  String textFormField(String elementName, String elementType, Map<String, dynamic> map, {String? parent}) {
    final initialValue = map['initialValue'] ?? '';
    final autovalidateMode = map['autovalidateMode'] ?? 'AutovalidateMode.onUserInteraction';
    if (!map.containsKey('inputDecoration')) {
      map['inputDecoration'] = {};
    }
    return '''
   SizedBox(
     height: 60,
     child:
   TextFormField(
        autocorrect: ${map['autocorrect'] ?? true},
        autofillHints: ${map['autofillHints'] ?? null},
        autofocus: ${map['autoFocus'] ?? true},
        autovalidateMode: $autovalidateMode,
        buildCounter: ${map['buildCounter'] ?? null},
        ${map['cursorColor'] != null ? 'cursorColor: ${map['cursorColor']},' : ''}
        ${map['cursorHeight'] != null ? 'cursorHeight: ${map['cursorHeight']},' : ''}
        ${map['cursorRadius'] != null ? 'cursorRadius: ${map['cursorRadius']},' : ''}
        ${map['cursorWidth'] != null ? 'cursorWidth: ${map['cursorWidth']},' : ''}
        decoration: const InputDecoration(
          labelText: '${map['label'] ?? map['inputDecoration']?['labelText'] ?? elementName[0].toUpperCase() + elementName.substring(1)}',
          labelStyle: ${map['inputDecoration']?['labelStyle'] ?? 'TextStyle(fontSize: 16.0, color: Colors.black)'},
          floatingLabelBehavior: ${map['inputDecoration']?['floatingLabelBehavior'] ?? 'FloatingLabelBehavior.auto'},
          hintText: '${map['inputDecoration']?['hintText'] ?? ''}',
          helperText: '${map['inputDecoration']?['helperText'] ?? ''}',
          fillColor: ${map['inputDecoration']?['fillColor'] ?? 'Colors.white'},
          hoverColor: ${map['inputDecoration']?['hoverColor'] ?? 'Color.fromARGB(255, 161, 179, 239)'},
          filled:${map['inputDecoration']?['filled'] ?? 'true'},
          errorMaxLines: ${map['inputDecoration']?['errorMaxLines'] ?? '1'},
          errorStyle: ${map['inputDecoration']?['errorStyle'] ?? 'TextStyle( color: Colors.red, fontSize: 12.0 )'},
          border: ${map['inputDecoration']?['border'] ?? 'InputBorder.none'},
          enabledBorder: ${map['inputDecoration']?['enabledBorder'] ?? 'OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1.0))'},
          focusedBorder: ${map['inputDecoration']?['focusedBorder'] ?? 'OutlineInputBorder(borderSide: BorderSide(color: Colors.blue, width: 1.0))'},
          disabledBorder: ${map['inputDecoration']?['disabledBorder'] ?? 'OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))'},
          enabled: ${map['inputDecoration']?['enabled'] ?? 'true'},
          prefixIcon: ${map['inputDecoration']?['prefixIcon'] ?? 'null'},
          prefixText: ${map['inputDecoration']?['prefixText'] ?? 'null'},
          suffixIcon: ${map['inputDecoration']?['suffixIcon'] ?? 'null'},
          suffixText: ${map['inputDecoration']?['suffixText'] ?? 'null'},
          prefix: ${map['inputDecoration']?['prefix'] ?? 'null'},
          suffix: ${map['inputDecoration']?['suffix'] ?? 'null'},
          counterText: ${map['inputDecoration']?['counterText'] ?? 'null'},
          counterStyle: ${map['inputDecoration']?['counterStyle'] ?? 'null'},
          contentPadding: ${map['inputDecoration']?['contentPadding'] ?? 'EdgeInsets.all(5.0)'},
          isDense: ${map['inputDecoration']?['isDense'] ?? 'true'},
          alignLabelWithHint: ${map['inputDecoration']?['alignLabelWithHint'] ?? 'false'},
        ),
        enabled: ${map['enabled'] ?? 'true'},
        enableIMEPersonalizedLearning: ${map['enableIMEPersonalizedLearning'] ?? 'false'},
        enableInteractiveSelection: ${map['enableInteractiveSelection'] ?? 'true'},
        enableSuggestions: ${map['enableSuggestions'] ?? 'true'},
        expands: ${map['expands'] ?? 'true'},
        focusNode: ${map['focusNode'] ?? 'null'},
        initialValue: ${parent == null ? "_formData['$elementName'] ?? '$initialValue'" : "_formData['$parent']?['$elementName'] ?? '$initialValue'"},
        inputFormatters: ${map['inputFormatters'] ?? 'null'},
        keyboardAppearance: ${map['keyboardAppearance'] ?? 'Brightness.light'},
        keyboardType: ${keyboardType((map['keyboardType'] ?? map['type'] ?? 'none').toString())},
        maxLength: ${map['maxLength'] ?? 'null'},
        maxLengthEnforcement: ${map['maxLengthEnforcement'] ?? 'null'},
        maxLines: ${map['maxLines'] ?? 'null'},
        minLines: ${map['minLines'] ?? 'null'},
        mouseCursor: ${map['mouseCursor'] ?? 'null'},
        obscureText: ${map['obscureText'] ?? 'false'},
        obscuringCharacter: ${map['obscuringCharacter'] ?? '"•"'},
        onChanged:(value) => onSaved('${elementName}', value, parent: '${parent ?? ''}'),
        onSaved: (value) => onSaved('${elementName}', value, parent: '${parent ?? ''}'),
        scrollPadding: const EdgeInsets.all(5.0),
        ${buildValidator(map['validators'] as List?)}
      ), // TextFormField
    ) // SizedBox
    ''';
  }

  // ignore: avoid_annotating_with_dynamic
  String dropdownField(String elementName, String elementType, Map<String, dynamic> map, {String? parent}) {
    String items;
    String initialValue;

    if (map['type'] == 'enum') {
      items = '''
       ${elementType}.values.map((value) {
              maxWidth =  max(value.toString().split('.').last.length * 1.0, maxWidth);
              return DropdownMenuItem(
                value: value.toString().split('.').last,
                child: Text(value.toString().split('.').last),
              );
            }).toList()
      ''';
      initialValue = '${elementType}.values.first.toString().split(\'.\').last';
    } else {
      items = '[' +
          (map['options'] as List<Map<String, dynamic>>)
              .map((e) =>
                  'const DropdownMenuItem<String>(value: "${e['value'].toString().split('.').last}",' +
                  'child: const Text("${e['label'] ?? e['value'].toString().split('.').last}"))')
              .toList()
              .join(',\n') +
          ']';
      initialValue = (map['options'] as List<Map<String, dynamic>>).map((e) => "'e['value'].toString()'").toList().first;
    }

    return '''
    SizedBox(
      width:  200, // min(width, maxWidth * 10),
      child:DropdownButtonFormField(
          value: ${parent == null ? "_formData['$elementName'] ?? $initialValue" : "_formData['$parent']['$elementName'] ?? $initialValue"},
   
          decoration: const InputDecoration(
            labelText: '${map['label'] ?? elementName[0].toUpperCase() + elementName.substring(1)}',
            hintText: '${map['hint'] ?? ''}',
            helperText: '${map['helper'] ?? ''}',
          ),
          items: $items,
          onChanged:  (value) => onSaved('${elementName}', value, parent: '${parent ?? ''}'),
        ), // DropdownButtonFormField
      ) // SizedBox
    ''';
  } // dropdownField

  // ignore: avoid_annotating_with_dynamic
  String dropdownHideUnderlineField(String elementName, String elementType, Map<String, dynamic> map, {String? parent}) {
    String items;
    String initialValue;
    if (map['type'] == 'enum') {
      items = '''
       ${elementType}.values.map((value) {
              maxWidth =  max(value.toString().split('.').last.length * 1.0, maxWidth);
              return DropdownMenuItem(
                value: value.toString().split('.').last,
                child: Text(value.toString().split('.').last),
              );
            }).toList()
      ''';
      initialValue = '${elementType}.values.first.toString().split(\'.\').last';
    } else {
      items = '[' +
          (map['options'] as List<Map<String, dynamic>>)
              .map((e) =>
                  'const DropdownMenuItem<String>(value: "${e['value'].toString().split('.').last}",' +
                  'child: const Text("${e['label'] ?? e['value'].toString().split('.').last}"))')
              .toList()
              .join(',\n') +
          ']';
      initialValue = (map['options'] as List<Map<String, dynamic>>).map((e) => "'e['value'].toString()'").toList().first;
    }

    return '''
    SizedBox(
      width: min(width, maxWidth * 10),
      child: DropdownButtonHideUnderlineFormField(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton(
            value: ${parent == null ? "_formData['$elementName'] ?? $initialValue" : "_formData['$parent']['$elementName'] ?? $initialValue"},
            items: $items,
            onChanged:  (value) => onSaved('${elementName}', value, parent: '${parent ?? ''}'),
            ${buildValidator(map['validators'] as List?)}
          ), // DropdownButton
        ), // ButtonTheme
      ), // DropdownButtonHideUnderlineFormField
    ) // SizedBox
    ''';
  }

  String generateForAnnotatedField(FieldElement field, ConstantReader annotation, BuildStep buildStep);
}

extension on DateTime {
  // ignore: unused_element
  String get dateTimeFormat => '${this.day}-${this.month}-${this.year} ${this.hour}:${this.minute}:${this.second}';
  // ignore: unused_element
  String get DMY => '${this.day}-${this.month}-${this.year}';
  // ignore: unused_element
  String get YMD => '${this.year}-${this.month}-${this.day}';
  // ignore: unused_element
  String get MDY => '${this.month}-${this.day}-${this.year}';
}
