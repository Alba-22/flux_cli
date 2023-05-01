import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:defines_cli/src/utils/check_if_its_a_flutter_project.dart';
import 'package:defines_cli/src/utils/prompt_for_option.dart';
import 'package:mason_logger/mason_logger.dart';

import 'package:defines_cli/src/models/vscode_config_model.dart';
import 'package:defines_cli/src/utils/get_environment.dart';

class RunCommand extends Command<int> {
  final Logger _logger;

  RunCommand({
    required logger,
  }) : _logger = logger {
    argParser.addOption(
      "device",
      abbr: "d",
      help: "Specify the device id to run the flutter application",
      mandatory: false,
    );
  }

  @override
  String get description => "Command to run a flutter app";

  @override
  String get name => "run";

  @override
  Future<int> run() async {
    checkIfItsAFlutterProject();

    final List<String> processArgs = ["flutter", "run"];

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

    // TODO: Add listing of devices
    // |_ Get devices from "fvm flutter devices" command
    // |_ Check folders on flutter project(android, ios, etc.)
    // |_ Show only devices compatible with that folders

    final String? deviceId = argResults?["device"];
    if (deviceId != null) {
      processArgs.add("-d${deviceId.trim()}");
    }

    final process = await Process.start("fvm", processArgs);

    process.stdout.listen((event) {
      final data = utf8.decode(event);
      stdout.write(data);
    });

    await process.stdin.addStream(stdin);

    return ExitCode.success.code;
  }
}
