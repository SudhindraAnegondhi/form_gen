// ignore_for_file: omit_local_variable_types
// ignore_for_file: lines_longer_than_80_chars
import 'form_validator.dart' show FieldValidator;

/// A Material Design checkbox.
///
/// The checkbox itself does not maintain any state. Instead, when the state of the checkbox changes, the widget calls the onChanged callback. Most widgets that use a checkbox will listen for the onChanged callback and rebuild the checkbox with a new value to update the visual appearance of the checkbox.
///
/// The checkbox can optionally display three values - true, false, and null - if tristate is true. When value is null a dash is displayed. By default tristate is false and the checkbox's value must be true or false.
class FieldCheckbox {
  // Flutter CheckBox properties
  final String? activeColor;
  final bool? autofocus;
  final String? checkColor;
  final String? fillColor;
  final String? focusColor;
  final String? focusNode;
  final String? hoverColor;
  final String? materialTapTargetSize;
  final String? mouseCursor;
  final String? overlayColor;
  final String? shape;
  final String? side;
  final String? splashRadius;
  final String? tristate;
  final bool? value;
  final String? visualDensity;

  const FieldCheckbox({
    this.activeColor,
    this.autofocus,
    this.checkColor,
    this.fillColor,
    this.focusColor,
    this.focusNode,
    this.hoverColor,
    this.materialTapTargetSize,
    this.mouseCursor,
    this.overlayColor,
    this.shape,
    this.side,
    this.splashRadius,
    this.tristate,
    this.value,
    this.visualDensity,
  });
}

///A Material Design choice chip.

/// ChoiceChips represent a single choice from a set. Choice chips contain related descriptive text or categories.

/// The selected and label arguments must not be null.

class FieldChoiceChip {
  /// Optional. default is 'false'
  final bool? autofocus;
  final String? type; // basically: enum/any other type

  /// widget for avatar within quotes
  final String? avatar; // widget
  /// Border around avatar
  /// ShapeBorder, within quotes
  final String? avatarBorder; // ShapeBorder
  final String? backgroundColor; // Colors.white
  final String? clipBehavior; // Clip.none
  final String? disabledColor; // Colors.grey.shade400
  final double? elevation; // 0
  final String? focusNode; // FocusNode()
  final bool? isEnabled; // true
  final String label; // widget
  final String? labelPadding; // EdgeInsets.symmetric(horizontal: 8.0)
  final String? labelStyle; // TextStyle(color: Colors.grey.shade700)
  final String? materialTapTargetSize; // MaterialTapTargetSize.shrinkWrap
  final Map<String, dynamic>? choices; // ['option1', 'option2', 'option3']
  final String? onSelected; // (bool value) {}
  final String? padding; // EdgeInsets.all(4.0)
  final double? pressElevation; // 0
  final bool selected; // false
  final String? selectedColor; // Colors.blue.shade100
  final String? selectedShadowColor; // Colors.blue.shade100
  final double? sequence;
  final String? shadowColor; // Colors.blue.shade100
  final String? shape; // RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0))
  final String? side; //BorderSide(color: Colors.grey.shade400, width: 1.0)
  final String? tooltip; // null
  final String? visulalDensity;

  const FieldChoiceChip({
    /// Boolean value.
    this.autofocus,
    required this.type,

    /// Widget to display as the avatar.
    /// specified within quotes.
    this.avatar,

    /// Border to draw around the avatar.
    /// ex: 'BoxBorder.all(width: 2.0, color: Colors.grey.shade400)'
    this.avatarBorder,

    /// Background color of the chip.
    /// specified within quotes.
    this.backgroundColor,

    /// How to clip the chip's content.
    /// ex:'Clip.none'
    this.clipBehavior,
    this.disabledColor,

    /// integer value
    /// ex: 5
    this.elevation,
    this.focusNode,

    /// Boolean value. Default is 'true'.
    this.isEnabled,
    required this.label,
    this.labelPadding,
    this.labelStyle,
    this.materialTapTargetSize,
    this.onSelected,
    this.choices,
    this.padding,
    this.pressElevation,
    required this.selected,
    this.selectedColor,
    this.selectedShadowColor,
    this.sequence,
    this.shadowColor,
    this.shape,
    this.side,
    this.tooltip,
    this.visulalDensity,
  }); // VisualDensity.adaptivePlatformDensity

}

