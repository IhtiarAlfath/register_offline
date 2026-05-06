import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:register_offline/core/error/failures.dart';
import 'package:register_offline/core/utils/app_constants.dart';
import 'package:register_offline/features/profile/domain/entities/user_profile.dart';

abstract class ProfileDatasourceRemoteAbstract {
  Future<UserProfile> getProfile(String token);
}

class ProfileDatasourceRemoteImpl implements ProfileDatasourceRemoteAbstract {
  final http.Client client;

  ProfileDatasourceRemoteImpl({required this.client});

  @override
  Future<UserProfile> getProfile(String token) async {
    try {
      final response = await client.get(
        Uri.parse('${AppConstants.baseUrl}/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return UserProfile(
          id: json['id']?.toString() ?? '',
          fullName: json['full_name'] as String? ?? '',
          email: json['email'] as String? ?? '',
        );
      } else {
        throw const ServerException(message: 'Gagal mengambil profil');
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Get profile error: ${e.toString()}');
    }
  }
}
