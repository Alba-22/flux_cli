import 'dart:convert';
import 'dart:io';

import '../models/vscode_config_model.dart';

Future<List<EnvironmentModel>> getAllEnvironments() async {
  // TODO: Check if launch.json file exists
  // e.g. CLI must support projects that doesn't have dart-defines approach
  // In the future, if file doesn't exists, search for equivalent of android studio

  final launchFile = File(".vscode/launch.json");

  final stringContent = await launchFile.readAsString();

  return VscodeConfigModel.fromMap(jsonDecode(stringContent)).configs;
}
