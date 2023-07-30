import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:flux_cli/src/errors/building_exception.dart';
import 'package:flux_cli/src/errors/deploying_exception.dart';
import 'package:mason_logger/mason_logger.dart';

import '../models/vscode_config_model.dart';
import '../utils/check_if_its_a_flutter_project.dart';
import '../utils/get_environment.dart';
import '../utils/prompt_for_option.dart';

class DeployCommand extends Command<int> {
  final Logger _logger;

  DeployCommand({required logger}) : _logger = logger;

  @override
  String get description => "Command to deploy Android and iOS using Fastlane";

  @override
  String get name => "deploy";

  @override
  Future<int> run() async {
    checkIfItsAFlutterProject();

    final envs = await getAllEnvironments();

    if (envs.isEmpty) {
      _logger.err("You must have an environment in launch.json");

      return ExitCode.usage.code;
    }
    final selectedEnv = promptForOption<EnvironmentModel>(
      _logger,
      "Choose an environment",
      envs,
      (choice) => choice.name,
    );

    await _buildAndroid(selectedEnv);
    await _buildIOS(selectedEnv);
    await _deployAndroid(selectedEnv);
    await _deployIOS(selectedEnv);

    return ExitCode.success.code;
  }

  Future<void> _buildAndroid(EnvironmentModel selectedEnv) async {
    if (Directory("android").existsSync()) {
      final progress = _logger.progress("Building for Android");

      final process = await Process.run(
        "fvm",
        ["flutter", "build", "appbundle", ...selectedEnv.args],
      );

      if (process.exitCode != 0) {
        progress.fail("There was an error building for Android");
        throw BuildingException(process.stderr);
      }

      progress.complete("Built for Android successfully!");
    } else {
      _logger.warn("Android project not found! Skipping build...", tag: "⚠️ ");
    }
  }

  Future<void> _buildIOS(EnvironmentModel selectedEnv) async {
    if (Directory("ios").existsSync()) {
      final progress = _logger.progress("Building for iOS");

      final process = await Process.run(
        "fvm",
        ["flutter", "build", "ipa", ...selectedEnv.args],
      );

      if (process.exitCode != 0) {
        progress.fail("There was an error building for iOS");
        throw BuildingException(process.stderr);
      }

      progress.complete("Built for iOS successfully!");
    } else {
      _logger.warn("iOS project not found! Skipping build...", tag: "⚠️ ");
    }
  }

  Future<void> _deployAndroid(EnvironmentModel selectedEnv) async {
    if (Directory("android/fastlane").existsSync()) {
      final progress = _logger.progress("Deploying to Android with Fastlane");

      final process = await Process.run(
        "bundle",
        workingDirectory: "android",
        ["exec", "fastlane", "deploy_${selectedEnv.name}"],
      );

      if (process.exitCode != 0) {
        progress.fail("There was an error deploying to Android");
        throw DeployingException(process.stderr);
      }

      progress.complete("Deployed to Android successfully!");
    } else {
      _logger.warn("Fastlane configuration for Android not found! Skipping...", tag: "⚠️ ");
    }
  }

  Future<void> _deployIOS(EnvironmentModel selectedEnv) async {
    if (Directory("ios/fastlane").existsSync()) {
      final progress = _logger.progress("Deploying to iOS with Fastlane");
      final process = await Process.run(
        "bundle",
        workingDirectory: "ios",
        ["exec", "fastlane", "deploy_${selectedEnv.name}"],
      );

      if (process.exitCode != 0) {
        progress.fail("There was an error deploying to iOS");
        throw DeployingException(process.stderr);
      }

      progress.complete("Deployed to iOS successfully!");
    } else {
      _logger.warn("Fastlane configuration for iOS not found! Skipping...", tag: "⚠️ ");
    }
  }
}
