// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter_form_annotations/flutter_form_annotations.dart';
import 'model_visitor.dart';

void validateDefs(Map<String, dynamic> defs, ModelVisitor visitor) {
  for (final key in defs.keys) {
    if (!visitor.fields.containsKey(key) && !isMeta(key)) {
      throw ArgumentError('Field "$key" is not defined in the model.');
    }
    if (key == '__sequence') {
      if (defs[key] == null || defs[key] is! List || defs[key].length == 0) {
        throw ArgumentError('Meta field "$key" must contain field names.');
      }
      if (defs[key].length != visitor.fields.keys.length) {
        throw ArgumentError('Meta field "$key" must contain the same number of field names as the model.');
      }
      // check that all visitor.fields are present in meta[keys]
      for (final field in defs[key]) {
        if (!visitor.fields.containsKey(field)) {
          throw ArgumentError('Field "$field" is not defined in the model.');
        }
      }
      // check that all meta[keys] are present in visitor.fields
      for (final field in visitor.fields.keys) {
        if (defs[key].contains(field) == false) {
          throw ArgumentError('Field "$field" is not defined in the meta.');
        }
      }
      continue;
    }
    if (defs[key] is! Map<String, dynamic>) {
      throw ArgumentError('Field "$key" has no attributes.');
    }
    if ((defs[key]['type'] ?? '') == 'object' && defs[key].containsKey('properties') == false) {
      throw ArgumentError('Field "$key" is an object type but has no properties.');
    }
    for (final String attr in defs[key]) {
      if (!isValidAttribute(attr)) {
        throw ArgumentError('Field "$key" has an invalid attribute "$attr".');
      }
      if (attr == 'fieldType') {
        if (!isValidFieldType(defs[key][attr].toString())) {
          throw ArgumentError('Field "$key" has an invalid fieldType "${defs[key][attr]}".');
        }
        if (mustHaveValues(defs[key][attr].toString()) && defs[key].containsKey('values') == false) {
          throw ArgumentError('Field "$key" has a fieldType "${defs[key][attr]}" but no values.');
        }
        final fieldType = FormFieldType.values.firstWhere((e) => e.toString().split('.').last == defs[key][attr].toString());
        if(!hasSubAttributes(defs, fieldType, key)) {
          throw ArgumentError('Field "$key" has a fieldType "${defs[key][attr]}" but no sub attributes.');
        }
      }
    }
  }
}
