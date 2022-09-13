// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// Generator: FieldClassBuilder
// **************************************************************************

Widget addressFormField(BuildContext context, Map<String, dynamic> _formData,
    {required Function onSaved, required double width}) {
  _formData['address'] ??= Address().toJson();
  return Column(
    children: <Widget>[
      SizedBox(
        height: 60,
        child: TextFormField(
          autocorrect: true,
          autofillHints: null,
          autofocus: true,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          buildCounter: null,
          decoration: const InputDecoration(
            labelText: 'Street',
            labelStyle: TextStyle(fontSize: 16.0, color: Colors.black),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            hintText: '',
            helperText: '',
            fillColor: Colors.white,
            hoverColor: Color.fromARGB(255, 161, 179, 239),
            filled: true,
            errorMaxLines: 1,
            errorStyle: TextStyle(color: Colors.red, fontSize: 12.0),
            border: InputBorder.none,
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 1.0)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 1.0)),
            disabledBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            enabled: true,
            prefixIcon: null,
            prefixText: null,
            suffixIcon: null,
            suffixText: null,
            prefix: null,
            suffix: null,
            counterText: null,
            counterStyle: null,
            contentPadding: EdgeInsets.all(5.0),
            isDense: true,
            alignLabelWithHint: false,
          ),
          enabled: true,
          enableIMEPersonalizedLearning: false,
          enableInteractiveSelection: true,
          enableSuggestions: true,
          expands: true,
          focusNode: null,
          initialValue: _formData['address']?['street'] ?? '',
          inputFormatters: null,
          keyboardAppearance: Brightness.light,
          keyboardType: TextInputType.text,
          maxLength: null,
          maxLengthEnforcement: null,
          maxLines: null,
          minLines: null,
          mouseCursor: null,
          obscureText: false,
          obscuringCharacter: "•",
          onChanged: (value) => onSaved('street', value, parent: 'address'),
          onSaved: (value) => onSaved('street', value, parent: 'address'),
          scrollPadding: const EdgeInsets.all(5.0),
          validator: (value) {
            final errorList = <String>[];
            String? result;

            result = FormValidator.required(value,
                message: "Please enter your street");

            if (result != null) {
              errorList.add(result);
            }

            return errorList.isEmpty ? null : errorList.join('\n');
          },
        ), // TextFormField
      ) // SizedBox
      ,
      SizedBox(
        height: 60,
        child: TextFormField(
          autocorrect: true,
          autofillHints: null,
          autofocus: true,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          buildCounter: null,
          decoration: const InputDecoration(
            labelText: 'City',
            labelStyle: TextStyle(fontSize: 16.0, color: Colors.black),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            hintText: '',
            helperText: '',
            fillColor: Colors.white,
            hoverColor: Color.fromARGB(255, 161, 179, 239),
            filled: true,
            errorMaxLines: 1,
            errorStyle: TextStyle(color: Colors.red, fontSize: 12.0),
            border: InputBorder.none,
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 1.0)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 1.0)),
            disabledBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            enabled: true,
            prefixIcon: null,
            prefixText: null,
            suffixIcon: null,
            suffixText: null,
            prefix: null,
            suffix: null,
            counterText: null,
            counterStyle: null,
            contentPadding: EdgeInsets.all(5.0),
            isDense: true,
            alignLabelWithHint: false,
          ),
          enabled: true,
          enableIMEPersonalizedLearning: false,
          enableInteractiveSelection: true,
          enableSuggestions: true,
          expands: true,
          focusNode: null,
          initialValue: _formData['address']?['city'] ?? '',
          inputFormatters: null,
          keyboardAppearance: Brightness.light,
          keyboardType: TextInputType.text,
          maxLength: null,
          maxLengthEnforcement: null,
          maxLines: null,
          minLines: null,
          mouseCursor: null,
          obscureText: false,
          obscuringCharacter: "•",
          onChanged: (value) => onSaved('city', value, parent: 'address'),
          onSaved: (value) => onSaved('city', value, parent: 'address'),
          scrollPadding: const EdgeInsets.all(5.0),
          validator: (value) {
            final errorList = <String>[];
            String? result;

            result = FormValidator.required(value,
                message: "Please enter your city");

            if (result != null) {
              errorList.add(result);
            }

            return errorList.isEmpty ? null : errorList.join('\n');
          },
        ), // TextFormField
      ) // SizedBox
      ,
      SizedBox(
        height: 60,
        child: TextFormField(
          autocorrect: true,
          autofillHints: null,
          autofocus: true,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          buildCounter: null,
          decoration: const InputDecoration(
            labelText: 'State',
            labelStyle: TextStyle(fontSize: 16.0, color: Colors.black),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            hintText: '',
            helperText: '',
            fillColor: Colors.white,
            hoverColor: Color.fromARGB(255, 161, 179, 239),
            filled: true,
            errorMaxLines: 1,
            errorStyle: TextStyle(color: Colors.red, fontSize: 12.0),
            border: InputBorder.none,
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 1.0)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 1.0)),
            disabledBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            enabled: true,
            prefixIcon: null,
            prefixText: null,
            suffixIcon: null,
            suffixText: null,
            prefix: null,
            suffix: null,
            counterText: null,
            counterStyle: null,
            contentPadding: EdgeInsets.all(5.0),
            isDense: true,
            alignLabelWithHint: false,
          ),
          enabled: true,
          enableIMEPersonalizedLearning: false,
          enableInteractiveSelection: true,
          enableSuggestions: true,
          expands: true,
          focusNode: null,
          initialValue: _formData['address']?['state'] ?? '',
          inputFormatters: null,
          keyboardAppearance: Brightness.light,
          keyboardType: TextInputType.text,
          maxLength: null,
          maxLengthEnforcement: null,
          maxLines: null,
          minLines: null,
          mouseCursor: null,
          obscureText: false,
          obscuringCharacter: "•",
          onChanged: (value) => onSaved('state', value, parent: 'address'),
          onSaved: (value) => onSaved('state', value, parent: 'address'),
          scrollPadding: const EdgeInsets.all(5.0),
          validator: (value) {
            final errorList = <String>[];
            String? result;

            result = FormValidator.required(value,
                message: "Please enter your state");

            if (result != null) {
              errorList.add(result);
            }

            result = FormValidator.fixedLength(value,
                message: "Please enter 2 characters", length: 2);

            if (result != null) {
              errorList.add(result);
            }

            return errorList.isEmpty ? null : errorList.join('\n');
          },
        ), // TextFormField
      ) // SizedBox
      ,
      SizedBox(
        height: 60,
        child: TextFormField(
          autocorrect: true,
          autofillHints: null,
          autofocus: true,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          buildCounter: null,
          decoration: const InputDecoration(
            labelText: 'Postcode',
            labelStyle: TextStyle(fontSize: 16.0, color: Colors.black),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            hintText: '',
            helperText: '',
            fillColor: Colors.white,
            hoverColor: Color.fromARGB(255, 161, 179, 239),
            filled: true,
            errorMaxLines: 1,
            errorStyle: TextStyle(color: Colors.red, fontSize: 12.0),
            border: InputBorder.none,
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 1.0)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 1.0)),
            disabledBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            enabled: true,
            prefixIcon: null,
            prefixText: null,
            suffixIcon: null,
            suffixText: null,
            prefix: null,
            suffix: null,
            counterText: null,
            counterStyle: null,
            contentPadding: EdgeInsets.all(5.0),
            isDense: true,
            alignLabelWithHint: false,
          ),
          enabled: true,
          enableIMEPersonalizedLearning: false,
          enableInteractiveSelection: true,
          enableSuggestions: true,
          expands: true,
          focusNode: null,
          initialValue: _formData['address']?['postcode'] ?? '',
          inputFormatters: null,
          keyboardAppearance: Brightness.light,
          keyboardType: TextInputType.text,
          maxLength: null,
          maxLengthEnforcement: null,
          maxLines: null,
          minLines: null,
          mouseCursor: null,
          obscureText: false,
          obscuringCharacter: "•",
          onChanged: (value) => onSaved('postcode', value, parent: 'address'),
          onSaved: (value) => onSaved('postcode', value, parent: 'address'),
          scrollPadding: const EdgeInsets.all(5.0),
          validator: (value) {
            final errorList = <String>[];
            String? result;

            result = FormValidator.required(value,
                message: "Please enter your postcode");

            if (result != null) {
              errorList.add(result);
            }

            result = FormValidator.numeric(value,
                message: "Please enter a valid postcode");

            if (result != null) {
              errorList.add(result);
            }

            return errorList.isEmpty ? null : errorList.join('\n');
          },
        ), // TextFormField
      ) // SizedBox
      ,
    ],
  );
}

