// ignore_for_file: lines_longer_than_80_chars, omit_local_variable_types, unnecessary_statements, unnecessary_this

import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'helpers.dart';

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

  String dateRangePickerField(String elementName, String type, Map<String, dynamic> map, {String? parent}) {
    return '''
      return SizedBox(
        height: 80,
        child: Column(
          children: <Widget>[
            Row(children: const [Text('${map['label'] ?? elementName}')]),
          Row(
         mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 100,
              child: InputDatePickerFormField(
                fieldLabelText:"${map['fieldLabelStartText'] ?? 'Start Date'}",
                initialDate: DateTime.parse("${map['initialDate']?.split(',').last ?? DateTime.now().add(const Duration(days: 25 * 365)).toIso8601String()}"),
                firstDate: DateTime.parse("${map['firstDate'] ?? DateTime.now().subtract(const Duration(days: 25 * 365)).toIso8601String()}"),
                lastDate: DateTime.parse("${map['lastDate'] ?? DateTime.now().add(const Duration(days: 25 * 365)).toIso8601String()}"),
                onDateSaved: (date) {
                  final dates = _formData['journeyDates']?.split(',') ?? [];
                  dates[0] = date.string;
                  onSaved('journeyDates', dates.join(','));
                },
                onDateSubmitted: (date) {
                  final dates = _formData['$elementName']?.split(',') ?? [];
                  dates[0] = date.string;
                  onSaved('$elementName', dates.join(','));
                },
              ),
            ), // InputDatePickerFormField
            SizedBox(
              width: 100,
              child: InputDatePickerFormField(
                fieldLabelText: "${map['fieldLabelEndText'] ?? 'End Date'}",
                initialDate: DateTime.parse("${map['initialDate']?.split(',').last ?? DateTime.now().subtract(const Duration(days: 25 * 365)).toIso8601String()}"),
                firstDate: DateTime.parse("${map['firstDate'] ?? DateTime.now().subtract(const Duration(days: 25 * 365)).toIso8601String()}"),
                lastDate: DateTime.parse("${map['lastDate'] ?? DateTime.now().add(const Duration(days: 25 * 365)).toIso8601String()}"),
                onDateSaved: (date) {
                  final dates = _formData['$elementName']?.split(',') ?? [];
                  dates[1] = date.string;
                  onSaved('$elementName', dates.join(','));
                },
                onDateSubmitted: (date) {
                  final dates = _formData['$elementName']?.split(',') ?? [];
                  dates[1] = date.string;
                  onSaved('$elementName', dates.join(','));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: IconButton(
                  onPressed: () async {
                    DateTimeRange? date = await showDateRangePicker(
                      context: context,
                      initialDateRange: DateTimeRange(
                          start:DateTime.parse("${map['initialDate']?.split(',').first ?? DateTime.now().toIso8601String()}"),
                          end:  DateTime.parse("${map['initialDate']?.split(',').last ?? DateTime.now().toIso8601String()}"),
                        ),
                        firstDate: DateTime.parse("${map['firstDate'] ?? DateTime.now().subtract(const Duration(days: 25 * 365)).toIso8601String()}"),
                        lastDate: DateTime.parse("${map['lastDate'] ?? DateTime.now().add(const Duration(days: 25 * 365)).toIso8601String()}"),
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
                              )
                            ],
                          );
                        },
                    );
                     if (date != null) {
                      _formData['$elementName'] = date.start.string + ',' + date.end.string;
                      onSaved('$elementName', date.start.string + ',' + date.end.string);
                    } 
                  },
                  icon: const Icon(Icons.calendar_today)),
            ),
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
                  initialDate: DateTime.parse(_formData['$elementName'] ?? "${map['initialDate'] ?? '${DateTime.now().toIso8601String()}'}"),
                  firstDate: DateTime.parse('${map['firstDate'] ?? '${DateTime.now().subtract(const Duration(days: 25 * 365)).toIso8601String()}'}'),
                  lastDate: DateTime.parse('${map['lastDate'] ?? '${DateTime.now().toIso8601String()}'}'),
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
                      initialDate: DateTime.parse(_formData['$elementName'] ?? "${map['initialDate'] ?? '${DateTime.now().toIso8601String()}'}"),
                      firstDate: DateTime.parse('${map['firstDate'] ?? '${DateTime.now().subtract(const Duration(days: 25 * 365)).toIso8601String()}'}'),
                      lastDate: DateTime.parse('${map['lastDate'] ?? '${DateTime.now().toIso8601String()}'}'),
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
    if (map['type'] == 'enum') {
      items = '''
        final List<Widget> chips = ${type}.values.map((value) {
          return ChoiceChip(
            label: Text(value.toString().split('.').last),
            selected: _selectedIndex == index,
            onSelected: (bool selected) {
              setState(() {
                _selectedIndex = selected ? index : null;
              });
              onSaved('${elementName}',  ${type}.values[_selectedIndex].split('.').last);
            },
        }).toList();
      ''';
    } else {
      items = '''
       final List<Map<String, dynamic>> options = ${map['options'] ?? '[]'};
        final List<Widget> chips = [];
        for (var index = 0; index < options.length; index++) {
          final option = options[index];
          chips.add(ChoiceChip(
            avatar: option['avatar'],
            avatarBorder: option['avatarBorder'],
            backgroundColor: option['backgroundColor'],
            clipBehavior: option['clipBehavior'],
            disabledColor: option['disabledColor'],
            elevation: option['elevation'],
            focusNode: option['focusNode'],
            isEnabled: option['isEnabled'],
            label: option['label'] ?? Text(option['value'].toString()),
            labelStyle: option['labelStyle'],
            labelPadding: option['labelPadding'],
            materialTapTargetSize: option['materialTapTargetSize'],
            selected: _selectedIndex == index,
            onSelected: (bool selected) {
              setState(() {
                _selectedIndex = selected ? index : null;
              });
              onSaved('$elementName', options[_selectedIndex]['value']);
            },
            padding: option['padding'],
            pressElevation: option['pressElevation'],
            selectedColor: option['selectedColor'],
            selectedShadowColor: option['selectedShadowColor'],
            shadowColor: option['shadowColor'],
            shape: option['shape'],
            side: option['side'],
            tooltip: option['tooltip'],
            visualDensity: option['visualDensity'],
          ));
''';
    }
    return '''
   int _selectedIndex = $items.indexWhere((item) == _formData['$elementName']);
        if (_selectedIndex == -1) {
          _selectedIndex = 0;
        }
        return Wrap(
          children: List<Widget>.generate(
            chips.length, 
            (int index) => chips[index]),
          );
      }
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
          validator: (value) => validate('${elementName}', value, parent: '${parent ?? ''}'),
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
    final rangeLabels = "RangeLabels(${map['labels'] ?? '_currentRangeValues.start.round().toString(),' + ' _currentRangeValues.end.round().toString(),'})";

    return '''
      RangeValues _currentRageValues = RangeValues(${map['startValue'] ?? 0}, ${map['endValue'] ?? 0});
      return SizedBox(
        height: 60,
        child: RangeSlider(
          activeColor: map['activeColor'] ?? Colors.blue,
          divisions: ${map['divisions'] ?? 1},
          inactiveColor: map['inactiveColor'] ?? Colors.grey,
          labels: $rangeLabels,
            min: ${map['min'] ?? 0},
            max: ${map['max'] ?? 100},
            onChanged:(RangeValues values)   {
              setState(() {
              _currentRangeValues = values;
              });
              onSaved('${elementName}', values, parent: '${parent ?? ''}');
            },
            onChangeStart: map['onChangeStart'],
            onChangeEnd: map['onChangeEnd'],
            sliderTheme: SliderTheme.of(context).copyWith(map['sliderTheme'] ?? {}),
            values: _currentRangeValues,
        ),
      )
    ''';
  }

  String sliderField(String elementName, String elementType, Map<String, dynamic> map, {String? parent}) {
    final initialValue = map['initialValue'] ?? 0.0;
    final autovalidateMode = map['autovalidateMode'] ?? 'AutovalidateMode.onUserInteraction';
    return '''
      SizedBox(
        height: 60,
        child: Slider(
          // autovalidateMode: $autovalidateMode,
          value:  initialValue: ${parent == null ? "_formData['$elementName'] ?? '$initialValue'" : "_formData['$parent']?['$elementName'] ?? '$initialValue'"},,
          min: ${map['min'] ?? 0},
          max: ${map['max'] ?? 100},
          divisions: ${map['divisions'] ?? 1},
          label: '${map['label'] ?? elementName}',
          onChanged:(value) => onSaved('${elementName}', value, parent: '${parent ?? ''}'),
          activeColor: map['activeColor'] ?? Colors.blue,
          inactiveColor: map['inactiveColor'] ?? Colors.grey,
          thumbColor: map['thumbColor'] ?? Colors.blue,
          semanticFormatterCallback: (double value) => value.toStringAsFixed(1),
          onChangeStart: map['onChangeStart'] ,
          onChangeEnd: map['onChangeEnd'] ,
          sliderTheme: SliderTheme.of(context).copyWith(map['sliderTheme'] ?? {}),
        ),

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
        ${Helpers.composeValidators(map['validators'] ?? [])}
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
