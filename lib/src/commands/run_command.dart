import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:defines_cli/src/models/vscode_config_model.dart';
import 'package:mason_logger/mason_logger.dart';

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
    final List<String> processArgs = ["flutter", "run"];

    final envs = await getAllEnvironments();

    if (envs.isNotEmpty) {
      EnvironmentModel selectedEnv;

      if (Platform.isMacOS) {
        selectedEnv = _logger.chooseOne<EnvironmentModel>("Choose an environment: ", choices: envs, display: (env) => env.name);
      } else {
        for (int i = 0; i < envs.length; i++) {
          print("[${i + 1}] ${envs[i].name}");
        }
        int? selectedEnvIndex;
        do {
          final response = _logger.prompt("Select environment to run: ");
          int? parseAttempt = int.tryParse(response);
          if (parseAttempt != null && parseAttempt > 0 && parseAttempt <= envs.length) {
            selectedEnvIndex = int.parse(response) - 1;
          } else {
            _logger.alert("Invalid environment! Select a number from 1 to ${envs.length}");
          }
        } while (selectedEnvIndex == null);

        selectedEnv = envs[selectedEnvIndex];
      }

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
