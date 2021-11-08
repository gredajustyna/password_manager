import 'dart:ui';

import 'package:totp_new_version/password_manager/src/domain/entities/password_model.dart';
import 'package:totp_new_version/password_manager/src/domain/entities/password_tile_model.dart';

abstract class PasswordRepository{

  Future<List<PasswordModel>> getAllPasswords();

  Future<String?> getPasswordFromStorage(PasswordModel model);

  Future<void> addPasswordToStorage(Map<String, String> password);

  Future<int> getId();

  Future<void> deletePassword(PasswordModel model);

  Future<List<PasswordModel>> searchPassword(String textToSearch);

  Future<String?> getPin();

  Future<void> setPin(String pin);

  Future<String> showPassword(PasswordTileModel model);

  Future<void> editPassword(Map<String, String> password);

}