import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:totp_new_version/config/themes/colors.dart';
import 'package:totp_new_version/password_manager/src/presentation/blocs/pin_bloc/pin_bloc.dart';
import 'package:totp_new_version/password_manager/src/presentation/blocs/pin_bloc/pin_event.dart';
import 'package:totp_new_version/password_manager/src/presentation/blocs/pin_bloc/pin_state.dart';

class PinScreenView extends StatefulWidget {
  const PinScreenView({Key? key}) : super(key: key);

  @override
  _PinScreenViewState createState() => _PinScreenViewState();
}

class _PinScreenViewState extends State<PinScreenView> {
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  late String pinHash;

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: totpWhite),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<CheckPinBloc>(context)..add(CheckIfPinSet()),
      child: Scaffold(
          backgroundColor: totpLightGreen,
          body: BlocListener<AddPinBloc, AddPinState>(
            listener: (context, state){
              if(state is PinAddedSuccessfully){
                Scaffold.of(context).showSnackBar(SnackBar(content: Text('Pin successfully set! Redirecting to main screen...')));
                Future.delayed(Duration(seconds: 3)).then((value) {
                  Navigator.pushNamed(context, '/main');
                });

              }
            },
            child: BlocListener<VerifyPinBloc, VerifyPinState>(
              listener: (context, state){
                if(state is PinCorrect){
                  Navigator.pushNamed(context, '/main');
                }else if(state is PinIncorrect){
                  Scaffold.of(context).showSnackBar(SnackBar(content: Text('Pin incorrect, try again!'), backgroundColor: totpRed,));
                }
              },
              child: BlocBuilder<CheckPinBloc, CheckPinState>(
                builder: (context, state) {
                  if(state is PinIsSet){
                    return Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text('Enter pin code to access the app:',
                              style: TextStyle(
                                color: totpWhite,
                                fontSize: 18,
                              ),
                            ),
                            Container(
                              color: totpLightGreen,
                              margin: const EdgeInsets.all(20.0),
                              padding: const EdgeInsets.all(20.0),
                              child: PinPut(
                                obscureText: '•',
                                textStyle: TextStyle(
                                  color: totpWhite,
                                ),
                                fieldsCount: 4,
                                onSubmit: (String pin) {
                                  BlocProvider.of<VerifyPinBloc>(context).add(VerifyPin(pin));
                                },
                                focusNode: _pinPutFocusNode,
                                controller: _pinPutController,
                                submittedFieldDecoration: _pinPutDecoration.copyWith(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                selectedFieldDecoration: _pinPutDecoration,
                                followingFieldDecoration: _pinPutDecoration.copyWith(
                                  borderRadius: BorderRadius.circular(5.0),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(.5),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                FlatButton(
                                  onPressed: () => _pinPutController.text = '',
                                  child: const Text('Clear All',
                                    style: TextStyle(
                                      color: totpLightGrey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }else {
                    return Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text('Set pin code to access the app:',
                              style: TextStyle(
                                color: totpWhite,
                                fontSize: 18,
                              ),
                            ),
                            Container(
                              color: totpLightGreen,
                              margin: const EdgeInsets.all(20.0),
                              padding: const EdgeInsets.all(20.0),
                              child: PinPut(
                                fieldsCount: 4,
                                onSubmit: (String pin) {
                                  BlocProvider.of<AddPinBloc>(context).add(SetPin(pin));
                                },
                                obscureText: '•',
                                textStyle: TextStyle(
                                  color: totpWhite,
                                ),
                                focusNode: _pinPutFocusNode,
                                controller: _pinPutController,
                                submittedFieldDecoration: _pinPutDecoration.copyWith(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                selectedFieldDecoration: _pinPutDecoration,
                                followingFieldDecoration: _pinPutDecoration.copyWith(
                                  borderRadius: BorderRadius.circular(5.0),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(.5),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                FlatButton(
                                  onPressed: () => _pinPutController.text = '',
                                  child: const Text('Clear All',
                                    style: TextStyle(
                                      color: totpLightGrey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ),
    );
  }

}
