import 'dart:ui';
import 'package:favicon/favicon.dart' as fav;
import 'package:totp_new_version/password_manager/src/core/usecases/future_usecase.dart';
import 'package:totp_new_version/password_manager/src/domain/entities/password_tile_model.dart';

class RetrieveIconUseCase extends FutureUseCase<fav.Icon?, PasswordTileModel>{
  @override
 Future<fav.Icon?> call({required PasswordTileModel params}) async{
    if(params.passwordModel.domain.contains('https://')){
      var webIcon = await fav.Favicon.getBest(params.passwordModel.domain);
      params.imgPath = webIcon!.url;
      return webIcon;
    }else{
      var webIcon = await fav.Favicon.getBest('https://${params.passwordModel.domain}');
      params.imgPath = webIcon!.url;
      return webIcon;
    }
  }

}