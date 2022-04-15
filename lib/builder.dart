// ignore_for_file: lines_longer_than_80_chars


import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/form_generator.dart';
import 'src/generate_form.dart';
import 'src/lookup_generator.dart';

Builder generateForm(BuilderOptions options) => SharedPartBuilder([GenerateForm()], 'generate_form');

Builder formGenerator(BuilderOptions options) => SharedPartBuilder([FormGenerator()], 'form_generator');

Builder lookupGenerator(BuilderOptions options) => SharedPartBuilder([LookupGenerator()], 'lookup_generator');
