import 'dart:convert';
import 'dart:io';

import 'package:flux_cli/src/errors/invalid_launch_file_exception.dart';

import '../models/vscode_config_model.dart';

Future<List<EnvironmentModel>> getAllEnvironments() async {
  try {
    final launchFile = File(".vscode/launch.json");

    // In the future, if file doesn't exists
    // search for equivalent of android studio before returning an empty list
    if (!launchFile.existsSync()) {
      return [];
    }

    final stringContent = await launchFile.readAsString();

    return VscodeConfigModel.fromMap(jsonDecode(stringContent)).configs;
  } on FormatException {
    throw InvalidLaunchFileException();
  }
}