// **************************************************************************
// Generator: FieldDatePickerBuilder
// **************************************************************************

Widget birthdateFormField(BuildContext context, Map<String, dynamic> _formData,
    {required Function onSaved, required double width}) {
  String? initialDate = "1945-01-01";
  if (initialDate.isEmpty) {
    initialDate = null;
  }
  String firstDate = "1945-01-01";
  String lastDate = "2021-12-31";

  // Condition # 1 - a  If firstDate is empty, then set firstDate
  //  if initialDate is not empty then before initialDate, else current date
  firstDate = firstDate.isEmpty
      ? (lastDate.isEmpty
          ? DateTime.now().subtract(const Duration(days: 365)).toIso8601String()
          : DateTime.parse(lastDate)
              .subtract(const Duration(days: 365))
              .toIso8601String())
      : firstDate;

  // Condition # 2 initialDate is either null or on after firstDate.
  if (initialDate != null &&
      DateTime.parse(initialDate).isBefore(DateTime.parse(firstDate))) {
    initialDate = null;
  }
  // Condition # 3 last date must be after firstDate
  if (lastDate.isEmpty ||
      DateTime.parse(lastDate).isBefore(DateTime.parse(firstDate))) {
    lastDate = DateTime.parse(firstDate)
        .add(const Duration(days: 1))
        .toIso8601String();
  }

  return Padding(
    padding: const EdgeInsets.only(bottom: 15.0),
    child: SizedBox(
      height: 60,
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: InputDatePickerFormField(
              autofocus: false,
              errorFormatText: "Invalid Date format",
              errorInvalidText:
                  "The date is not valid. It is earlier than first date, later than last date, or doesn't pass the selectable day test.",
              fieldHintText: "Select a date",
              fieldLabelText: " birthdate",
              initialDate:
                  DateTime.parse(_formData['birthdate'] ?? initialDate),
              firstDate: DateTime.parse(firstDate),
              lastDate: DateTime.parse(lastDate),
              onDateSaved: (DateTime date) {
                _formData['birthdate'] = date.toIso8601String();
                onSaved('birthdate', date.toIso8601String());
              },
              selectableDayPredicate: null,
            ), // end InputDatePickerFormField
          ), // end SizedBox
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: IconButton(
                onPressed: () async {
                  DateTime? date = await showDatePicker(
                    context: context,
                    initialDate:
                        DateTime.parse(_formData['birthdate'] ?? initialDate),
                    firstDate: DateTime.parse(firstDate),
                    lastDate: DateTime.parse(lastDate),
                    selectableDayPredicate: null,
                  );
                  if (date != null) {
                    _formData['birthdate'] = date.toIso8601String();
                    onSaved('birthdate', date.toIso8601String());
                  }
                },
                icon: const Icon(Icons.calendar_today)),
          ),
        ],
      ), // end Row
    ),
  );
}

