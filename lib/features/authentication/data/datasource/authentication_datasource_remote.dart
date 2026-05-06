import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:register_offline/core/error/failures.dart';
import 'package:register_offline/core/utils/app_constants.dart';
import 'package:register_offline/features/authentication/data/models/data_login_model.dart';
import 'package:register_offline/features/authentication/domain/entities/data_login.dart';

abstract class AuthenticationDatasourceRemote {
  Future<DataLoginModel> login(DataLoginParameter dataLoginParameter);
}

class AuthenticationDatasourceRemoteImpl
    implements AuthenticationDatasourceRemote {
  final http.Client client;

  AuthenticationDatasourceRemoteImpl({required this.client});

  @override
  Future<DataLoginModel> login(DataLoginParameter dataLoginParameter) async {
    try {
      final response = await client.post(
        Uri.parse('${AppConstants.baseUrl}/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': dataLoginParameter.email,
          'password': dataLoginParameter.password,
        }),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return DataLoginModel.fromJson(json);
      } else if (response.statusCode == 401) {
        throw const ServerException(message: 'Email atau password salah');
      } else {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        throw ServerException(
            message: json['message'] ?? 'Terjadi kesalahan server');
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Login gagal: ${e.toString()}');
    }
  }
}
