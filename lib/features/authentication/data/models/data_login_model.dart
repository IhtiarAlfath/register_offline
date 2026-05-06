import 'package:register_offline/features/authentication/domain/entities/data_login.dart';

class DataLoginModel extends DataLogin {
  const DataLoginModel({
    required super.token,
  });

  factory DataLoginModel.fromJson(Map<String, dynamic> json) {
    return DataLoginModel(
      token: json['token'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
    };
  }
}