// **************************************************************************
// Generator: FieldDateRangePickerBuilder
// **************************************************************************

Widget journeyDatesFormField(
    BuildContext context, Map<String, dynamic> _formData,
    {required Function onSaved, required double width}) {
  final initialStartDate = (_formData['journeyDates']?.split(',').first ??
          "2022-09-13T10:10:02.092753")
      .substring(0, 10);
  final initialEndDate = (_formData['journeyDates']?.split(',')?.first ??
          "2022-09-13T10:10:02.094460")
      .substring(0, 10);
  String firstDate = "";
  String lastDate = "";
  if (firstDate.isEmpty) {
    firstDate = DateTime.parse(initialStartDate)
        .subtract(const Duration(days: 365))
        .toIso8601String()
        .substring(0, 10);
  }
  if (lastDate.isEmpty) {
    lastDate = DateTime.parse(initialEndDate)
        .add(const Duration(days: 365))
        .toIso8601String()
        .substring(0, 10);
  }
  void save(DateTime date, bool start) {
    final dates = _formData['journeyDates']?.split(',') ?? [];
    dates[start ? 0 : 1] = date.toIso8601String().substring(0, 10);
    onSaved('journeyDates', dates.join(','));
  }

  return SizedBox(
    height: 100,
    child: Column(
      children: [
        Row(children: const [Text('journeyDates')]),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 100,
              child: InputDatePickerFormField(
                fieldLabelText: "Start Date",
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
                fieldLabelText: "End Date",
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
                onPressed: () async {
                  final DateTimeRange? date = await showDateRangePicker(
                    context: context,
                    initialDateRange: DateTimeRange(
                      start: DateTime.parse(initialStartDate),
                      end: DateTime.parse(initialEndDate),
                    ),
                    firstDate: DateTime.parse(firstDate),
                    lastDate: DateTime.parse(lastDate),
                    helpText: 'Select JourneyDates dates',
                    cancelText: 'Cancel',
                    confirmText: 'Confirm',
                    saveText: 'Done',
                    errorFormatText: "Invalid date format",
                    errorInvalidText: "Invalid date",
                    errorInvalidRangeText: "Invalid date range",
                    fieldStartHintText: "Start date",
                    fieldEndHintText: "End date",
                    fieldStartLabelText: "journeyDates start",
                    fieldEndLabelText: "journeyDates end",
                    textDirection: TextDirection.ltr,
                    builder: (context, child) {
                      return Column(
                        children: [
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.1),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: 400.0,
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.8,
                            ),
                            child: child,
                          ) // ConstrainedBox
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
        ), // end Row
      ], // end Column children
    ), // end Column
  ) // end SizedBox
      ;
}

// **************************************************************************
// Generator: FieldDropdownBuilder
// **************************************************************************

Widget gradeFormField(BuildContext context, Map<String, dynamic> _formData,
    {required Function onSaved, required double width}) {
  double maxWidth = 0;
  final options = [];
  for (var e in options) {
    maxWidth = max(maxWidth, e['value'].toString().length * 1.0);
  }
  return SizedBox(
    width: 200, // min(width, maxWidth * 10),
    child: DropdownButtonFormField(
      value:
          _formData['grade'] ?? Grades.values.first.toString().split('.').last,
      decoration: const InputDecoration(
        labelText: 'Grade',
        hintText: '',
        helperText: '',
      ),
      items: Grades.values.map((value) {
        maxWidth = max(value.toString().split('.').last.length * 1.0, maxWidth);
        return DropdownMenuItem(
          value: value.toString().split('.').last,
          child: Text(value.toString().split('.').last),
        );
      }).toList(),
      onChanged: (value) => onSaved('grade', value, parent: ''),
    ), // DropdownButtonFormField
  ) // SizedBox
      ;
}

Widget profileTypeFormField(
    BuildContext context, Map<String, dynamic> _formData,
    {required Function onSaved, required double width}) {
  double maxWidth = 0;
  final options = [];
  for (var e in options) {
    maxWidth = max(maxWidth, e['value'].toString().length * 1.0);
  }
  return SizedBox(
    width: 200, // min(width, maxWidth * 10),
    child: DropdownButtonFormField(
      value: _formData['profileType'] ??
          ProfileType.values.first.toString().split('.').last,
      decoration: const InputDecoration(
        labelText: 'Profile Type',
        hintText: '',
        helperText: '',
      ),
      items: ProfileType.values.map((value) {
        maxWidth = max(value.toString().split('.').last.length * 1.0, maxWidth);
        return DropdownMenuItem(
          value: value.toString().split('.').last,
          child: Text(value.toString().split('.').last),
        );
      }).toList(),
      onChanged: (value) => onSaved('profileType', value, parent: ''),
    ), // DropdownButtonFormField
  ) // SizedBox
      ;
}

// **************************************************************************
// Generator: FieldRangeSliderBuilder
// **************************************************************************

Widget salaryRangeFormField(
    BuildContext context, Map<String, dynamic> _formData,
    {required Function onSaved, required double width}) {
  late RangeLabels rangeLabels;
  const configuredLabels = ',';
  // formatter for labels
  String __semanticFormatter(RangeValues value) {
    Future.delayed(
        Duration.zero,
        () => onSaved(
            'salaryRange', '${value.start.toString()},${value.end.toString()}',
            parent: ''));

    rangeLabels = RangeLabels(
        configuredLabels.split(',').first + value.start.round().toString(),
        configuredLabels.split(',').last + value.end.round().toString());
    return '${value.start.round().toString()} - ${value.end.round().toString()}';
  }

  double? start = _formData['salaryRange'] == null
      ? null
      : double.tryParse(_formData['salaryRange']?.split(',').first ?? "0.0");
  double? end = _formData['salaryRange'] == null
      ? null
      : double.tryParse(_formData['salaryRange']?.split(',').last ?? "0.0");
  const double? min = 30000.0;
  const double? max = 120000.0;
  if ((start ?? 0.0) < min) start = min;
  if ((end ?? 0.0) > max) end = max;
  RangeValues _currentRangeValues = RangeValues(start ?? min, end ?? max);
  __semanticFormatter(_currentRangeValues);

  _formData['salaryRange'] = _formData['salaryRange'] ??
      '${_currentRangeValues.start.round().toString()},${_currentRangeValues.end.round().toString()}';
  return SizedBox(
    height: 80,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 25),
              const Text('Salary Range'),
              Text(__semanticFormatter(_currentRangeValues),
                  style: const TextStyle(fontSize: 10)),
            ],
          ),
        ), //SizedBox

        Expanded(
          flex: 4,
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(),
            child: RangeSlider(
              activeColor: null,
              divisions: 10,
              inactiveColor: null,
              labels: rangeLabels,
              min: min,
              max: max,
              onChanged: (RangeValues values) {
                __semanticFormatter(values);
              },
              onChangeStart: null,
              onChangeEnd: null,
              values: _currentRangeValues,
            ),
          ), // SliderTheme
        ),
      ],
    ), // Row
  );
}

