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

  Future<GeneralSuccess> cacheDataLoginParameter(
      DataLoginParameter dataLoginParameter);
  Future<DataLoginParameter?> getLastDataLoginParameter();
  Future<GeneralSuccess> deleteCacheDataLoginParameter();

  Future<GeneralSuccess> cacheRememberMe(
      DataLoginParameter dataLoginParameter);
  Future<DataLoginParameter?> getRememberMe();
  Future<GeneralSuccess> deleteCacheRememberMe();
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

  @override
  Future<GeneralSuccess> cacheDataLoginParameter(
      DataLoginParameter dataLoginParameter) async {
    try {
      final data = jsonEncode({
        'email': dataLoginParameter.email,
        'password': dataLoginParameter.password,
      });
      await authBox.put('login_param', data);
      return const GeneralSuccess(message: 'success cache login param');
    } catch (e) {
      throw const CacheException(message: 'cannot cache login param');
    }
  }

  @override
  Future<DataLoginParameter?> getLastDataLoginParameter() async {
    try {
      final data = authBox.get('login_param');
      if (data == null) return null;
      final json = jsonDecode(data);
      return DataLoginParameter(
        email: json['email'],
        password: json['password'],
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<GeneralSuccess> deleteCacheDataLoginParameter() async {
    try {
      await authBox.delete('login_param');
      return const GeneralSuccess(message: 'success delete login param');
    } catch (e) {
      throw const CacheException(message: 'cannot delete login param');
    }
  }

  @override
  Future<GeneralSuccess> cacheRememberMe(
      DataLoginParameter dataLoginParameter) async {
    try {
      final data = jsonEncode({
        'email': dataLoginParameter.email,
        'password': dataLoginParameter.password,
      });
      await secureStorage.write(key: 'remember_me', value: data);
      return const GeneralSuccess(message: 'success cache remember me');
    } catch (e) {
      throw const CacheException(message: 'cannot cache remember me');
    }
  }

  @override
  Future<DataLoginParameter?> getRememberMe() async {
    try {
      final data = await secureStorage.read(key: 'remember_me');
      if (data == null) return null;
      final json = jsonDecode(data);
      return DataLoginParameter(
        email: json['email'],
        password: json['password'],
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<GeneralSuccess> deleteCacheRememberMe() async {
    try {
      await secureStorage.delete(key: 'remember_me');
      return const GeneralSuccess(message: 'success delete remember me');
    } catch (e) {
      throw const CacheException(message: 'cannot delete remember me');
    }
  }
}