/// Filter chips use tags or descriptive words as a way to filter content.

/// Filter chips are a good alternative to Checkbox or Switch widgets. Unlike these alternatives, filter chips allow for clearly delineated and exposed options in a compact area.
class FieldFilterChip {
  /// Optional. default is 'false'
  final bool? autofocus;
  final String type; // basically: enum/any other type

  /// widget for avatar within quotes
  final String? avatar; // widget
  /// Border around avatar
  /// ShapeBorder, within quotes
  final String? avatarBorder; // ShapeBorder
  final String? backgroundColor; // Colors.white
  final String? clipBehavior; // Clip.none
  final String? disabledColor; // Colors.grey.shade400
  final double? elevation; // 0
  final String? focusNode; // FocusNode()
  final bool? isEnabled; // true
  final String? label; // widget
  final String? labelPadding; // EdgeInsets.symmetric(horizontal: 8.0)
  final String? labelStyle; // TextStyle(color: Colors.grey.shade700)
  final String? materialTapTargetSize; // MaterialTapTargetSize.shrinkWrap
  final Map<String, dynamic>? choices; // ['option1', 'option2', 'option3']
  final String? onSelected; // (bool value) {}
  final String? padding; // EdgeInsets.all(4.0)
  final double? pressElevation; // 0
  final bool? selected; // false
  final String? selectedColor; // Colors.blue.shade100
  final String? selectedShadowColor; // Colors.blue.shade100
  final double? sequence;
  final String? shadowColor; // Colors.blue.shade100
  final String? shape; // RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0))
  final String? side; //BorderSide(color: Colors.grey.shade400, width: 1.0)
  final String? tooltip; // null
  final String? visulalDensity;

  const FieldFilterChip({
    /// Boolean value.
    this.autofocus,
    required this.type,

    /// Widget to display as the avatar.
    /// specified within quotes.
    this.avatar,

    /// Border to draw around the avatar.
    /// ex: 'BoxBorder.all(width: 2.0, color: Colors.grey.shade400)'
    this.avatarBorder,

    /// Background color of the chip.
    /// specified within quotes.
    this.backgroundColor,

    /// How to clip the chip's content.
    /// ex:'Clip.none'
    this.clipBehavior,
    this.disabledColor,

    /// integer value
    /// ex: 5
    this.elevation,
    this.focusNode,

    /// Boolean value. Default is 'true'.
    this.isEnabled,
    this.label,
    this.labelPadding,
    this.labelStyle,
    this.materialTapTargetSize,
    this.onSelected,
    this.choices,
    this.padding,
    this.pressElevation,
    this.selected,
    this.selectedColor,
    this.selectedShadowColor,
    this.sequence,
    this.shadowColor,
    this.shape,
    this.side,
    this.tooltip,
    this.visulalDensity,
  }); // VisualDensity.adaptivePlatformDensity

}

//*****************************
//  Nested field
//*****************************/
/// Nested field is a field that contains other fields.
/// The Fields are defined in the properties property.
///
/// This is useful in cases where you want to group fields together, for example an address field containing street, city, state, zip, etc.
class FieldClass {
  /// List of fields - the field properites
  /// like annotation, type, label, hint, enabled, inputDecoration, validators, initialValue, etc., are defines in a map.
  final List<Map<String, dynamic>> properties; // {annotation, type, label, hint, enabled, inputDecoration, validators, initialValue}
  final String? label;
  final String? hint;
  final double? sequence;
  const FieldClass({required this.properties, this.label, this.hint, this.sequence});
}