// **************************************************************************
// Generator: FieldSliderBuilder
// **************************************************************************

Widget salaryFormField(BuildContext context, Map<String, dynamic> _formData,
    {required Function onSaved, required double width}) {
  String semanticLabel = '${_formData['salary'] ?? 30000.0}';
  String __semanticFormatter(double value) {
    Future.delayed(Duration.zero, () => onSaved('salary', value, parent: ''));
    String callback(double value) {
      return "${value.toStringAsFixed(2)} Dollars";
    }

    semanticLabel = callback(value);
    return semanticLabel;
  }

  _formData['salary'] = _formData['salary'] ?? 30000.0;
  return SizedBox(
    height: 60,
    child: Row(
      children: [
        const Text('Salary'),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(),
          child: Slider(
            value: _formData['salary'] ?? 30000.0,
            min: 30000.0,
            max: 100000.0,
            divisions: 10,
            label: semanticLabel,
            onChanged: (value) => onSaved('salary', value, parent: ''),
            activeColor: Colors.blue,
            inactiveColor: Colors.grey,
            thumbColor: Colors.amber,
            mouseCursor: null,
            semanticFormatterCallback: (double value) =>
                __semanticFormatter(value),
            onChangeStart: null,
            onChangeEnd: null,
          ), // Slider
        ), // SliderTheme
        Text(semanticLabel),
      ],
    ), // Row
  ) // SizedBox
      ;
}

// **************************************************************************
// Generator: FieldTextAreaBuilder
// **************************************************************************

Widget descriptionFormField(
    BuildContext context, Map<String, dynamic> _formData,
    {required Function onSaved, required double width}) {
  return SizedBox(
    height: 60,
    child: TextFormField(
      autocorrect: true,
      autofillHints: null,
      autofocus: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      buildCounter: null,
      decoration: const InputDecoration(
        labelText: 'Description',
        labelStyle: TextStyle(fontSize: 16.0, color: Colors.black),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        hintText: '',
        helperText: '',
        fillColor: Colors.white,
        hoverColor: Color.fromARGB(255, 161, 179, 239),
        filled: true,
        errorMaxLines: 1,
        errorStyle: TextStyle(color: Colors.red, fontSize: 12.0),
        border: InputBorder.none,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1.0)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 1.0)),
        disabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        enabled: true,
        prefixIcon: null,
        prefixText: null,
        suffixIcon: null,
        suffixText: null,
        prefix: null,
        suffix: null,
        counterText: null,
        counterStyle: null,
        contentPadding: EdgeInsets.all(5.0),
        isDense: true,
        alignLabelWithHint: false,
      ),
      enabled: true,
      enableIMEPersonalizedLearning: false,
      enableInteractiveSelection: true,
      enableSuggestions: true,
      expands: true,
      focusNode: null,
      initialValue: _formData['description'] ?? '',
      inputFormatters: null,
      keyboardAppearance: Brightness.light,
      keyboardType: TextInputType.text,
      maxLength: null,
      maxLengthEnforcement: null,
      maxLines: null,
      minLines: null,
      mouseCursor: null,
      obscureText: false,
      obscuringCharacter: "•",
      onChanged: (value) => onSaved('description', value, parent: ''),
      onSaved: (value) => onSaved('description', value, parent: ''),
      scrollPadding: const EdgeInsets.all(5.0),
    ), // TextFormField
  ) // SizedBox
      ;
}

