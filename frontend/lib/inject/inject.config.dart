// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:frontend/bloc/user/user_bloc.dart' as _i990;
import 'package:frontend/core/network/dio_module.dart' as _i339;
import 'package:frontend/core/network/protected_api_service.dart' as _i365;
import 'package:frontend/core/network/registration_api_service.dart' as _i436;
import 'package:frontend/db/db_client.dart' as _i569;
import 'package:frontend/db/db_modulte.dart' as _i788;
import 'package:frontend/features/auth/domain/auth_repository.dart' as _i887;
import 'package:frontend/features/auth/view/bloc/auth_cubit.dart' as _i1034;
import 'package:frontend/features/auth/view/bloc/login/login_bloc.dart'
    as _i805;
import 'package:frontend/features/auth/view/bloc/signup/signup_bloc.dart'
    as _i917;
import 'package:frontend/features/letters/bloc/letters_bloc.dart' as _i861;
import 'package:frontend/features/todo/domain/todo_repository.dart' as _i739;
import 'package:frontend/features/todo/view/bloc/todo_bloc.dart' as _i955;
import 'package:frontend/features/user/domain/user_repository.dart' as _i935;
import 'package:frontend/features/ws_counter/domain/ws_client.dart' as _i83;
import 'package:frontend/features/ws_counter/domain/ws_manager.dart' as _i129;
import 'package:frontend/features/ws_counter/view/bloc/counter_bloc.dart'
    as _i545;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final dbClientModule = _$DbClientModule();
    final dioModule = _$DioModule();
    gh.factory<_i990.UserBloc>(() => _i990.UserBloc());
    gh.lazySingleton<_i83.WebSocketClient>(() => _i83.WebSocketClient());
    gh.lazySingleton<_i129.WsCounterRepository>(
      () => _i129.WsCounterRepository(),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i129.WsLettersRepository>(
      () => _i129.WsLettersRepository(),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i569.DbClient>(() => dbClientModule.dbClient);
    gh.lazySingleton<_i361.Dio>(
      () => dioModule.retryDio(),
      instanceName: 'retryDio',
    );
    gh.lazySingleton<_i569.DbClient>(
      () => dbClientModule.memoryDbClient,
      instanceName: 'Memory',
    );
    gh.lazySingleton<_i129.WsManager>(
      () => _i129.WsManager(
        gh<_i129.WsCounterRepository>(),
        gh<_i129.WsLettersRepository>(),
      ),
      dispose: (i) => i.dispose(),
    );
    gh.lazySingleton<_i361.Dio>(
      () => dioModule.registrationDio(),
      instanceName: 'registration',
    );
    gh.lazySingleton<_i935.UserRepository>(() => _i935.UserRepositoryImpl());
    gh.factory<_i861.LettersBloc>(
      () => _i861.LettersBloc(
        gh<_i129.WsLettersRepository>(),
        gh<_i129.WsManager>(),
      ),
    );
    gh.factory<_i545.CounterBloc>(
      () => _i545.CounterBloc(
        gh<_i129.WsCounterRepository>(),
        gh<_i129.WsManager>(),
      ),
    );
    gh.lazySingleton<_i436.RegistrationApiService>(
      () => _i436.RegistrationApiService(
        gh<_i361.Dio>(instanceName: 'registration'),
      ),
    );
    gh.lazySingleton<_i887.AuthRepository>(
      () => _i887.AuthRepositoryImpl(
        gh<_i436.RegistrationApiService>(),
        gh<_i569.DbClient>(),
      ),
      dispose: (i) => i.dispose(),
    );
    gh.factory<_i1034.AuthCubit>(
      () => _i1034.AuthCubit(gh<_i887.AuthRepository>()),
    );
    gh.factory<_i917.SignupBloc>(
      () => _i917.SignupBloc(gh<_i887.AuthRepository>()),
    );
    gh.factory<_i805.LoginBloc>(
      () => _i805.LoginBloc(gh<_i887.AuthRepository>()),
    );
    gh.lazySingleton<_i361.Dio>(
      () => dioModule.dio(
        gh<_i887.AuthRepository>(),
        gh<_i361.Dio>(instanceName: 'retryDio'),
      ),
      instanceName: 'withToken',
    );
    gh.lazySingleton<_i365.ProtectedApiService>(
      () => _i365.ProtectedApiService(gh<_i361.Dio>(instanceName: 'withToken')),
    );
    gh.lazySingleton<_i739.TodoRepository>(
      () => _i739.TodoRepositoryImpl(gh<_i365.ProtectedApiService>()),
    );
    gh.factory<_i955.TodoBloc>(
      () => _i955.TodoBloc(gh<_i739.TodoRepository>()),
    );
    return this;
  }
}

class _$DbClientModule extends _i788.DbClientModule {}

class _$DioModule extends _i339.DioModule {}
