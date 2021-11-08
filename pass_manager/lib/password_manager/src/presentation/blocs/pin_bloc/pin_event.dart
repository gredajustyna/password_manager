import 'package:equatable/equatable.dart';

abstract class PinEvent extends Equatable{
  final String? pin;

  const PinEvent({this.pin});
}

class VerifyPin extends PinEvent{
  const VerifyPin(String pin) : super(pin: pin);

  @override
  // TODO: implement props
  List<Object?> get props => [pin];
}

class SetPin extends PinEvent{
  const SetPin(String pin) : super(pin: pin);

  @override
  // TODO: implement props
  List<Object?> get props => [pin];
}

class CheckIfPinSet extends PinEvent{
  const CheckIfPinSet();

  @override
  // TODO: implement props
  List<Object?> get props => [];


}