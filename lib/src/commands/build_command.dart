// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:equatable/equatable.dart';
import 'package:mason_logger/mason_logger.dart';

import 'package:flux_cli/src/utils/get_environment.dart';

import '../models/vscode_config_model.dart';
import '../utils/check_if_its_a_flutter_project.dart';
import '../utils/prompt_for_option.dart';

class BuildCommand extends Command<int> {
  final Logger _logger;

  BuildCommand({required logger}) : _logger = logger;

  static const List<BuildTarget> buildTargets = [
    BuildTarget(name: "Android AppBundle", code: "appbundle"),
    BuildTarget(name: "Android APK", code: "apk"),
    BuildTarget(name: "iOS Archive", code: "ipa"),
  ];

  @override
  String get description => "Command to build a flutter app";

  @override
  String get name => "build";

  @override
  Future<int> run() async {
    checkIfItsAFlutterProject();

    final List<String> processArgs = ["flutter", "build"];

    if (buildTargets.isNotEmpty) {
      final selectedTarget = promptForOption<BuildTarget>(
        _logger,
        "Select the target to build project",
        buildTargets,
        (choice) => choice.name,
      );

      processArgs.add(selectedTarget.code);
    }

    final envs = await getAllEnvironments();

    if (envs.isNotEmpty) {
      final selectedEnv = promptForOption<EnvironmentModel>(
        _logger,
        "Choose an environment",
        envs,
        (choice) => choice.name,
      );

      processArgs.addAll(selectedEnv.args);
    }

    final process = await Process.start("fvm", processArgs);

    process.stdout.listen((event) {
      _logger.write(utf8.decode(event));
    });
    process.stderr.listen((event) {
      _logger.err(utf8.decode(event));
    });

    await process.stdin.addStream(stdin);

    return ExitCode.success.code;
  }
}

class BuildTarget extends Equatable {
  final String name;
  final String code;

  const BuildTarget({
    required this.name,
    required this.code,
  });

  @override
  List<Object> get props => [name, code];

  @override
  bool get stringify => true;
}
