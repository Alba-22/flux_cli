import 'dart:io';

import '../errors/not_in_a_flutter_project_exception.dart';

void checkIfItsAFlutterProject() {
  final pubspecFile = File("pubspec.yaml");

  final exists = pubspecFile.existsSync();

  if (!exists) {
    throw NotInAFlutterProjectException();
  }
}
