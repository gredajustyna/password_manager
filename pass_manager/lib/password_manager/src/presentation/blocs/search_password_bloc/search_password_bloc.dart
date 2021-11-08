import 'package:bloc/bloc.dart';
import 'package:totp_new_version/password_manager/src/domain/entities/password_tile_model.dart';
import 'package:totp_new_version/password_manager/src/domain/usecases/search_password_usecase.dart';
import 'package:totp_new_version/password_manager/src/presentation/blocs/search_password_bloc/search_password_event.dart';
import 'package:totp_new_version/password_manager/src/presentation/blocs/search_password_bloc/search_password_state.dart';

class SearchPasswordBloc extends Bloc<SearchPasswordEvent, SearchPasswordState>{
  SearchPasswordUseCase _searchPasswordUseCase;
  SearchPasswordBloc(this._searchPasswordUseCase) : super(SearchListLoading());

  @override
  Stream<SearchPasswordState> mapEventToState(SearchPasswordEvent event) async*{
    if(event is SearchForPassword){
      List<PasswordTileModel> newCodes = await _searchPasswordUseCase(params: event.textToSearch!);
      yield SearchListDone(newCodes);
    }
  }

}