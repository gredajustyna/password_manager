import 'package:bloc/bloc.dart';
import 'package:totp_new_version/password_manager/src/domain/usecases/hide_password_usecase.dart';
import 'package:totp_new_version/password_manager/src/domain/usecases/show_password_usecase.dart';
import 'package:totp_new_version/password_manager/src/domain/usecases/verify_pin_usecase.dart';
import 'package:totp_new_version/password_manager/src/presentation/blocs/show_password_bloc/show_password_event.dart';
import 'package:totp_new_version/password_manager/src/presentation/blocs/show_password_bloc/show_password_state.dart';

class ShowPasswordBloc extends Bloc<ShowPasswordEvent, ShowPasswordState>{
  final ShowPasswordUseCase _showPasswordUseCase;
  final HidePasswordUseCase _hidePasswordUseCase;
  final VerifyPinUseCase _verifyPinUseCase;
  ShowPasswordBloc(this._showPasswordUseCase, this._verifyPinUseCase, this._hidePasswordUseCase) : super(PasswordShowLoading());

  @override
  Stream<ShowPasswordState> mapEventToState(ShowPasswordEvent event) async*{
    if(event is ShowPassword){
      bool result = await _verifyPinUseCase(params: event.pin!);
      if(result == true){
        String password = await _showPasswordUseCase(params: event.model!);
        yield PasswordShowDone(password);
      }else{
        yield PasswordShowError();
        yield PasswordShowLoading();
      }
    }
    if(event is HidePassword){
      _hidePasswordUseCase(params: event.model!);
      yield PasswordHide();
    }
  }

}