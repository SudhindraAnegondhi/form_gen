// ignore_for_file: prefer_const_declarations

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'profile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Form Example',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const ProfileScreen(
          add: true,
        ));
  }
}

Future<Widget> getImage() async {
  final Completer<Widget> completer = Completer();
  const url = 'https://picsum.photos/900/600';
  final image = const NetworkImage(url);
  // final config = await image.obtainKey();
  final load = image.resolve(const ImageConfiguration());

  final listener = ImageStreamListener((ImageInfo info, isSync) async {
    if (kDebugMode) {
      print(info.image.width);
      print(info.image.height);
    }

    if (info.image.width == 80 && info.image.height == 160) {
      completer.complete(const Text('AZAZA'));
    } else {
      completer.complete(Image(image: image));
    }
  });

  load.addListener(listener);
  return completer.future;
}
