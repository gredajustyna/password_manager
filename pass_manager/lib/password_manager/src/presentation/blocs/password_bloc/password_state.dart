import 'package:equatable/equatable.dart';
import 'package:totp_new_version/password_manager/src/domain/entities/password_tile_model.dart';

abstract class PasswordState extends Equatable{
  final List<PasswordTileModel>? passwordList;
  final String? message;

  const PasswordState({this.passwordList, this.message});

}

class PasswordListLoading extends PasswordState{
  const PasswordListLoading();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class PasswordListError extends PasswordState{
  const PasswordListError();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class PasswordListDone extends PasswordState{
  const PasswordListDone(List<PasswordTileModel> passwords) : super(passwordList: passwords);
  @override
  // TODO: implement props
  List<Object?> get props => [passwordList];

}

class PasswordEditError extends PasswordState{
  const PasswordEditError(String message) : super(message: message);

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

class PasswordEditDone extends PasswordState{
  const PasswordEditDone(String message) : super(message: message);

  @override
  // TODO: implement props
  List<Object?> get props => [];

}