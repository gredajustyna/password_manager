import 'package:totp_new_version/password_manager/src/domain/entities/password_model.dart';

class PasswordTileModel{
  PasswordModel passwordModel;
  String imgPath;
  String password;
  bool isPasswordVisible;

  PasswordTileModel({required this.passwordModel,required this.password, required this.imgPath, required this.isPasswordVisible});
}