
import 'package:totp_new_version/password_manager/src/core/usecases/future_usecase.dart';
import 'package:totp_new_version/password_manager/src/domain/entities/password_model.dart';
import 'package:totp_new_version/password_manager/src/domain/entities/password_tile_model.dart';
import 'package:totp_new_version/password_manager/src/domain/repositories/password_repository.dart';

class ShowPasswordUseCase extends FutureUseCase<String, PasswordTileModel>{
  PasswordRepository _passwordRepository;
  ShowPasswordUseCase(this._passwordRepository);

  @override
  Future<String> call({required PasswordTileModel params}) async{
   String password = await _passwordRepository.showPassword(params);
   return password;
  }


}