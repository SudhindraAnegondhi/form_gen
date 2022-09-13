// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'profile.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Flutter Form Generator',
    theme: ThemeData(
      primarySwatch: Colors.amber,
    ),
    home: const Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // ignore: prefer_final_fields
  List<Profile> _profiles = [
    Profile(
      firstName: 'Rajesh',
      lastName: 'Kumar',
      profileType: ProfileType.personal,
      grade: Grades.executive,
      birthdate: DateTime.parse('2000-01-01'),
      email: 'rajest@personal.com',
      phone: '1234567890',
      journeyDates: '2000-01-01,2000-01-01',
      description: 'I am a programmer',
      salary: 40000,
      salaryRange: '40000,80000',
      address: Address(
        street: '123 Main St',
        city: 'Bangalore',
        state: 'Karnataka',
        postcode: 'X570037',
      ),
      website: 'https://rajeshkumar.com',
      avatar: 'https://i.pravatar.cc/300',
    )
  ];

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Gen Example'),
      ),
      body: SizedBox(
        height: 900,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _profiles.length,
                itemBuilder: (context, index) {
                  final profile = _profiles[index];
                  return Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: ListTile(
                        leading: FittedBox(
                          fit: BoxFit.contain,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(profile.avatar),
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusColor: Theme.of(context).primaryColor,
                        tileColor: Theme.of(context).backgroundColor.withOpacity(0.3),
                        title: Text(profile.firstName + ' ' + profile.lastName),
                        subtitle: Text(profile.email),
                        trailing: const Icon(Icons.keyboard_arrow_right),
                        onTap: () async {
                          final response = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: ProfileForm(
                                  model: profile,
                                  showAppBar: false,
                                ),
                              ),
                            ),
                          );
                          if (response is Profile) {
                            setState(() {
                              _profiles[index] = response;
                            });
                          }
                        }),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final response = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ProfileForm(),
            ),
          );
          if (response is Profile) {
            setState(() {
              _profiles.add(response);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}