// **************************************************************************
// FormBuilderGenerator
// **************************************************************************

class ProfileForm extends StatefulWidget {
  // ignore_for_file: unused_element, unnecessary_this, non_constant_identifier_names

  const ProfileForm({
    Key? key,
    this.model,
    this.onSubmit,
    this.allowNullOrEmpty = false,
    this.needScaffold = true,
    this.showAppBar = true,
    this.appBar,
    this.size,
    this.textStyle,
    this.color,
    this.textColor,
    this.headlineStyle,
    this.backgroundColor,
    this.backgroundImage,
    this.backgroundImageFit,
  }) : super(key: key);
  final Profile? model;
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
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final _formData = <String, dynamic>{};
  final bool _allowNullOrEmpty = true;
  double _width = 600;
  @override
  void initState() {
    super.initState();

    _formData.addAll(widget.model?.toJson() ??
        {
          'firstName': null,
          'lastName': null,
          'grade': null,
          'birthdate': null,
          'email': null,
          'profileType': null,
          'phone': null,
          'salary': null,
          'journeyDates': null,
          'salaryRange': null,
          'description': null,
          'address': null,
          'website': null,
          'avatar': null
        });
  }

  void setWidth() {
    _width = min(widget.size?.width ?? MediaQuery.of(context).size.width, 600);
  }

  @override
  void didChangeDependencies() {
    setWidth();
    super.didChangeDependencies();
  }

  void onSaved(String key, dynamic value, {String? parent}) {
    if (mounted) {
      setState(() {
        if (parent != null && parent.isNotEmpty) {
          _formData[parent][key] = value;
        } else {
          _formData[key] = value;
        }
      });
    }
  }

