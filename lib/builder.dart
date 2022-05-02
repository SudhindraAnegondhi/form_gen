// ignore_for_file: lines_longer_than_80_chars

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'src/form_builder.dart';
import 'src/field_generators/field_generators.dart';

Builder formBuilder(BuilderOptions options) => SharedPartBuilder([FormBuilderGenerator(), FieldTextBuilder()], 'form_builder');

Builder fieldTextBuilder(BuilderOptions options) => SharedPartBuilder([FieldTextBuilder()], 'field_text_builder');

Builder fieldCheckboxBuilder(BuilderOptions options) => SharedPartBuilder([FieldCheckboxBuilder()], 'field_checkbox_builder');

Builder fieldChoiceChipBuilder(BuilderOptions options) => SharedPartBuilder([FieldChoiceChipBuilder()], 'field_choice_chip_builder');

Builder fieldDateRangePickerBuilder(BuilderOptions options) => SharedPartBuilder([FieldDateRangePickerBuilder()], 'field_date_range_picker_builder');

Builder fieldDateTimePickerBuilder(BuilderOptions options) => SharedPartBuilder([FieldDateTimePickerBuilder()], 'field_date_time_picker_builder');

Builder fieldDropdownBuilder(BuilderOptions options) => SharedPartBuilder([FieldDropdownBuilder()], 'field_dropdown_builder');

Builder fieldFilterChipBuilder(BuilderOptions options) => SharedPartBuilder([FieldFilterChipBuilder()], 'field_filter_chip_builder');

Builder fieldRadioBuilder(BuilderOptions options) => SharedPartBuilder([FieldRadioBuilder()], 'field_radio_group_builder');

Builder fieldRangeSliderBuilder(BuilderOptions options) => SharedPartBuilder([FieldRangeSliderBuilder()], 'field_range_slider_builder');

Builder fieldSwitchBuilder(BuilderOptions options) => SharedPartBuilder([FieldSwitchBuilder()], 'field_switch_builder');

Builder fieldTextAreaBuilder(BuilderOptions options) => SharedPartBuilder([FieldTextAreaBuilder()], 'field_text_area_builder');

Builder fieldClassBuilder(BuilderOptions options) => SharedPartBuilder([FieldClassBuilder()], 'field_class_builder');
