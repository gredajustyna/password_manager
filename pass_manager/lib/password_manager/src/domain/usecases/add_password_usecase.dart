import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:totp_new_version/password_manager/src/core/usecases/future_usecase.dart';
import 'package:totp_new_version/password_manager/src/domain/entities/password_model.dart';
import 'package:totp_new_version/password_manager/src/domain/repositories/password_repository.dart';

class AddPasswordUseCase extends FutureUseCase<void, Map<String, String>>{
  PasswordRepository _passwordRepository;
  AddPasswordUseCase(this._passwordRepository);

  @override
  Future<void> call({required Map<String, String> params}) async{
    await _passwordRepository.addPasswordToStorage(params);

  }

}