  Future<void> alert(String title, List<String> messages,
      {String? okButtonText}) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: const TextStyle(fontSize: 20)),
          content: SingleChildScrollView(
            child: ListBody(
              children: messages.map((String message) {
                return Text(message);
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(okButtonText ?? 'OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void onSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      if (!_allowNullOrEmpty &&
          _formData.keys.toList().any(
              (e) => _formData[e] == null || _formData[e].toString().isEmpty)) {
        await alert('Error', ['Please fill in all the required fields.']);
        return;
      }
      Navigator.of(context).pop(Profile.fromJson(_formData));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar
          ? widget.appBar ??
              AppBar(
                automaticallyImplyLeading: false,
                title: Text(
                  widget.model == null ? 'Add ProfileForm' : 'Edit ProfileForm',
                  style: widget.headlineStyle ??
                      Theme.of(context).textTheme.headline6,
                ),
                leadingWidth: 70,
                leading: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel',
                      style: Theme.of(context).textTheme.button?.copyWith(
                          color: widget.textColor ??
                              Theme.of(context).colorScheme.onPrimary)),
                ),
              )
          : null,
      body: SizedBox(
        height: widget.size?.height ??
            min(
                MediaQuery.of(context).size.height -
                    (widget.showAppBar ? AppBar().preferredSize.height : 0),
                _formData.keys.toList().length * 85),
        width: widget.size?.width ?? MediaQuery.of(context).size.width,
        child: Center(
          child: Container(
            width: min(
                widget.size?.width ?? MediaQuery.of(context).size.width, 600),
            height: widget.size?.height ??
                min(
                    MediaQuery.of(context).size.height -
                        (widget.showAppBar ? AppBar().preferredSize.height : 0),
                    _formData.keys.toList().length * 85),
            color: widget.backgroundColor ?? Colors.white,
            child: Card(
              elevation: 15,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              shadowColor: Colors.black,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
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
                            firstNameFormField(context, _formData,
                                onSaved: onSaved, width: _width),
                            lastNameFormField(context, _formData,
                                onSaved: onSaved, width: _width),
                            gradeFormField(context, _formData,
                                onSaved: onSaved, width: _width),
                            birthdateFormField(context, _formData,
                                onSaved: onSaved, width: _width),
                            emailFormField(context, _formData,
                                onSaved: onSaved, width: _width),
                            profileTypeFormField(context, _formData,
                                onSaved: onSaved, width: _width),
                            phoneFormField(context, _formData,
                                onSaved: onSaved, width: _width),
                            salaryFormField(context, _formData,
                                onSaved: onSaved, width: _width),
                            journeyDatesFormField(context, _formData,
                                onSaved: onSaved, width: _width),
                            salaryRangeFormField(context, _formData,
                                onSaved: onSaved, width: _width),
                            descriptionFormField(context, _formData,
                                onSaved: onSaved, width: _width),
                            addressFormField(context, _formData,
                                onSaved: onSaved, width: _width),
                            websiteFormField(context, _formData,
                                onSaved: onSaved, width: _width),
                            avatarFormField(context, _formData,
                                onSaved: onSaved, width: _width)
                          ],
                        ),
                      ),
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
                              onPressed: _formKey.currentState?.validate() ??
                                      false
                                  ? () {
                                      if (_formKey.currentState?.validate() ??
                                          false) {
                                        _formKey.currentState?.save();
                                        Navigator.of(context)
                                            .pop(Profile.fromJson(_formData));
                                      }
                                    }
                                  : null,
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
} // _ProfileFormState

extension on String {
  bool get isEmail =>
      RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+.[a-zA-Z]+').hasMatch(this);
  bool get isPhone => RegExp(r'^[0-9]{10}').hasMatch(this);
  bool get isNumeric => RegExp(r'^[0-9.]*$').hasMatch(this);
  bool get isName => RegExp(r'^[a-zA-Z.]*$').hasMatch(this);
  bool get isDate => RegExp(r'^[0-9]{4}-[0-9]{2}-[0-9]{2}$').hasMatch(this);
  bool get isDateTime =>
      RegExp(r'^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}$')
          .hasMatch(this);
  bool get isTime => RegExp(r'^[0-9]{2}:[0-9]{2}:[0-9]{2}$').hasMatch(this);
  bool get isDateTimeRange => RegExp(
          r'^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}-[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}$')
      .hasMatch(this);
  bool get isDateRange =>
      RegExp(r'^[0-9]{4}-[0-9]{2}-[0-9]{2}-[0-9]{4}-[0-9]{2}-[0-9]{2}$')
          .hasMatch(this);
  String get capitalize => '${this[0].toUpperCase()}${this.substring(1)}';
  String get capitalizeWords =>
      this.split(' ').map((word) => word.capitalize).join(' ');
  String camelCase() => this.split(' ').map((word) => word.capitalize).join('');
  String get camelCaseToTitleCase =>
      this.split(' ').map((word) => word.capitalize).join(' ');
}

extension on DateTime {
  String get dateTimeFormat =>
      "${this.day}-${this.month}-${this.year} ${this.hour}:${this.minute}:${this.second}";
  String get DMY => '${this.day}-${this.month}-${this.year}';
  String get MDY => '${this.month}-${this.day}-${this.year}';
  String get string => '${this.year}-${this.month}-${this.day}';
}

// **************************************************************************
// Generator: FieldTextBuilder
// **************************************************************************

Widget firstNameFormField(BuildContext context, Map<String, dynamic> _formData,
    {required Function onSaved, required double width}) {
  return SizedBox(
    height: 60,
    child: TextFormField(
      autocorrect: true,
      autofillHints: null,
      autofocus: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      buildCounter: null,
      decoration: const InputDecoration(
        labelText: 'First name',
        labelStyle: TextStyle(fontSize: 16.0, color: Colors.black),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        hintText: '',
        helperText: '',
        fillColor: Colors.white,
        hoverColor: Color.fromARGB(255, 161, 179, 239),
        filled: true,
        errorMaxLines: 1,
        errorStyle: TextStyle(color: Colors.red, fontSize: 12.0),
        border: InputBorder.none,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1.0)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 1.0)),
        disabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        enabled: true,
        prefixIcon: null,
        prefixText: null,
        suffixIcon: null,
        suffixText: null,
        prefix: null,
        suffix: null,
        counterText: null,
        counterStyle: null,
        contentPadding: EdgeInsets.all(5.0),
        isDense: true,
        alignLabelWithHint: false,
      ),
      enabled: true,
      enableIMEPersonalizedLearning: false,
      enableInteractiveSelection: true,
      enableSuggestions: true,
      expands: true,
      focusNode: null,
      initialValue: _formData['firstName'] ?? '',
      inputFormatters: null,
      keyboardAppearance: Brightness.light,
      keyboardType: TextInputType.text,
      maxLength: null,
      maxLengthEnforcement: null,
      maxLines: null,
      minLines: null,
      mouseCursor: null,
      obscureText: false,
      obscuringCharacter: "•",
      onChanged: (value) => onSaved('firstName', value, parent: ''),
      onSaved: (value) => onSaved('firstName', value, parent: ''),
      scrollPadding: const EdgeInsets.all(5.0),
      validator: (value) {
        final errorList = <String>[];
        String? result;

        result = FormValidator.required(value,
            message: "Please enter your first name");

        if (result != null) {
          errorList.add(result);
        }

        return errorList.isEmpty ? null : errorList.join('\n');
      },
    ), // TextFormField
  ) // SizedBox
      ;
}

Widget lastNameFormField(BuildContext context, Map<String, dynamic> _formData,
    {required Function onSaved, required double width}) {
  return SizedBox(
    height: 60,
    child: TextFormField(
      autocorrect: true,
      autofillHints: null,
      autofocus: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      buildCounter: null,
      decoration: const InputDecoration(
        labelText: 'Last name',
        labelStyle: TextStyle(fontSize: 16.0, color: Colors.black),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        hintText: '',
        helperText: '',
        fillColor: Colors.white,
        hoverColor: Color.fromARGB(255, 161, 179, 239),
        filled: true,
        errorMaxLines: 1,
        errorStyle: TextStyle(color: Colors.red, fontSize: 12.0),
        border: InputBorder.none,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1.0)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 1.0)),
        disabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        enabled: true,
        prefixIcon: null,
        prefixText: null,
        suffixIcon: null,
        suffixText: null,
        prefix: null,
        suffix: null,
        counterText: null,
        counterStyle: null,
        contentPadding: EdgeInsets.all(5.0),
        isDense: true,
        alignLabelWithHint: false,
      ),
      enabled: true,
      enableIMEPersonalizedLearning: false,
      enableInteractiveSelection: true,
      enableSuggestions: true,
      expands: true,
      focusNode: null,
      initialValue: _formData['lastName'] ?? '',
      inputFormatters: null,
      keyboardAppearance: Brightness.light,
      keyboardType: TextInputType.text,
      maxLength: null,
      maxLengthEnforcement: null,
      maxLines: null,
      minLines: null,
      mouseCursor: null,
      obscureText: false,
      obscuringCharacter: "•",
      onChanged: (value) => onSaved('lastName', value, parent: ''),
      onSaved: (value) => onSaved('lastName', value, parent: ''),
      scrollPadding: const EdgeInsets.all(5.0),
      validator: (value) {
        final errorList = <String>[];
        String? result;

        result = FormValidator.required(value,
            message: "Please enter your last name");

        if (result != null) {
          errorList.add(result);
        }

        return errorList.isEmpty ? null : errorList.join('\n');
      },
    ), // TextFormField
  ) // SizedBox
      ;
}

