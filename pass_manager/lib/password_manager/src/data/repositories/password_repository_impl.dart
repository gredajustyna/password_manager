import 'dart:convert';
import 'dart:ui';

import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sqflite/sqflite.dart';
import 'package:totp_new_version/password_manager/src/domain/entities/password_model.dart';
import 'package:totp_new_version/password_manager/src/domain/entities/password_tile_model.dart';
import 'package:totp_new_version/password_manager/src/domain/repositories/password_repository.dart';

class PasswordRepositoryImpl implements PasswordRepository{
  final Database _database;
  final FlutterSecureStorage storage;
  PasswordRepositoryImpl(this._database, this.storage);

  @override
  Future<List<PasswordModel>> getAllPasswords() async{
    final db = _database;
    // Query the table for all The Passwords.
    final List<Map<String, dynamic>> maps = await db.query('passwords');
    // Convert the List<Map<String, dynamic> into a List<PasswordModel>.
    return List.generate(maps.length, (i) {
      return PasswordModel(
        uniqueId: maps[i]['uniqueId'],
        domain: maps[i]['domainName'],
        iv: maps[i]['iv'],
        username: maps[i]['username']
      );
    });
  }

  @override
  Future<String?> getPasswordFromStorage(PasswordModel model) async {
    var password = await storage.read(key: model.uniqueId.toString());
    return password;
  }

  @override
  Future<void> addPasswordToStorage(Map<String, String> password) async{
    final db = _database;
    var id = await getId();
    var iv = IV.fromSecureRandom(16);
    var pin = await getPin();
    final key = Key.fromUtf8('${pin!.substring(0,32)}');
    final encrypter = Encrypter(AES(key, padding: null));
    final encrypted = encrypter.encrypt(password['password']!, iv: iv);
    await storage.write(key: id.toString(), value: encrypted.base64);
    var res = await db.rawInsert(
        'INSERT INTO passwords (uniqueId, domainName, iv, username) VALUES (?, ?, ?, ?)',
        [id, password['domain'], iv.base64, password['username']]
    );
  }

  @override
  Future<int> getId() async{
    final db = _database;
    var id = -1;
    int? count = Sqflite.firstIntValue(await db.rawQuery('select count(*) from passwords'));
    if(count == 0){
      id = 12345;
    }else{
      var maxIdResult = await db.rawQuery("SELECT MAX(uniqueId)+1 as last_inserted_id FROM passwords");
      id = maxIdResult.first["last_inserted_id"] as int;
    }
    return id;
  }

  @override
  Future<void> deletePassword(PasswordModel model) async{
    final db = _database;
    var res = await db.rawDelete('DELETE FROM passwords WHERE uniqueId = ?',
        [model.uniqueId]
    );
    storage.delete(key: model.uniqueId.toString());
  }

  @override
  Future<List<PasswordModel>> searchPassword(String textToSearch) async{
    final db = _database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT * FROM passwords WHERE LOWER( domainName ) LIKE ?', ['%$textToSearch%']);
    // Convert the List<Map<String, dynamic> into a List<PasswordModel>.
    return List.generate(maps.length, (i) {
      return PasswordModel(
        uniqueId: maps[i]['uniqueId'],
        domain: maps[i]['domainName'],
        iv: maps[i]['iv']
      );
    });
  }

  @override
  Future<String?> getPin() {
    final pin = storage.read(key: 'pin');
    return pin;
  }

  @override
  Future<void> setPin(String pin) async{
    await storage.write(key: 'pin', value: pin);
  }

  @override
  Future<String> showPassword(PasswordTileModel model) async{
    print(model.passwordModel.domain);
    print(model.passwordModel.iv);
    print(model.passwordModel.uniqueId);
    var pin = await getPin();
    print(pin);
    final key = Key.fromUtf8('${pin!.substring(0,32)}');
    final encrypter = Encrypter(AES(key, padding: null));
    final password = await storage.read(key: model.passwordModel.uniqueId.toString());
    print('SHOW PASSWORD: $password');
    final decrypted = encrypter.decrypt(Encrypted.fromBase64(password!), iv: IV.fromBase64(model.passwordModel.iv));
    print(decrypted.toString());
    //model.password = decrypted.toString();
    model.isPasswordVisible = true;
    return decrypted.toString();
  }

  @override
  Future<void> editPassword(Map<String, String> password) async{
    final db = _database;
    var iv = IV.fromSecureRandom(16);
    var pin = await getPin();
    final key = Key.fromUtf8('${pin!.substring(0,32)}');
    final encrypter = Encrypter(AES(key, padding: null));
    final encrypted = encrypter.encrypt(password['password']!, iv: iv);
    var res = await db.rawUpdate('UPDATE passwords SET iv = ? WHERE uniqueId = ?',
        [iv.base64, password['uniqueId']!]
    );
    await storage.write(key: password['uniqueId']!, value: encrypted.base64);
  }




}