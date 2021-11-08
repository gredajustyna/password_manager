import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:totp_new_version/password_manager/src/domain/usecases/add_password_usecase.dart';
import 'package:totp_new_version/password_manager/src/presentation/blocs/add_password_bloc/add_password_event.dart';
import 'package:totp_new_version/password_manager/src/presentation/blocs/add_password_bloc/add_password_state.dart';

class AddPasswordBloc extends Bloc<AddPasswordEvent, AddPasswordState>{
  final AddPasswordUseCase _addPasswordUseCase;
  AddPasswordBloc(this._addPasswordUseCase): super(PasswordAddLoading());

  @override
  Stream<AddPasswordState> mapEventToState(AddPasswordEvent event)async* {
    if(event is AddPassword){
      await _addPasswordUseCase(params: event.passwordModel!);
      yield PasswordAddDone();
      yield PasswordAddLoading();
    }
  }

}