Widget emailFormField(BuildContext context, Map<String, dynamic> _formData,
    {required Function onSaved, required double width}) {
  return SizedBox(
    height: 60,
    child: TextFormField(
      autocorrect: true,
      autofillHints: null,
      autofocus: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      buildCounter: null,
      decoration: const InputDecoration(
        labelText: 'Email',
        labelStyle: TextStyle(fontSize: 16.0, color: Colors.black),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        hintText: '',
        helperText: '',
        fillColor: Colors.white,
        hoverColor: Color.fromARGB(255, 161, 179, 239),
        filled: true,
        errorMaxLines: 1,
        errorStyle: TextStyle(color: Colors.red, fontSize: 12.0),
        border: InputBorder.none,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1.0)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 1.0)),
        disabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        enabled: true,
        prefixIcon: null,
        prefixText: null,
        suffixIcon: null,
        suffixText: null,
        prefix: null,
        suffix: null,
        counterText: null,
        counterStyle: null,
        contentPadding: EdgeInsets.all(5.0),
        isDense: true,
        alignLabelWithHint: false,
      ),
      enabled: true,
      enableIMEPersonalizedLearning: false,
      enableInteractiveSelection: true,
      enableSuggestions: true,
      expands: true,
      focusNode: null,
      initialValue: _formData['email'] ?? '',
      inputFormatters: null,
      keyboardAppearance: Brightness.light,
      keyboardType: TextInputType.text,
      maxLength: null,
      maxLengthEnforcement: null,
      maxLines: null,
      minLines: null,
      mouseCursor: null,
      obscureText: false,
      obscuringCharacter: "•",
      onChanged: (value) => onSaved('email', value, parent: ''),
      onSaved: (value) => onSaved('email', value, parent: ''),
      scrollPadding: const EdgeInsets.all(5.0),
      validator: (value) {
        final errorList = <String>[];
        String? result;

        result = FormValidator.required(
          value,
        );

        if (result != null) {
          errorList.add(result);
        }

        result = FormValidator.email(
          value,
        );

        if (result != null) {
          errorList.add(result);
        }

        return errorList.isEmpty ? null : errorList.join('\n');
      },
    ), // TextFormField
  ) // SizedBox
      ;
}

Widget phoneFormField(BuildContext context, Map<String, dynamic> _formData,
    {required Function onSaved, required double width}) {
  return SizedBox(
    height: 60,
    child: TextFormField(
      autocorrect: true,
      autofillHints: null,
      autofocus: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      buildCounter: null,
      decoration: const InputDecoration(
        labelText: 'Phone',
        labelStyle: TextStyle(fontSize: 16.0, color: Colors.black),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        hintText: '',
        helperText: '',
        fillColor: Colors.white,
        hoverColor: Color.fromARGB(255, 161, 179, 239),
        filled: true,
        errorMaxLines: 1,
        errorStyle: TextStyle(color: Colors.red, fontSize: 12.0),
        border: InputBorder.none,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1.0)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 1.0)),
        disabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        enabled: true,
        prefixIcon: null,
        prefixText: null,
        suffixIcon: null,
        suffixText: null,
        prefix: null,
        suffix: null,
        counterText: null,
        counterStyle: null,
        contentPadding: EdgeInsets.all(5.0),
        isDense: true,
        alignLabelWithHint: false,
      ),
      enabled: true,
      enableIMEPersonalizedLearning: false,
      enableInteractiveSelection: true,
      enableSuggestions: true,
      expands: true,
      focusNode: null,
      initialValue: _formData['phone'] ?? '',
      inputFormatters: null,
      keyboardAppearance: Brightness.light,
      keyboardType: TextInputType.text,
      maxLength: null,
      maxLengthEnforcement: null,
      maxLines: null,
      minLines: null,
      mouseCursor: null,
      obscureText: false,
      obscuringCharacter: "•",
      onChanged: (value) => onSaved('phone', value, parent: ''),
      onSaved: (value) => onSaved('phone', value, parent: ''),
      scrollPadding: const EdgeInsets.all(5.0),
      validator: (value) {
        final errorList = <String>[];
        String? result;

        result = FormValidator.required(
          value,
        );

        if (result != null) {
          errorList.add(result);
        }

        result = FormValidator.phone(
          value,
        );

        if (result != null) {
          errorList.add(result);
        }

        return errorList.isEmpty ? null : errorList.join('\n');
      },
    ), // TextFormField
  ) // SizedBox
      ;
}