/// Displays a grid of days for a given month and allows the user to select a date.
///
/// Days are arranged in a rectangular grid with one column for each day of the week. Controls are provided to change the year and month that the grid is showing Use this with DateTime fields to input dates.
///
/// All properties are optional.
/// [initialDate] is set to current date if not provided.
/// [firstDate] is set to  current date if not provided.
/// [lastDate] is set to firstDate if provided else  current date if not provided.
class FieldDatePicker {
  final bool? autofocus; //
  final String? errorFormatText; // 'Invalid date format'
  final String? errorInvalidText; // 'Invalid date'
  final String? fieldHintText; // 'Date'
  final String? fieldLabelText; // 'Date'
  final String? selectableDayPredicate;
  final String? firstDate; // DateTime.toIso8601String()
  final String? lastDate; // DateTime.toIso8601String()
  final String? initialDate; // DateTime.toIso8601String()
  const FieldDatePicker(
      {this.autofocus,
      this.errorFormatText,
      this.errorInvalidText,
      this.fieldHintText,
      this.fieldLabelText,
      this.selectableDayPredicate,
      this.firstDate,
      this.lastDate,
      this.initialDate});
}

/// @FieldDateRangePicker() allows picking a range of dates
/// All properties are optional. All dates are 'yyyy-MM-dd'
/// [initialDate] is set to current date if not provided.
/// [firstDate] is set to 25 years before current date if not provided.
/// [lastDate] is set to 25 years after current date if not provided.
/// [initialDateRange] ia string in "yyyy-MM-dd, yyyy-MM-dd" format specifies the initial date range.
/// if not provided it is set to "[firstDate], [lastDate]""
class FieldDateRangePicker {
  final String? label;
  final String? helpText; // 'Select a date range'
  final String? cancelText; // 'Cancel'
  final String? confirmText; // 'Confirm'
  final String? saveText; // 'Save'
  final String? errorFormatText; // 'Invalid date format'
  final String? errorInvalidText; // 'Invalid date'
  final String? errorInvalidRangeText; // 'Invalid date range'
  final String? fieldStartHintText; // 'Start date'
  final String? fieldEndHintText; // 'End date'
  final String? fieldStartLabelText; // 'Start date'
  final String? fieldEndLabelText; // 'End date'
  final String? locale; // Locale
  final Map<String, dynamic>? routeSettings; // Class RouteSettings
  final String? textDirection; // TextDirection.ltr
  final String? firstDate; // DateTime.toIso8601String()
  final String? lastDate; // DateTime.toIso8601String()
  final String? initialDateRange; // DateTime.toIso8601String(), DateTime.toIso8601String()

  const FieldDateRangePicker(
      {this.label,
      this.helpText,
      this.cancelText,
      this.confirmText,
      this.saveText,
      this.errorFormatText,
      this.errorInvalidText,
      this.errorInvalidRangeText,
      this.fieldStartHintText,
      this.fieldEndHintText,
      this.fieldStartLabelText,
      this.fieldEndLabelText,
      this.locale,
      this.routeSettings,
      this.textDirection,
      this.firstDate,
      this.lastDate,
      this.initialDateRange});
}

/// A dropdown button lets the user select from a number of items. The button shows the currently selected item as well as an arrow that opens a menu for selecting another item.
///
/// Each item is represented by a [DropdownMenuItem] widget. The type  is the type of the values/keys used to identify each menu item and determine which item is currently selected. The type of the value is the type of the value associated with each menu item.
///
/// The dropdown button itself does not maintain the current value. Instead, when the user selects an item, the dropdown button calls the [onChanged] callback. Most widgets that use a dropdown button will listen for the [onChanged] callback and rebuild the dropdown button with a new [value] to update the currently selected item.
class FieldDropdown {
  final String? label;
  final String? hint;
  final bool? enabled;
  final String type; // enum, text, number, email, password, phone, date, time, dateTime, dateTimeLocal, month, week, time, color
  final List<Map<String, dynamic>>? options;
  final dynamic initialValue;
  final double? sequence;

  const FieldDropdown({
    this.label,
    this.hint,
    this.enabled,
    required this.type,
    this.options,
    this.initialValue,
    this.sequence,
  });
}

/// Shows a dropdown field hiding the underline.
class FieldDropdownHideUnderline {
  final String? label;
  final String? hint;
  final bool? enabled;
  final Map<String, dynamic>? inputDecoration;
  final String type; // enum, text, number, email, password, phone, date, time, dateTime, dateTimeLocal, month, week, time, color
  final List<Map<String, dynamic>>? options;
  final dynamic initialValue;
  final double? sequence;

  const FieldDropdownHideUnderline(
      {this.label, this.hint, this.enabled, this.inputDecoration, required this.type, this.options, this.initialValue, this.sequence});
}

