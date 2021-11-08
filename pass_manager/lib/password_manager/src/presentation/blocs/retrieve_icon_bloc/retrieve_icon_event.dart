import 'package:equatable/equatable.dart';
import 'package:favicon/favicon.dart' as fav;
import 'package:totp_new_version/password_manager/src/domain/entities/password_tile_model.dart';

abstract class RetrieveIconEvent extends Equatable{


  const RetrieveIconEvent();
}

class GetIcon extends RetrieveIconEvent{
  final PasswordTileModel domain;
  const GetIcon({required this.domain}) ;
  @override
  // TODO: implement props
  List<Object?> get props => [domain];

}