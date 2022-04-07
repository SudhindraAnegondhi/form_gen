import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_form_annotations/flutter_form_annotations.dart';
// generated part
part 'profile.g.dart';

//@GenerateSubForm()
@JsonSerializable()
class Address {
  
  String? street;
  String? city;
  String? state;
  String? postcode;

  Address({
     this.street,
     this.city,
     this.state,
     this.postcode,
  });
  
  factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);
  Map<String, dynamic> toJson() => _$AddressToJson(this);
}
enum ProfileType {
  personal,
  professional,
}
/// This annotation tells the form generator to generate a form for this class.
/// The form will be generated in the `ProfileScreen` class.
/// The defs parameter is a map of FormFieldDefs.
/// This can be used to tell the generator to generate a custom form field
/// for a specific field.
/// Validators can also be specified for each field.
/// The validators are function names in the form_field_validators package or 
/// function body for custom validators.
/// 
/// Please note that the defs is  json object, enclosd in quotes - thus a 
/// string. Make sure that the defs is valid json.
/// 
/// 
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
  static Profile empty() {
    return Profile(
      name: '',
      profileType: ProfileType.personal,
      email: '',
      phone: '',
      address: Address(
        street: '',
        city: '',
        state: '',
        postcode: '',
      ),
      about: '',
      avatar: '',
    );
  }

  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}
