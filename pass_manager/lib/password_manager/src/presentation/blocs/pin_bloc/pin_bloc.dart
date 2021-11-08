import 'package:bloc/bloc.dart';
import 'package:totp_new_version/password_manager/src/domain/usecases/add_password_usecase.dart';
import 'package:totp_new_version/password_manager/src/domain/usecases/check_if_pin_set_usecase.dart';
import 'package:totp_new_version/password_manager/src/domain/usecases/set_pin_usecase.dart';
import 'package:totp_new_version/password_manager/src/domain/usecases/verify_pin_usecase.dart';
import 'package:totp_new_version/password_manager/src/presentation/blocs/pin_bloc/pin_event.dart';
import 'package:totp_new_version/password_manager/src/presentation/blocs/pin_bloc/pin_state.dart';

class AddPinBloc extends Bloc<PinEvent, AddPinState>{
  final SetPinUseCase _setPinUseCase;
  AddPinBloc(this._setPinUseCase) : super(PinAddLoading());

  @override
  Stream<AddPinState> mapEventToState(PinEvent event) async*{
    if(event is SetPin){
      bool result = await _setPinUseCase(params: event.pin!);
      if(result == true){
        yield PinAddedSuccessfully(true);
      }else{
        yield PinAddError(false);
      }
    }
  }
}

class CheckPinBloc extends  Bloc<PinEvent, CheckPinState>{
  final CheckIfPinSetUseCase _checkIfPinSetUseCase;
  CheckPinBloc(this._checkIfPinSetUseCase) : super(PinSetLoading());

  @override
  Stream<CheckPinState> mapEventToState(PinEvent event) async*{
    if(event is CheckIfPinSet){
      bool result = await _checkIfPinSetUseCase();
      if(result == true){
        yield PinIsSet(true);
      }else{
        yield PinNotSet(false);
      }
    }
  }
}

class VerifyPinBloc extends Bloc<PinEvent, VerifyPinState>{
  final VerifyPinUseCase _verifyPinUseCase;
  VerifyPinBloc(this._verifyPinUseCase) : super(PinVerifyLoading());
  @override
  Stream<VerifyPinState> mapEventToState(PinEvent event) async*{
    if(event is VerifyPin){
      bool result = await _verifyPinUseCase(params: event.pin!);
      if(result == true){
        yield PinCorrect(true);
        yield PinVerifyLoading();
      }else{
        yield PinIncorrect(false);
        yield PinVerifyLoading();
      }
    }
  }

}