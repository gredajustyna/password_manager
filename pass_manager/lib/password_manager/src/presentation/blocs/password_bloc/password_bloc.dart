import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:totp_new_version/password_manager/src/domain/entities/password_tile_model.dart';
import 'package:totp_new_version/password_manager/src/domain/usecases/delete_password_usecase.dart';
import 'package:totp_new_version/password_manager/src/domain/usecases/edit_password_usecase.dart';
import 'package:totp_new_version/password_manager/src/domain/usecases/get_all_passwords_usecase.dart';
import 'package:totp_new_version/password_manager/src/domain/usecases/verify_pin_usecase.dart';
import 'package:totp_new_version/password_manager/src/presentation/blocs/password_bloc/password_event.dart';
import 'package:totp_new_version/password_manager/src/presentation/blocs/password_bloc/password_state.dart';

class PasswordBloc extends Bloc<PasswordEvent, PasswordState>{
  final GetAllPasswordsUseCase _getAllPasswordsUseCase;
  final DeletePasswordUseCase _deletePasswordUseCase;
  final EditPasswordUseCase _editPasswordUseCase;
  final VerifyPinUseCase _verifyPinUseCase;
  PasswordBloc(this._getAllPasswordsUseCase, this._deletePasswordUseCase, this._editPasswordUseCase, this._verifyPinUseCase) : super(PasswordListLoading());

  @override
  Stream<PasswordState> mapEventToState(PasswordEvent event) async*{
    print("WESZŁO");
    if(event is GetPasswordsList){
      yield* _getAllPasswords();
    }
    if(event is DeletePassword){
      await _deletePasswordUseCase(params: event.model!);
      yield* _getAllPasswords();
    }
    if(event is EditPassword){
      bool result = await _verifyPinUseCase(params: event.pin!);
      if(result == true){
        await _editPasswordUseCase(params: event.password!);
        yield PasswordEditDone("Password successfully edited!");
        yield* _getAllPasswords();
      }else{
        yield PasswordEditError("Wrong pin! Try again");
        yield* _getAllPasswords();
      }

    }
    if(event is CloseList){
      yield PasswordListLoading();
    }
  }

  @override
  Future<void> close() async {
    super.close();
  }

  Stream<PasswordState> _getAllPasswords() async*{
    List<PasswordTileModel> passwords = await _getAllPasswordsUseCase();
    yield PasswordListDone(passwords);
  }

}