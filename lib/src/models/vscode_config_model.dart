import 'package:equatable/equatable.dart';

class VscodeConfigModel extends Equatable {
  final List<EnvironmentModel> configs;

  VscodeConfigModel({
    required this.configs,
  });

  factory VscodeConfigModel.fromMap(Map<String, dynamic> map) {
    return VscodeConfigModel(
      configs: List<EnvironmentModel>.from(
        map['configurations'].map<EnvironmentModel>(
          (x) => EnvironmentModel.fromMap(x),
        ),
      ),
    );
  }

  @override
  List<Object> get props => [configs];

  @override
  bool get stringify => true;

  VscodeConfigModel copyWith({
    List<EnvironmentModel>? configs,
  }) {
    return VscodeConfigModel(
      configs: configs ?? this.configs,
    );
  }
}

class EnvironmentModel extends Equatable {
  final String name;
  final List<String> args;

  EnvironmentModel({
    required this.name,
    required this.args,
  });

  factory EnvironmentModel.fromMap(Map<String, dynamic> map) {
    final args = map["args"].cast<String>();

    return EnvironmentModel(
      name: map["name"],
      args: args,
    );
  }

  @override
  List<Object> get props => [name, args];

  @override
  bool get stringify => true;
}
