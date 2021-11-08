import 'package:equatable/equatable.dart';
import 'package:favicon/favicon.dart' as fav;

abstract class RetrieveIconState extends Equatable{
  final fav.Icon? webIcon;
  const RetrieveIconState({this.webIcon});
}

class RetrieveIconLoading extends RetrieveIconState{
  const RetrieveIconLoading();
  @override
  // TODO: implement props
  List<Object?> get props => [];

}

class RetrieveIconDone extends RetrieveIconState{
  const RetrieveIconDone(fav.Icon icon) : super(webIcon: icon);
  @override
  // TODO: implement props
  List<Object?> get props => [webIcon];

}

class RetrieveIconError extends RetrieveIconState{
  const RetrieveIconError();

  @override
  // TODO: implement props
  List<Object?> get props => [];

}