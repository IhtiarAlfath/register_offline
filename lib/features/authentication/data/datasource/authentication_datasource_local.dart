import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:register_offline/core/error/failures.dart';
import 'package:register_offline/core/success/success.dart';
import 'package:register_offline/core/utils/app_constants.dart';
import 'package:register_offline/features/authentication/data/models/data_login_model.dart';
import 'package:register_offline/features/authentication/domain/entities/data_login.dart';

abstract class AuthenticationDatasourceLocal {
  Future<GeneralSuccess> cacheDataLogin(DataLogin dataLogin);
  Future<DataLoginModel> getLastDataLogin();
  Future<GeneralSuccess> deleteDataLogin();


}

class AuthenticationDatasourceLocalImpl
    implements AuthenticationDatasourceLocal {
  final Box authBox;
  final FlutterSecureStorage secureStorage;

  AuthenticationDatasourceLocalImpl({
    required this.authBox,
    required this.secureStorage,
  });

  @override
  Future<GeneralSuccess> cacheDataLogin(DataLogin dataLogin) async {
    try {
      final model = DataLoginModel(
        token: dataLogin.token,
      );
      await authBox.put(AppConstants.userDataKey, jsonEncode(model.toJson()));
      await secureStorage.write(
          key: AppConstants.secureTokenKey, value: dataLogin.token);
      return const GeneralSuccess(message: 'success cache data login');
    } catch (e) {
      throw const CacheException(message: 'cannot cache data login');
    }
  }

  @override
  Future<DataLoginModel> getLastDataLogin() async {
    try {
      final data = authBox.get(AppConstants.userDataKey);
      if (data == null) {
        throw const CacheException(message: 'No cached login data');
      }
      return DataLoginModel.fromJson(jsonDecode(data));
    } catch (e) {
      throw const CacheException(message: 'cannot get cached login data');
    }
  }

  @override
  Future<GeneralSuccess> deleteDataLogin() async {
    try {
      await authBox.delete(AppConstants.userDataKey);
      await secureStorage.delete(key: AppConstants.secureTokenKey);
      return const GeneralSuccess(message: 'success delete data login');
    } catch (e) {
      throw const CacheException(message: 'cannot delete data login');
    }
  }
}