Widget websiteFormField(BuildContext context, Map<String, dynamic> _formData,
    {required Function onSaved, required double width}) {
  return SizedBox(
    height: 60,
    child: TextFormField(
      autocorrect: true,
      autofillHints: null,
      autofocus: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      buildCounter: null,
      decoration: const InputDecoration(
        labelText: 'Website',
        labelStyle: TextStyle(fontSize: 16.0, color: Colors.black),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        hintText: '',
        helperText: '',
        fillColor: Colors.white,
        hoverColor: Color.fromARGB(255, 161, 179, 239),
        filled: true,
        errorMaxLines: 1,
        errorStyle: TextStyle(color: Colors.red, fontSize: 12.0),
        border: InputBorder.none,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1.0)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 1.0)),
        disabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        enabled: true,
        prefixIcon: null,
        prefixText: null,
        suffixIcon: null,
        suffixText: null,
        prefix: null,
        suffix: null,
        counterText: null,
        counterStyle: null,
        contentPadding: EdgeInsets.all(5.0),
        isDense: true,
        alignLabelWithHint: false,
      ),
      enabled: true,
      enableIMEPersonalizedLearning: false,
      enableInteractiveSelection: true,
      enableSuggestions: true,
      expands: true,
      focusNode: null,
      initialValue: _formData['website'] ?? '',
      inputFormatters: null,
      keyboardAppearance: Brightness.light,
      keyboardType: TextInputType.url,
      maxLength: null,
      maxLengthEnforcement: null,
      maxLines: null,
      minLines: null,
      mouseCursor: null,
      obscureText: false,
      obscuringCharacter: "•",
      onChanged: (value) => onSaved('website', value, parent: ''),
      onSaved: (value) => onSaved('website', value, parent: ''),
      scrollPadding: const EdgeInsets.all(5.0),
    ), // TextFormField
  ) // SizedBox
      ;
}

Widget avatarFormField(BuildContext context, Map<String, dynamic> _formData,
    {required Function onSaved, required double width}) {
  return SizedBox(
    height: 60,
    child: TextFormField(
      autocorrect: true,
      autofillHints: null,
      autofocus: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      buildCounter: null,
      decoration: const InputDecoration(
        labelText: 'Avatar',
        labelStyle: TextStyle(fontSize: 16.0, color: Colors.black),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        hintText: '',
        helperText: '',
        fillColor: Colors.white,
        hoverColor: Color.fromARGB(255, 161, 179, 239),
        filled: true,
        errorMaxLines: 1,
        errorStyle: TextStyle(color: Colors.red, fontSize: 12.0),
        border: InputBorder.none,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1.0)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 1.0)),
        disabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        enabled: true,
        prefixIcon: null,
        prefixText: null,
        suffixIcon: null,
        suffixText: null,
        prefix: null,
        suffix: null,
        counterText: null,
        counterStyle: null,
        contentPadding: EdgeInsets.all(5.0),
        isDense: true,
        alignLabelWithHint: false,
      ),
      enabled: true,
      enableIMEPersonalizedLearning: false,
      enableInteractiveSelection: true,
      enableSuggestions: true,
      expands: true,
      focusNode: null,
      initialValue: _formData['avatar'] ?? 'https://i.pravatar.cc/300',
      inputFormatters: null,
      keyboardAppearance: Brightness.light,
      keyboardType: TextInputType.text,
      maxLength: null,
      maxLengthEnforcement: null,
      maxLines: null,
      minLines: null,
      mouseCursor: null,
      obscureText: false,
      obscuringCharacter: "•",
      onChanged: (value) => onSaved('avatar', value, parent: ''),
      onSaved: (value) => onSaved('avatar', value, parent: ''),
      scrollPadding: const EdgeInsets.all(5.0),
    ), // TextFormField
  ) // SizedBox
      ;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Address _$AddressFromJson(Map<String, dynamic> json) => Address(
      street: json['street'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      postcode: json['postcode'] as String?,
    );

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'street': instance.street,
      'city': instance.city,
      'state': instance.state,
      'postcode': instance.postcode,
    };

Profile _$ProfileFromJson(Map<String, dynamic> json) => Profile(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      profileType: $enumDecode(_$ProfileTypeEnumMap, json['profileType']),
      grade: $enumDecode(_$GradesEnumMap, json['grade']),
      birthdate: DateTime.parse(json['birthdate'] as String),
      email: json['email'] as String,
      phone: json['phone'] as String,
      journeyDates: json['journeyDates'] as String,
      description: json['description'] as String,
      address: _addressFromJson(json['address'] as Map<String, dynamic>),
      website: json['website'] as String,
      salary: (json['salary'] as num).toDouble(),
      salaryRange: json['salaryRange'] as String,
      avatar: json['avatar'] as String,
    );

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'grade': _$GradesEnumMap[instance.grade],
      'birthdate': instance.birthdate.toIso8601String(),
      'email': instance.email,
      'profileType': _$ProfileTypeEnumMap[instance.profileType],
      'phone': instance.phone,
      'salary': instance.salary,
      'journeyDates': instance.journeyDates,
      'salaryRange': instance.salaryRange,
      'description': instance.description,
      'address': _addressToJson(instance.address),
      'website': instance.website,
      'avatar': instance.avatar,
    };

const _$ProfileTypeEnumMap = {
  ProfileType.personal: 'personal',
  ProfileType.professional: 'professional',
};

const _$GradesEnumMap = {
  Grades.executive: 'executive',
  Grades.manager: 'manager',
  Grades.staff: 'staff',
  Grades.intern: 'intern',
};
