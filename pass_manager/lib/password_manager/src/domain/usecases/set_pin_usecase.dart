import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:totp_new_version/password_manager/src/core/usecases/future_usecase.dart';
import 'package:totp_new_version/password_manager/src/domain/repositories/password_repository.dart';

class SetPinUseCase extends FutureUseCase<bool, String>{
  PasswordRepository _passwordRepository;
  SetPinUseCase(this._passwordRepository);


  @override
  Future<bool> call({required String params}) async {
    final alphanumeric = RegExp("[0-9]{4}");
    if(alphanumeric.hasMatch(params)){
      var bytes = utf8.encode(params);
      var hash = sha256.convert(bytes);
      await _passwordRepository.setPin(hash.toString());
      return true;
    }else{
      return false;
    }

  }

}