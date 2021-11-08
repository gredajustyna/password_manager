
import 'package:totp_new_version/password_manager/src/core/usecases/future_usecase.dart';
import 'package:totp_new_version/password_manager/src/domain/repositories/password_repository.dart';

class EditPasswordUseCase implements FutureUseCase<void, Map<String, String>>{
  PasswordRepository _passwordRepository;
  EditPasswordUseCase(this._passwordRepository);
  @override
  Future<void> call({required Map<String, String> params}) async{
    await _passwordRepository.editPassword(params);
  }

}