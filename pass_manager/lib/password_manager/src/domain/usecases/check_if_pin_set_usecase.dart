
import 'package:totp_new_version/password_manager/src/core/usecases/future_usecase.dart';
import 'package:totp_new_version/password_manager/src/domain/repositories/password_repository.dart';

class CheckIfPinSetUseCase extends FutureUseCase<bool, void>{
  PasswordRepository _passwordRepository;
  CheckIfPinSetUseCase(this._passwordRepository);

  @override
  Future<bool> call({void params}) async{
    final pin = await _passwordRepository.getPin();
    if(pin == null){
      return false;
    }else{
      return true;
    }
  }

}