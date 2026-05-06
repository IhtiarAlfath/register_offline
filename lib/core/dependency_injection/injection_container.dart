import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:register_offline/core/services/network_services.dart';
import 'package:register_offline/core/utils/app_constants.dart';
import 'package:register_offline/features/authentication/data/datasource/authentication_datasource_local.dart';
import 'package:register_offline/features/authentication/data/datasource/authentication_datasource_remote.dart';
import 'package:register_offline/features/authentication/data/repositories/authentication_repositories_impl.dart';
import 'package:register_offline/features/authentication/domain/repositories/authentication_repositories.dart';
import 'package:register_offline/features/authentication/domain/usecases/cache_data_login.dart';
import 'package:register_offline/features/authentication/domain/usecases/get_cached_data_login.dart';
import 'package:register_offline/features/authentication/domain/usecases/login.dart';
import 'package:register_offline/features/authentication/domain/usecases/logout.dart';
import 'package:register_offline/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:register_offline/features/member/data/datasource/member_datasource_local.dart';
import 'package:register_offline/features/member/data/datasource/member_datasource_remote.dart';
import 'package:register_offline/features/member/data/models/member_local_model.dart';
import 'package:register_offline/features/member/data/repositories/member_repositories_impl.dart';
import 'package:register_offline/features/member/domain/repositories/member_repositories.dart';
import 'package:register_offline/features/member/domain/usecases/member_usecases.dart';
import 'package:register_offline/features/member/presentation/bloc/member_bloc.dart';
import 'package:register_offline/features/profile/data/datasource/profile_datasource_remote.dart';
import 'package:register_offline/features/profile/data/repositories/profile_repositories_impl.dart';
import 'package:register_offline/features/profile/presentation/bloc/profile_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(MemberLocalModelAdapter());
  }

  final authBox = await Hive.openBox(AppConstants.authBox);
  final memberBox = await Hive.openBox<MemberLocalModel>(AppConstants.memberBox);

  serviceLocator.registerLazySingleton(() => authBox);
  serviceLocator.registerLazySingleton(() => memberBox);

  serviceLocator.registerLazySingleton(() => http.Client());
  serviceLocator.registerLazySingleton(() => const FlutterSecureStorage());
  serviceLocator.registerLazySingleton(() => Connectivity());

  serviceLocator.registerLazySingleton<NetworkServices>(
    () => NetworkServicesImpl(connectivity: serviceLocator.call()),
  );

  serviceLocator.registerLazySingleton<AuthenticationDatasourceLocal>(
    () => AuthenticationDatasourceLocalImpl(
      authBox: serviceLocator.call(),
      secureStorage: serviceLocator.call(),
    ),
  );
  serviceLocator.registerLazySingleton<AuthenticationDatasourceRemote>(
    () => AuthenticationDatasourceRemoteImpl(client: serviceLocator.call()),
  );

  serviceLocator.registerLazySingleton<AuthenticationRepositories>(
    () => AuthenticationRepositoriesImpl(
      authenticationDatasourceRemote: serviceLocator.call(),
      authenticationDatasourceLocal: serviceLocator.call(),
      networkServices: serviceLocator.call(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => Login(authenticationRepositories: serviceLocator.call()),
  );
  serviceLocator.registerLazySingleton(
    () => Logout(authenticationRepositories: serviceLocator.call()),
  );
  serviceLocator.registerLazySingleton(
    () => GetCachedDataLogin(authenticationRepositories: serviceLocator.call()),
  );
  serviceLocator.registerLazySingleton(
    () => CacheDataLogin(authenticationRepositories: serviceLocator.call()),
  );

  serviceLocator.registerFactory(
    () => AuthenticationBloc(
      login: serviceLocator.call(),
      logout: serviceLocator.call(),
    ),
  );

  serviceLocator.registerLazySingleton<MemberDatasourceLocal>(
    () => MemberDatasourceLocalImpl(memberBox: serviceLocator.call()),
  );
  serviceLocator.registerLazySingleton<MemberDatasourceRemote>(
    () => MemberDatasourceRemoteImpl(client: serviceLocator.call()),
  );

  serviceLocator.registerLazySingleton<MemberRepositories>(
    () => MemberRepositoriesImpl(
      memberDatasourceLocal: serviceLocator.call(),
      memberDatasourceRemote: serviceLocator.call(),
      networkServices: serviceLocator.call(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => SaveMemberLocal(memberRepositories: serviceLocator.call()),
  );
  serviceLocator.registerLazySingleton(
    () => UpdateMemberLocal(memberRepositories: serviceLocator.call()),
  );
  serviceLocator.registerLazySingleton(
    () => GetDraftMembers(memberRepositories: serviceLocator.call()),
  );
  serviceLocator.registerLazySingleton(
    () => UploadMember(memberRepositories: serviceLocator.call()),
  );
  serviceLocator.registerLazySingleton(
    () => GetRemoteMembers(memberRepositories: serviceLocator.call()),
  );
  serviceLocator.registerLazySingleton(
    () => SyncAllDrafts(memberRepositories: serviceLocator.call()),
  );
  serviceLocator.registerLazySingleton(
    () => DeleteMemberLocal(memberRepositories: serviceLocator.call()),
  );

  serviceLocator.registerFactory(
    () => MemberBloc(
      saveMemberLocal: serviceLocator.call(),
      updateMemberLocal: serviceLocator.call(),
      getDraftMembers: serviceLocator.call(),
      uploadMember: serviceLocator.call(),
      getRemoteMembers: serviceLocator.call(),
      syncAllDrafts: serviceLocator.call(),
      deleteMemberLocal: serviceLocator.call(),
    ),
  );

  serviceLocator.registerLazySingleton<ProfileDatasourceRemoteImpl>(
    () => ProfileDatasourceRemoteImpl(client: serviceLocator.call()),
  );
  serviceLocator.registerLazySingleton<ProfileRepositoriesImpl>(
    () => ProfileRepositoriesImpl(
      profileDatasourceRemote: serviceLocator<ProfileDatasourceRemoteImpl>(),
      networkServices: serviceLocator.call(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => GetProfile(
      profileRepositories: serviceLocator<ProfileRepositoriesImpl>(),
    ),
  );
  serviceLocator.registerFactory(
    () => ProfileBloc(getProfile: serviceLocator.call()),
  );
}
