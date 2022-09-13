import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:form_gen/form_gen.dart';


// generated part
part 'profile.g.dart';

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

  // _$AddressFromJson and _$AddressFromJson will show error until build_runner is run.
  factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);
  Map<String, dynamic> toJson() => _$AddressToJson(this);
}

enum ProfileType {
  personal,
  professional,
}

// handle 2.1.7 enhanced enum
enum Grades implements Comparable<Grades> {
  executive(description: 'Sr.Manager', salary: 100000),
  manager(description: 'Manager', salary: 50000),
  staff(description: 'Staff', salary: 30000),
  intern(description: 'Intern', salary: 10000);

  final String description;
  final int salary;

  const Grades({required this.description, required this.salary});

  @override
  int compareTo(Grades other) => salary - other.salary;
}

@JsonSerializable()
@FormBuilder(
  platform: TargetPlatform.iOS,
)
class Profile {
  @FieldText(
    label: 'First name',
    hint: 'Enter your first name',
    enabled: true,
    inputDecoration: {'label': 'First name', 'hint': 'Enter your first name', 'helper': 'We need your first name', 'error': 'Please enter your first name'},
    sequence: 0.0,
    validators: [
      {
        FieldValidator.required: {'message': '"Please enter your first name"'}
      },
    ],
  )
  final String firstName;

  @FieldText(
    label: 'Last name',
    hint: 'Enter your last name',
    enabled: true,
    inputDecoration: {'label': 'Last name', 'hint': 'Enter your last name', 'helper': 'We need your last name', 'error': 'Please enter your last name'},
    sequence: 1.0,
    validators: [
      {
        FieldValidator.required: {'message': 'Please enter your last name'}
      },
    ],
  )
  final String lastName;

  @FieldDropdown(
    type: 'enum',
    label: 'Grade',
  )
  final Grades grade;

  @FieldDatePicker(firstDate: '1945-01-01', lastDate: '2021-12-31', initialDate: '1945-01-01')
  final DateTime birthdate;

  @FieldText(
    label: 'Email',
    hint: 'Enter your email',
    enabled: true,
    inputDecoration: {'label': 'Email', 'hint': 'Enter your email', 'helper': 'We need your email', 'error': 'Please enter your email'},
    sequence: 2.0,
    validators: [
      {FieldValidator.required: {}},
      {FieldValidator.email: {}},
    ],
  )
  final String email;

  @FieldDropdown(label: 'Profile Type', type: 'enum')
  final ProfileType profileType;

  @FieldText(
    label: 'Phone',
    hint: 'Enter your phone number',
    enabled: true,
    inputDecoration: {'label': 'Phone', 'hint': 'Enter your phone number', 'helper': 'We need your phone number', 'error': 'Please enter your phone number'},
    sequence: 3.0,
    validators: [
      {FieldValidator.required: {}},
      {FieldValidator.phone: {}},
    ],
  )
  final String phone;

  @FieldSlider(
    label: 'Salary',
    autoFocus: true,
    min: 30000,
    max: 100000,
    start: 40000,
    end: 80000,
    divisions: 10,
    semanticFormatter: '''{
      return   "\${value.toStringAsFixed(2)} Dollars";
    }''',
  )
  final double salary;

  @FieldDateRangePicker()
  final String journeyDates;

  @FieldRangeSlider(
    fieldLabel: 'Salary Range',
    max: 120000.0,
    min: 30000.0,
    divisions: 10,
    suffix: true,
  )
  final String salaryRange;

  @FieldTextArea(maxLines: 4, validators: [
    {
      FieldValidator.required: {'message': 'Please enter your description'}
    },
  ])
  final String description;

  @FieldClass(
    properties: [
      {
        "name": "street",
        "type": "String",
        "annotation": "FieldText",
        "validators": [
          {
            FieldValidator.required: {"message": "Please enter your street"}
          }
        ]
      },
      {
        "name": "city",
        "type": "String",
        "annotation": "FieldText",
        "validators": [
          {
            FieldValidator.required: {"message": "Please enter your city"}
          }
        ]
      },
      {
        "name": "state",
        "type": "String",
        "annotation": "FieldText",
        "validators": [
          {
            FieldValidator.required: {"message": "Please enter your state"}
          },
          {
            FieldValidator.fixedLength: {"message": "Please enter 2 characters", "length": 2}
          }
        ]
      },
      {
        "name": "postcode",
        "type": "String",
        "annotation": "FieldText",
        "validators": [
          {
            FieldValidator.required: {"message": "Please enter your postcode"}
          },
          {
            FieldValidator.numeric: {"message": "Please enter a valid postcode"}
          }
        ]
      },
    ],
  )
  @JsonKey(fromJson: _addressFromJson, toJson: _addressToJson)
  final Address address;

  @FieldText(
    label: 'Website',
    hint: 'Enter your website',
    type: 'url',
    enabled: true,
    inputDecoration: {
      'label': 'Website',
      'hint': 'Enter your website',
      'helper': 'We need your website',
      'error': 'Please enter your website',
      'border': OutlineInputBorder(),
    },
    sequence: 4.0,
  )
  final String website;

  @FieldText(label: 'Avatar', type: 'String', initialValue: 'https://i.pravatar.cc/300')
  final String avatar;

  Profile({
    required this.firstName,
    required this.lastName,
    required this.profileType,
    required this.grade,
    required this.birthdate,
    required this.email,
    required this.phone,
    required this.journeyDates,
    required this.description,
    required this.address,
    required this.website,
    required this.salary,
    required this.salaryRange,
    required this.avatar,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileToJson(this);
  @override
  String toString() => json.encode(toJson());
}

Map<String, dynamic> _addressToJson(Address address) => address.toJson();
Address _addressFromJson(Map<String, dynamic> json) => Address.fromJson(json);
