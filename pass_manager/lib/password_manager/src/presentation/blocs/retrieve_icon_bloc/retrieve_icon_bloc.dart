import 'package:bloc/bloc.dart';
import 'package:totp_new_version/password_manager/src/domain/usecases/retrieve_icon_usecase.dart';
import 'package:totp_new_version/password_manager/src/presentation/blocs/retrieve_icon_bloc/retrieve_icon_event.dart';
import 'package:totp_new_version/password_manager/src/presentation/blocs/retrieve_icon_bloc/retrieve_icon_state.dart';
import 'package:favicon/favicon.dart' as fav;

class RetrieveIconBloc extends Bloc<RetrieveIconEvent, RetrieveIconState>{
  final RetrieveIconUseCase _retrieveIconUseCase;
  RetrieveIconBloc(this._retrieveIconUseCase) : super(RetrieveIconLoading());

  @override
  Stream<RetrieveIconState> mapEventToState(RetrieveIconEvent event) async*{
    if(event is GetIcon){
      try{
        fav.Icon? icon = await _retrieveIconUseCase(params: event.domain);
        yield RetrieveIconDone(icon!);
      }catch(e){
        yield RetrieveIconError();
      }

    }
  }


}