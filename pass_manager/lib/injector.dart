import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';
import 'package:totp_new_version/password_manager/src/data/repositories/password_repository_impl.dart';
import 'package:totp_new_version/password_manager/src/domain/repositories/password_repository.dart';
import 'package:totp_new_version/password_manager/src/domain/usecases/add_password_usecase.dart';
import 'package:totp_new_version/password_manager/src/domain/usecases/check_if_pin_set_usecase.dart';
import 'package:totp_new_version/password_manager/src/domain/usecases/delete_password_usecase.dart';
import 'package:totp_new_version/password_manager/src/domain/usecases/edit_password_usecase.dart';
import 'package:totp_new_version/password_manager/src/domain/usecases/get_all_passwords_usecase.dart';
import 'package:totp_new_version/password_manager/src/domain/usecases/hide_password_usecase.dart';
import 'package:totp_new_version/password_manager/src/domain/usecases/retrieve_icon_usecase.dart';
import 'package:totp_new_version/password_manager/src/domain/usecases/search_password_usecase.dart';
import 'package:totp_new_version/password_manager/src/domain/usecases/set_pin_usecase.dart';
import 'package:totp_new_version/password_manager/src/domain/usecases/show_password_usecase.dart';
import 'package:totp_new_version/password_manager/src/domain/usecases/verify_pin_usecase.dart';
import 'package:totp_new_version/password_manager/src/presentation/blocs/add_password_bloc/add_password_bloc.dart';
import 'package:totp_new_version/password_manager/src/presentation/blocs/password_bloc/password_bloc.dart';
import 'package:totp_new_version/password_manager/src/presentation/blocs/pin_bloc/pin_bloc.dart';
import 'package:totp_new_version/password_manager/src/presentation/blocs/retrieve_icon_bloc/retrieve_icon_bloc.dart';
import 'package:totp_new_version/password_manager/src/presentation/blocs/search_password_bloc/search_password_bloc.dart';
import 'package:totp_new_version/password_manager/src/presentation/blocs/show_password_bloc/show_password_bloc.dart';

import 'password_manager/src/data/datasources/database_service.dart';

final injector = GetIt.instance;

Future<void> initializeDependencies() async {
  final databaseService = DatabaseService.db;
  final database = await databaseService.initDB();
  final storage = new FlutterSecureStorage();
  final iv = IV.fromLength(16);
  storage.write(key: 'iv', value: iv.toString());

  injector.registerSingleton<Database>(database);
  injector.registerSingleton<FlutterSecureStorage>(storage);
  injector.registerSingleton<PasswordRepository>(PasswordRepositoryImpl(injector(), injector()));

  injector.registerSingleton<GetAllPasswordsUseCase>(GetAllPasswordsUseCase(injector()));
  injector.registerSingleton<AddPasswordUseCase>(AddPasswordUseCase(injector()));
  injector.registerSingleton<DeletePasswordUseCase>(DeletePasswordUseCase(injector()));
  injector.registerSingleton<SearchPasswordUseCase>(SearchPasswordUseCase(injector()));
  injector.registerSingleton<RetrieveIconUseCase>(RetrieveIconUseCase());
  injector.registerSingleton<CheckIfPinSetUseCase>(CheckIfPinSetUseCase(injector()));
  injector.registerSingleton<SetPinUseCase>(SetPinUseCase(injector()));
  injector.registerSingleton<VerifyPinUseCase>(VerifyPinUseCase(injector()));
  injector.registerSingleton<ShowPasswordUseCase>(ShowPasswordUseCase(injector()));
  injector.registerSingleton<HidePasswordUseCase>(HidePasswordUseCase());
  injector.registerSingleton<EditPasswordUseCase>(EditPasswordUseCase(injector()));

  injector.registerFactory<PasswordBloc>(() => PasswordBloc(injector(), injector(), injector(), injector()));
  injector.registerFactory<AddPasswordBloc>(() => AddPasswordBloc(injector()));
  injector.registerFactory<SearchPasswordBloc>(() => SearchPasswordBloc(injector()));
  injector.registerFactory<RetrieveIconBloc>(() => RetrieveIconBloc(injector()));
  injector.registerFactory<AddPinBloc>(() => AddPinBloc(injector()));
  injector.registerFactory<CheckPinBloc>(() => CheckPinBloc(injector()));
  injector.registerFactory<VerifyPinBloc>(() => VerifyPinBloc(injector()));
  injector.registerFactory<ShowPasswordBloc>(() => ShowPasswordBloc(injector(), injector(), injector()));
}