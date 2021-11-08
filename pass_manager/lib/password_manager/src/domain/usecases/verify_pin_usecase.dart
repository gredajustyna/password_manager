import 'package:crypto/crypto.dart';
import 'package:convert/convert.dart';
import 'package:totp_new_version/password_manager/src/core/usecases/future_usecase.dart';
import 'dart:convert';

import 'package:totp_new_version/password_manager/src/domain/repositories/password_repository.dart';

class VerifyPinUseCase extends FutureUseCase<bool, String>{
  PasswordRepository _passwordRepository;

  VerifyPinUseCase(this._passwordRepository);

  @override
  Future<bool> call({required String params}) async{
    final pin = await _passwordRepository.getPin();
    var bytes = utf8.encode(params);
    if(sha256.convert(bytes).toString() == pin){
      return true;
    }else{
      return false;
    }
  }

}