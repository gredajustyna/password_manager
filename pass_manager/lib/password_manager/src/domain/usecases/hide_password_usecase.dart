
import 'package:totp_new_version/password_manager/src/core/usecases/usecase.dart';
import 'package:totp_new_version/password_manager/src/domain/entities/password_tile_model.dart';

class HidePasswordUseCase extends UseCase<void, PasswordTileModel>{
  @override
  void call({required PasswordTileModel params}) {
    params.isPasswordVisible = false;
    //params.password = '';
  }

}