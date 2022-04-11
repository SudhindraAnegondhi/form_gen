// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// FormGenerator
// **************************************************************************

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    Key? key,
    this.profile,
    required this.add,
    this.showAppBar = false,
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
  final Profile? profile;
  final bool add;
  final AppBar? appBar;
  final bool showAppBar;
  final Size? size;
  final TextStyle? textStyle;
  final Color? color;
  final Color? textColor;
  final Color? backgroundColor;
  final Image? backgroundImage;
  final BoxFit? backgroundImageFit;
  final TextStyle? headlineStyle;
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> modelMap = <String, dynamic>{};

  @override
  void initState() {
    super.initState();
    modelMap = widget.profile?.toJson() ?? <String, dynamic>{};
    initModel();
  }

  void initModel() {
    modelMap["name"] ??= '';
    modelMap["email"] ??= '';
    modelMap["phone"] ??= '';
    modelMap["address"] = <String, dynamic>{};
    modelMap["address"]["street"] ??= '';
    modelMap["address"]["city"] ??= '';
    modelMap["address"]["state"] ??= '';
    modelMap["address"]["postcode"] ??= '';
    modelMap["address"]["country"] ??= '';
    modelMap["about"] ??= '';
    modelMap["avatar"] ??= '';
  }

  double min(double a, double b) => a < b ? a : b;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar ? widget.appBar : null,
      body: Center(
        child: Container(
          width: widget.size?.width ?? MediaQuery.of(context).size.width * 0.8,
          height: widget.size?.height ??
              min(MediaQuery.of(context).size.height * 0.8, 7 * 85),
          color: widget.backgroundColor ?? Colors.white,
          child: Card(
            elevation: 15,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            shadowColor: Colors.black,
            child: SingleChildScrollView(
              child: FormBuilder(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        widget.add ? 'Add Profile' : 'Edit Profile',
                        style: widget.headlineStyle ??
                            Theme.of(context).textTheme.headline6,
                      ),
                      FormBuilderTextField(
                        name: 'name',
                        decoration: const InputDecoration(
                          labelText: 'Name',
                        ),
                        initialValue: modelMap["name"],
                        onChanged: (value) {
                          setState(() {
                            modelMap["name"] = value;
                          });
                        },
                      ),
                      FormBuilderTextField(
                        name: 'email',
                        decoration: const InputDecoration(
                          labelText: 'Email',
                        ),
                        initialValue: modelMap["email"],
                        onChanged: (value) {
                          setState(() {
                            modelMap["email"] = value;
                          });
                        },
                      ),
                      FormBuilderTextField(
                        name: 'phone',
                        decoration: const InputDecoration(
                          labelText: 'Phone',
                        ),
                        initialValue: modelMap["phone"],
                        onChanged: (value) {
                          setState(() {
                            modelMap["phone"] = value;
                          });
                        },
                      ),
                      FormBuilderTextField(
                        name: 'street',
                        decoration: const InputDecoration(
                          labelText: 'Street',
                        ),
                        initialValue: modelMap["address"]["street"],
                        onChanged: (value) {
                          setState(() {
                            modelMap["address"]["street"] = value;
                          });
                        },
                      ),
                      FormBuilderTextField(
                        name: 'city',
                        decoration: const InputDecoration(
                          labelText: 'City',
                        ),
                        initialValue: modelMap["address"]["city"],
                        onChanged: (value) {
                          setState(() {
                            modelMap["address"]["city"] = value;
                          });
                        },
                      ),
                      FormBuilderTextField(
                        name: 'state',
                        decoration: const InputDecoration(
                          labelText: 'State',
                        ),
                        initialValue: modelMap["address"]["state"],
                        onChanged: (value) {
                          setState(() {
                            modelMap["address"]["state"] = value;
                          });
                        },
                      ),
                      FormBuilderTextField(
                        name: 'postcode',
                        decoration: const InputDecoration(
                          labelText: 'Postcode',
                        ),
                        initialValue: modelMap["address"]["postcode"],
                        onChanged: (value) {
                          setState(() {
                            modelMap["address"]["postcode"] = value;
                          });
                        },
                      ),
                      FormBuilderTextField(
                        name: 'country',
                        decoration: const InputDecoration(
                          labelText: 'Country',
                        ),
                        initialValue: modelMap["address"]["country"],
                        onChanged: (value) {
                          setState(() {
                            modelMap["address"]["country"] = value;
                          });
                        },
                      ),
                      FormBuilderTextField(
                        name: 'about',
                        decoration: const InputDecoration(
                          labelText: 'About',
                        ),
                        initialValue: modelMap["about"],
                        onChanged: (value) {
                          setState(() {
                            modelMap["about"] = value;
                          });
                        },
                      ),
                      FormBuilderTextField(
                        name: 'avatar',
                        decoration: const InputDecoration(
                          labelText: 'Avatar',
                        ),
                        initialValue: modelMap["avatar"],
                        onChanged: (value) {
                          setState(() {
                            modelMap["avatar"] = value;
                          });
                        },
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
                              onPressed: formKey.currentState
                                          ?.saveAndValidate() ??
                                      false
                                  ? () {
                                      if (formKey.currentState
                                              ?.saveAndValidate() ??
                                          false) {
                                        Navigator.of(context)
                                            .pop(Profile.fromJson(modelMap));
                                      }
                                    }
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ), // column
                ), // padding
              ), // formBuilder
            ), // singleChildScrollView
          ), // card
        ), // container
      ), // center
    ); // scaffold
  } // build
} // class

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Address _$AddressFromJson(Map<String, dynamic> json) => Address(
      street: json['street'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      postcode: json['postcode'] as String,
    );

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'street': instance.street,
      'city': instance.city,
      'state': instance.state,
      'postcode': instance.postcode,
    };

Profile _$ProfileFromJson(Map<String, dynamic> json) => Profile(
      name: json['name'] as String,
      profileType: $enumDecode(_$ProfileTypeEnumMap, json['profileType']),
      email: json['email'] as String,
      phone: json['phone'] as String,
      address: Address.fromJson(json['address'] as Map<String, dynamic>),
      about: json['about'] as String,
      avatar: json['avatar'] as String,
    );

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'name': instance.name,
      'profileType': _$ProfileTypeEnumMap[instance.profileType],
      'email': instance.email,
      'phone': instance.phone,
      'address': instance.address,
      'about': instance.about,
      'avatar': instance.avatar,
    };

const _$ProfileTypeEnumMap = {
  ProfileType.personal: 'personal',
  ProfileType.professional: 'professional',
};
