import 'package:equatable/equatable.dart';
import 'package:totp_new_version/password_manager/src/domain/entities/password_model.dart';

abstract class PasswordEvent extends Equatable{
  final PasswordModel? model;
  final Map<String, String>? password;
  final String? pin;
  const PasswordEvent({this.model, this.password, this.pin});

}

class GetPasswordsList extends PasswordEvent{
  const GetPasswordsList();

  @override
  // TODO: implement props
  List<Object?> get props => [];

}

class DeletePassword extends PasswordEvent{
  const DeletePassword(PasswordModel model) : super(model: model);
  @override
  // TODO: implement props
  List<Object?> get props => [model];

}

class EditPassword extends PasswordEvent{
  const EditPassword(Map<String, String> password, String pin) : super(password:  password, pin: pin);

  @override
  // TODO: implement props
  List<Object?> get props => [password];
}

class CloseList extends PasswordEvent{
  const CloseList();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}