/// A Material Design radio button.
///
/// Used to select between a number of mutually exclusive values. When one radio button in a group is selected, the other radio buttons in the group cease to be selected. The values are of type T, the type parameter of the Radio class. Enums are commonly used for this purpose.
///
/// The radio button itself does not maintain any state. Instead, selecting the radio invokes the onChanged callback, passing value as a parameter. If groupValue and value match, this radio will be selected. Most widgets will respond to onChanged by calling State.setState to update the radio button's groupValue.
class FieldRadio {
  final String type; // type
  final String? activeColor;
  final bool? autofocus;
  final String? fillColor, focusColor, focusNode, groupValue, hoverColor, materialTapTargetSize, mouseCursor, onChanged, overlayColor;
  final double? splashRadius;
  final bool? toggleable;
  final String? value, visualDensity;

  FieldRadio(this.type, this.activeColor, this.autofocus, this.fillColor, this.focusColor, this.focusNode, this.groupValue, this.hoverColor,
      this.materialTapTargetSize, this.mouseCursor, this.onChanged, this.overlayColor, this.splashRadius, this.toggleable, this.value, this.visualDensity);
}

/// Used to select a range of values within a set of values.
class FieldRangeSlider {
  final String? activeColor;
  final int? divisions;
  final String? inactiveColor;
  final String? labels; // comma separated labels
  final String? fieldLabel;
  final bool? suffix; // if true show current values
  final String? onChanged, OnChangeStart, OnChangeEnd, semanticFormatter;

  final Map<String, dynamic>?
      sliderThemeData; // [labelTextStyle, activeTrackColor, inactiveTrackColor, activeTickMarkColor, inactiveTickMarkColor, thumbColor, overlayColor, valueIndicatorColor, thumbShape, valueIndicatorShape, showValueIndicator]
  final double start, end, max, min;

  const FieldRangeSlider({
    this.activeColor,
    this.divisions,
    this.inactiveColor,
    this.labels,
    this.fieldLabel,
    this.suffix,
    required this.start,
    required this.end,
    required this.max,
    required this.min,
    this.onChanged,
    this.OnChangeStart,
    this.OnChangeEnd,
    this.semanticFormatter,
    this.sliderThemeData,
  });
}

/// Used to select a single value from a range of values.
class FieldSlider {
  final String? activeColor;
  final bool? autoFocus;
  final int? divisions;
  final String? focusNode;
  final String? inactiveColor;
  final String? label;
  final double? start, end;
  final double max, min;
  final String? mouseCursor, onChanged, OnChangeStart, OnChangeEnd;
  final String? semanticFormatter;
  final bool? suffix;
  final String? thumbColor;
  final double? value;
  final Map<String, dynamic>? sliderThemeData;

  const FieldSlider({
    this.activeColor,
    this.autoFocus,
    this.divisions,
    this.focusNode,
    this.inactiveColor,
    this.label,
    required this.max,
    required this.min,
    this.start,
    this.end,
    this.mouseCursor,
    this.onChanged,
    this.OnChangeStart,
    this.OnChangeEnd,
    this.semanticFormatter,
    this.sliderThemeData,
    this.suffix,
    this.thumbColor,
    this.value,
  });
}

/// Switch is a two state button that can be either on or off.
class FieldSwitch {
  final String? label;
  final String? hint;
  final bool? enabled;
  final Map<String, dynamic>? inputDecoration;
  final String? type;
  final dynamic initialValue;
  final double? sequence;
  final String? icon;
  final int? iconSize;
  final String? iconTooltip;
  final String? iconTooltipPosition;
  final String? iconColor, colorActive, colorHover, colorDisabled, colorFocus, colorError;

  const FieldSwitch({
    this.label,
    this.hint,
    this.enabled,
    this.inputDecoration,
    this.type,
    this.initialValue,
    this.sequence,
    this.icon, // 'check_box_outline_blank', 'check_box', 'indeterminate_check_box', 'radio_button_unchecked', 'radio_button_checked', 'indeterminate_radio_button'
    this.iconSize,
    this.iconTooltip,
    this.iconTooltipPosition,
    this.iconColor,
    this.colorActive,
    this.colorHover,
    this.colorDisabled,
    this.colorFocus,
    this.colorError,
  });
}

