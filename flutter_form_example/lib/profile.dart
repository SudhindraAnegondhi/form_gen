import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_form_annotations/flutter_form_annotations.dart';
// generated part
part 'profile.g.dart';

//@GenerateSubForm()
@JsonSerializable()
class Address {
  final String street;
  final String city;
  final String state;
  final String postcode;

  Address({
    required this.street,
    required this.city,
    required this.state,
    required this.postcode,
  });

  factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);
  Map<String, dynamic> toJson() => _$AddressToJson(this);
}

enum ProfileType {
  personal,
  professional,
}

/// @GenerateForm decorator can be used with any class
/// The decorator generates a flutter form for all the properties
/// of the class.
///
/// The form generation is controlled by the defs String.
/// [defs] is a json string that defines the property.
///
/// All the class properties will be generated as text fields unless modified by
/// an explicit  definition.
///
/// The following are the supported annotation attributes to a class proerty:
///
/// [type] - the dart type of the property.
///
/// [typeDefinition] - For Classes/Enums the class or enum name.
///
/// [fieldType] - the kind of form field to be generated. By default it will be a text field. Allowed kinds are:
/// - textField
/// - textArea
/// - dropdown
/// - radio
/// - checkbox
/// - date
/// - time
/// - datePicker
/// - password
/// - imagePicker
/// - filePicker
/// - switch
///
/// [options] - the options for the dropdown/switch/radio field. This is optional for enums, unless custom labels are required.  The options are defined as a List of Maps. Each map has the following keys:
/// - value - the value of the option
/// - label - the label of the option - if the label is not specified, the value will be used as the label.
///
/// The class may have objects as properties. the object's properties can be annotated with the same attributes as the class properties.
///
/// [hide] - if true, the property will not be generated in the form.
/// [readOnly] - if true, the property will be read only in the form.
/// [specifed] - if true only those properties will be generated that are explicitly annotated as specified.
/// [required] - if true, the property will be required in the form.
/// [validators] - a list of validators to be applied to the property.  The validators are defined as a List of Maps. Each map has the following keys:
/// - name - the library name of the validator from the flutter_form_validation package or the name of a custom validator.
/// - customValidator - the custom validator function. Must return null if the validation is successful.
///  - message - the error message to be displayed if the validation fails. This can be omitted if the validator has a default message.

@GenerateForm(defs: '''
{
  "profileType": {
    "type": "radio",
    "options": [
      {"value": "ProfileType.personal", "label": "Personal"},
      {"value": "ProfileType.professional", "label": "Professional"}
    ]
  },
  "address": {
    "type": "object",
    "properties": {
      "street": {"type": "string"},
      "city": {"type": "string"},
      "state": {"type": "string"},
      "postcode": {"type": "string"},
      "country": {"type": "string"}
    }
  }
}
''')
@JsonSerializable()
class Profile {
  final String name;
  final ProfileType profileType;
  final String email;
  final String phone;
  final Address address;
  final String about;
  final String avatar;

  Profile({
    required this.name,
    required this.profileType,
    required this.email,
    required this.phone,
    required this.address,
    required this.about,
    required this.avatar,
  });

  // return an empty profile

  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}
