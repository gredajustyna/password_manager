import 'package:equatable/equatable.dart';

abstract class ShowPasswordState extends Equatable{
  final String? password;
  const ShowPasswordState({this.password});
}

class PasswordShowLoading extends ShowPasswordState{
  const PasswordShowLoading();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class PasswordShowError extends ShowPasswordState{
  const PasswordShowError();
  @override
  // TODO: implement props
  List<Object?> get props => [];

}

class PasswordShowDone extends ShowPasswordState{
  const PasswordShowDone(String password) : super(password: password);
  @override
  // TODO: implement props
  List<Object?> get props => [password];

}

class PasswordHide extends ShowPasswordState{
  const PasswordHide();

  @override
  // TODO: implement props
  List<Object?> get props => [];

}