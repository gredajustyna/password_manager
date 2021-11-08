import 'package:equatable/equatable.dart';
import 'package:totp_new_version/password_manager/src/domain/entities/password_tile_model.dart';

abstract class SearchPasswordState extends Equatable{
  final List<PasswordTileModel>? passwordList;
  const SearchPasswordState({this.passwordList});

  @override
  // TODO: implement props
  List<Object?> get props => [passwordList];

}

class SearchListLoading extends SearchPasswordState{
  const SearchListLoading();
}

class SearchListDone extends SearchPasswordState{
  const SearchListDone(List<PasswordTileModel> passwordList): super(passwordList: passwordList);
}

class SearchListError extends SearchPasswordState{
  const SearchListError();
}