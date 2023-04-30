// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';

import 'package:defines_cli/src/utils/get_environment.dart';

class RunCommand extends Command<int> {
  final Logger _logger;

  RunCommand({
    required logger,
  }) : _logger = logger;

  @override
  String get description => "Command to run a flutter project";

  @override
  String get name => "run";

  @override
  Future<int> run() async {
    final envs = await getAllEnvironments();
    // _logger.chooseOne<EnvironmentModel>("Choose an environment: ", choices: envs, display: (env) => env.name);
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

    final p = await Process.start('fvm', ["flutter", "run", "--flavor", "dev"]);

    await stdout.addStream(p.stdout);
    await stdout.addStream(p.stderr);

    return ExitCode.success.code;
  }
}
