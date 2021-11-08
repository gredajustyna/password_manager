
import 'package:totp_new_version/password_manager/src/core/usecases/future_usecase.dart';
import 'package:totp_new_version/password_manager/src/domain/entities/password_tile_model.dart';
import 'package:totp_new_version/password_manager/src/domain/repositories/password_repository.dart';

class SearchPasswordUseCase extends FutureUseCase<List<PasswordTileModel>, String>{
  PasswordRepository _passwordRepository;
  SearchPasswordUseCase(this._passwordRepository);

  @override
  Future<List<PasswordTileModel>> call({required String params}) async{
    final passwords = await _passwordRepository.searchPassword(params);
    final tilePasswords = passwords.map((e) => new PasswordTileModel(passwordModel: e, password: '', imgPath: '', isPasswordVisible: false)).toList();
    for(PasswordTileModel model in tilePasswords){
      model.password = (await _passwordRepository.getPasswordFromStorage(model.passwordModel))!;
  }
    return tilePasswords;
  }

}