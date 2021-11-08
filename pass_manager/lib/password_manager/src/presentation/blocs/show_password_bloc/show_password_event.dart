import 'package:equatable/equatable.dart';
import 'package:totp_new_version/password_manager/src/domain/entities/password_model.dart';
import 'package:totp_new_version/password_manager/src/domain/entities/password_tile_model.dart';

abstract class ShowPasswordEvent extends Equatable{
  final PasswordTileModel? model;
  final String? pin;
  const ShowPasswordEvent({this.model, this.pin});
}

class ShowPassword extends ShowPasswordEvent{
  const ShowPassword(PasswordTileModel model, String pin) : super(model: model, pin: pin);

  @override
  // TODO: implement props
  List<Object?> get props => [model];

}

class HidePassword extends ShowPasswordEvent{
  const HidePassword(PasswordTileModel model) : super(model: model);

  @override
  // TODO: implement props
  List<Object?> get props => [model];

}
