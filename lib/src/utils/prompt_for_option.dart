import 'dart:io';

import 'package:mason_logger/mason_logger.dart';

T promptForOption<T extends Object?>(
  Logger _logger,
  String message,
  List<T> choices,
  String Function(T choice) display,
) {
  T selected;
  if (Platform.isMacOS) {
    selected = _logger.chooseOne<T>("${message}: ", choices: choices, display: display);
  } else {
    _logger.write("Available environments: ");
    for (int i = 0; i < choices.length; i++) {
      _logger.write("[${i + 1}] ${display(choices[i])}");
    }
    int? selectedEnvIndex;
    do {
      String msg = message;
      if (choices.length > 1) {
        msg += "[1-${choices.length}]:";
      }
      final response = _logger.prompt(msg);
      int? parseAttempt = int.tryParse(response);
      if (parseAttempt != null && parseAttempt > 0 && parseAttempt <= choices.length) {
        selectedEnvIndex = int.parse(response) - 1;
      }
    } while (selectedEnvIndex == null);

    selected = choices[selectedEnvIndex];
  }

  return selected;
}
