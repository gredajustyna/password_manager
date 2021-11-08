import 'package:equatable/equatable.dart';

abstract class SearchPasswordEvent extends Equatable{
  final String? textToSearch;
  const SearchPasswordEvent({this.textToSearch});
}

class SearchForPassword extends SearchPasswordEvent{
  SearchForPassword(String text) : super(textToSearch: text);
  @override
  // TODO: implement props
  List<Object?> get props => [textToSearch];

}