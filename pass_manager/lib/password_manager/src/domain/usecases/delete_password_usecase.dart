
import 'package:totp_new_version/password_manager/src/core/usecases/future_usecase.dart';
import 'package:totp_new_version/password_manager/src/domain/entities/password_model.dart';
import 'package:totp_new_version/password_manager/src/domain/repositories/password_repository.dart';

class DeletePasswordUseCase extends FutureUseCase<void, PasswordModel>{
  PasswordRepository _passwordRepository;
  DeletePasswordUseCase(this._passwordRepository);

  @override
  Future<void> call({required PasswordModel params}) async{
    await _passwordRepository.deletePassword(params);
  }

}