/// @FieldText() decorator is used to decorate each Text, Number, Email, password or Phone
/// field in the form.
/// All properties are optional.
class FieldText {
  final String? label;
  final String? hint;
  final bool? enabled;
  final bool? readOnly;

  /// true for password field
  final bool? obscureText;

  /// [inputDecoration] map of properties tto decorate the field.
  /// for example {
  ///   'labelText': 'Label Text',
  ///   'hintText': 'Hint Text',
  ///   'errorText': 'Error Text',
  ///   'suffixIcon': Icon(Icons.search),
  ///   'border: OutlineInputBorder(),
  /// }
  final Map<String, dynamic>? inputDecoration;

  /// [type] Default is 'text', can be 'number', 'email', 'password', 'phone'
  final String? type;

  /// Several predefined validators can be used to validate the field.
  /// For example, [required] , [email]  please see the validators reference
  /// If you want to use your own validator, you can use [custom] type
  /// and add your own validator function. The function must return a null
  /// if the field is valid or a string with the error message if the field is invalid.
  final List<Map<FieldValidator, dynamic>>? validators;

  /// Default value of the field
  final dynamic initialValue;

  /// The sequence of the field in the form.
  /// If no sequence is provided, no specific order will be applied to the fields.
  final double? sequence;

  final bool? autocorrect;
  final bool? autofocus;
  final String? autovalidateMode;
  final String? autofillHints;
  final String? buildCounter;
  final String? cursorColor;
  final String? cursorRadius;
  final String? cursorWidth;
  final String? enableIMEPersonalizedLearning;
  final bool? enableInteractiveSelection;
  final bool? enableSuggestions;
  final bool? expands;
  final String? focusNode;
  final List<String>? inputFormatters;
  final String? keyboardAppearance;
  final String? keyboardType;
  final int? maxLength;
  final String? maxLengthEnforcement;
  final int? maxLines;
  final int? minLines;
  final String? mouseCursor;
  final String? obscuringCharacter;
  final String? onChanged;
  final String? scrollPadding;

  const FieldText(
      {this.label,
      this.autocorrect,
      this.autofocus,
      this.autofillHints,
      this.autovalidateMode,
      this.buildCounter,
      this.cursorColor,
      this.cursorRadius,
      this.cursorWidth,
      this.hint,
      this.enabled,
      this.enableIMEPersonalizedLearning,
      this.enableInteractiveSelection,
      this.enableSuggestions,
      this.expands,
      this.focusNode,
      this.initialValue,
      this.inputDecoration,
      this.inputFormatters,
      this.keyboardAppearance,
      this.keyboardType,
      this.maxLength,
      this.maxLengthEnforcement,
      this.maxLines,
      this.minLines,
      this.mouseCursor,
      this.obscureText,
      this.obscuringCharacter,
      this.onChanged,
      this.readOnly,
      this.scrollPadding,
      this.type,
      this.validators,
      this.sequence});
}

/// @FieldTextArea() decorator is used to decorate each TextArea field in the form.
/// All properties are optional.
class FieldTextArea {
  final String? label;
  final int? maxLines;
  final String? hint;
  final bool? enabled;
  final Map<String, dynamic>? inputDecoration;
  final String? type; // text, number, email, password, phone, date, time, dateTime, dateTimeLocal, month, week, time, color
  final List<Map<FieldValidator, dynamic>>? validators;
  final dynamic initialValue;
  final double? sequence;

  const FieldTextArea({this.label, this.maxLines, this.hint, this.enabled, this.inputDecoration, this.type, this.validators, this.initialValue, this.sequence});
}

/// @FormBuilder is the decorator used to generate a form from a class.
/// [allowNullorEmpty] if set to true allows the form to save with empty or null values.
/// [needScaffold] if set to true will generate a scaffold with a form, otherwise the form will be generated
/// as a widget.

class FormBuilder {
  final bool allowNullorEmpty;
  final bool needScaffold;
  final dynamic platform;
  const FormBuilder({
    this.allowNullorEmpty = false,
    this.needScaffold = true,
    this.platform,
  });
}
