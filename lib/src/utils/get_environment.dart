import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import '../models/vscode_config_model.dart';

Future<EnvironmentModel> getEnvironmentFromName(String envName) async {
  final launchFile = File(".vscode/launch.json");

  final stringContent = await launchFile.readAsString();

  final configs = VscodeConfigModel.fromMap(jsonDecode(stringContent)).configs;

  for (final config in configs) {
    if (config.name == envName) {
      return config;
    }
  }

  throw Exception();
}

Future<List<EnvironmentModel>> getAllEnvironments() async {
  final launchFile = File(".vscode/launch.json");

  final stringContent = await launchFile.readAsString();

  final configs = VscodeConfigModel.fromMap(jsonDecode(stringContent)).configs;

  return configs;
}
