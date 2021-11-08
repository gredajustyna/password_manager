
import 'package:totp_new_version/password_manager/src/core/usecases/future_usecase.dart';
import 'package:totp_new_version/password_manager/src/domain/entities/password_tile_model.dart';
import 'package:totp_new_version/password_manager/src/domain/repositories/password_repository.dart';

class GetAllPasswordsUseCase implements FutureUseCase<List<PasswordTileModel>, void>{
  PasswordRepository _passwordRepository;
  GetAllPasswordsUseCase(this._passwordRepository);

  @override
  Future<List<PasswordTileModel>> call({void params}) async{
    final passwords = await _passwordRepository.getAllPasswords();
    final tilePasswords = passwords.map((e) => new PasswordTileModel(passwordModel: e, password: '', imgPath: '', isPasswordVisible: false)).toList();
    for(PasswordTileModel model in tilePasswords){
      model.password = (await _passwordRepository.getPasswordFromStorage(model.passwordModel))!;
    }
    return tilePasswords;
  }

}