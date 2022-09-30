

# Form_Gen

## Features

**form_gen** generates a form given a model. The model is decorated with `@FormBuilder` decoration and `@FieldXXXX` field decorations for each screen item and `build_runner` is run from the shell prompt to generate the form. The generated form and json operations to serialize and deserialize the model are generated and placed in a file with 'g.dart' extension.

![](https://user-images.githubusercontent.com/58779402/171086363-d1cd68b9-36c1-4e6f-867e-6f1e73592545.png)  ![](https://user-images.githubusercontent.com/58779402/171087386-a9b9f4af-c43c-4982-a539-3c378ecd4819.png) 
![ ](https://user-images.githubusercontent.com/58779402/171087454-f7081a8d-3bdf-4718-ae66-28bc6701cd21.png)  ![](https://user-images.githubusercontent.com/58779402/171087539-e0ba91e2-4973-4a9c-ad2a-c095e09175c6.png) |
 ![6](https://user-images.githubusercontent.com/58779402/171087816-2c217cb5-3480-4be9-968a-eeb6907449da.png)


## Getting started

delete example/lib/profile.g.dart

## Usage

open integrated teminal and issue the following command

```sh
$ flutter pub run build_runner build --delete-conflicting-outputs
```

This step generates example/lib/profile.g.dart containing the code for the Profile screen `ProfileForm()` widget.

## Using Form Gen

The Form Gen package is used in conjunction with following packages.

1. [Json Serializable](https://pub.dev/packages/json_serializable)
2. [Json Annotation](https://pub.dev/packages/json_annotation)

The Json packages are used (to quote):

"To generate to/from JSON code for a class, annotate it with JsonSerializable. You can provide arguments to JsonSerializable to configure the generated code. You can also customize individual fields by annotating them with JsonKey and providing custom arguments. See the table below for details on the annotation values.

To generate a Dart field with the contents of a file containing JSON, use the JsonLiteral annotation.
"


### Import the package

```dart
import 'package:json_annotation/json_annotation.dart';
import 'package:form_gen/form_gen.dart';
```

### decorate the model class

```dart
@JsonSerializable()
@FormBuilder(
  platform: TargetPlatform.iOS,
)
class Profile {

    // decorate each field
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
  ...
}
  ```

## Field Types Supported

The following Form Field types are supported:
1. CheckBox
2. ChoiceChip
3. Class - Groups fields together to support sub-fields
4. DateRangePicker
5. DateTimePicker
6. DropdownHideUnderline
7. Dropdown
8. FilterChip
9. Radio
10. Slider
11. Switch
12. TextArea
13. Text


Each field has a number of properties (invariably the same ones the the corresponding Flutter Widget has). See API Documentation for further info