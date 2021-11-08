import 'package:equatable/equatable.dart';

abstract class AddPasswordState extends Equatable{
  const AddPasswordState();
}

class PasswordAddLoading extends AddPasswordState{
  @override
  // TODO: implement props
  List<Object?> get props => [];

}

class PasswordAddDone extends AddPasswordState{
  @override
  // TODO: implement props
  List<Object?> get props => [];

}

class PasswordAddError extends AddPasswordState{
  @override
  // TODO: implement props
  List<Object?> get props => [];

}