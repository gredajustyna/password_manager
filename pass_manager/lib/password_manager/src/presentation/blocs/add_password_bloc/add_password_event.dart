import 'package:equatable/equatable.dart';
import 'package:totp_new_version/password_manager/src/domain/entities/password_model.dart';

abstract class AddPasswordEvent extends Equatable{
  final Map<String, String>? passwordModel;
  const AddPasswordEvent({this.passwordModel});
}

class AddPassword extends AddPasswordEvent{
  const AddPassword(Map<String, String> model) : super(passwordModel: model);

  @override
  // TODO: implement props
  List<Object?> get props => [passwordModel];

}
