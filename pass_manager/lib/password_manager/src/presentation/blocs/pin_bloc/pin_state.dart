import 'package:equatable/equatable.dart';

abstract class AddPinState extends Equatable{

  final bool? isPinAdded;
  const AddPinState({this.isPinAdded});
}

abstract class CheckPinState extends Equatable{
  final bool? isPinSet;
  const CheckPinState({this.isPinSet});
}

abstract class VerifyPinState extends Equatable{
  final bool? isPinCorrect;
  const VerifyPinState({this.isPinCorrect});
}

class PinAddedSuccessfully extends AddPinState{
  const PinAddedSuccessfully(bool isAdded) : super(isPinAdded: isAdded);
  @override
  // TODO: implement props
  List<Object?> get props => [isPinAdded];

}

class PinAddError extends AddPinState{
  const PinAddError(bool isAdded) : super(isPinAdded: isAdded);

  @override
  // TODO: implement props
  List<Object?> get props => [isPinAdded];

}

class PinAddLoading extends AddPinState{
  const PinAddLoading();

  @override
  // TODO: implement props
  List<Object?> get props => [];

}

class PinIsSet extends CheckPinState{
  const PinIsSet(bool isSet) : super(isPinSet: isSet);
  @override
  // TODO: implement props
  List<Object?> get props => [isPinSet];

}

class PinNotSet extends CheckPinState{
  const PinNotSet(bool isSet) : super(isPinSet: isSet);
  @override
  // TODO: implement props
  List<Object?> get props => [isPinSet];

}

class PinSetLoading extends CheckPinState{
  const PinSetLoading();
  @override
  // TODO: implement props
  List<Object?> get props => [];

}

class PinCorrect extends VerifyPinState{
  const PinCorrect(bool isCorrect) : super(isPinCorrect: isCorrect);
  @override
  // TODO: implement props
  List<Object?> get props => [isPinCorrect];

}

class PinIncorrect extends VerifyPinState{
  const PinIncorrect(bool isCorrect) : super(isPinCorrect: isCorrect);
  @override
  // TODO: implement props
  List<Object?> get props => [isPinCorrect];

}

class PinVerifyLoading extends VerifyPinState{
  const PinVerifyLoading();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}