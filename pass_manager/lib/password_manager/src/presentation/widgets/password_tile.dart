import 'dart:async';
import 'package:favicon/favicon.dart' as fav;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:totp_new_version/config/themes/colors.dart';
import 'package:totp_new_version/password_manager/src/domain/entities/password_tile_model.dart';
import 'package:totp_new_version/password_manager/src/presentation/blocs/password_bloc/password_bloc.dart';
import 'package:totp_new_version/password_manager/src/presentation/blocs/password_bloc/password_event.dart';
import 'package:totp_new_version/password_manager/src/presentation/blocs/password_bloc/password_state.dart';
import 'package:totp_new_version/password_manager/src/presentation/blocs/pin_bloc/pin_bloc.dart';
import 'package:totp_new_version/password_manager/src/presentation/blocs/pin_bloc/pin_event.dart';
import 'package:totp_new_version/password_manager/src/presentation/blocs/pin_bloc/pin_state.dart';
import 'package:totp_new_version/password_manager/src/presentation/blocs/retrieve_icon_bloc/retrieve_icon_bloc.dart';
import 'package:totp_new_version/password_manager/src/presentation/blocs/retrieve_icon_bloc/retrieve_icon_event.dart';
import 'package:totp_new_version/password_manager/src/presentation/blocs/retrieve_icon_bloc/retrieve_icon_state.dart';
import 'package:totp_new_version/password_manager/src/presentation/blocs/show_password_bloc/show_password_bloc.dart';
import 'package:totp_new_version/password_manager/src/presentation/blocs/show_password_bloc/show_password_event.dart';
import 'package:totp_new_version/password_manager/src/presentation/blocs/show_password_bloc/show_password_state.dart';

class PasswordTile extends StatefulWidget {
  final PasswordTileModel model;

  const PasswordTile({Key? key, required this.model}) : super(key: key);

  @override
  _PasswordTileState createState() => _PasswordTileState();
}

class _PasswordTileState extends State<PasswordTile> {
  late PasswordTileModel passwordTileModel = widget.model;
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  //late String pinHash;
  final TextEditingController _passwordEditingController = TextEditingController();
  final TextEditingController _confirmPasswordEditingController = TextEditingController();
  bool isObscuredPassword = true;
  bool isObscuredConfirm = true;
  String warningMessage = '';

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: totpDarkGreen),
      borderRadius: BorderRadius.circular(15.0),
    );
  }


  UniqueKey key = UniqueKey();

  @override
  void dispose() {
    print('DISPOSED');
    _pinPutFocusNode.dispose();
    _pinPutController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    print(passwordTileModel.passwordModel.domain);
    return BlocProvider.value(
      value: BlocProvider.of<RetrieveIconBloc>(context)..add(GetIcon(domain: passwordTileModel)),
      child: BlocListener<ShowPasswordBloc, ShowPasswordState>(
        listener: (context, state){
          if(state is PasswordShowDone){
            setState(() {

            });
          }else if(state is HidePassword){
            setState(() {

            });
          }
        },
        child: BlocListener<VerifyPinBloc, VerifyPinState>(
          listener: (context, state){
            if(state is PinCorrect){

            }else if(state is PinIncorrect){
              Scaffold.of(context).showSnackBar(SnackBar(content: Text('Pin incorrect, try again!'), backgroundColor: totpRed,));
            }
          },
          child: BlocListener<PasswordBloc, PasswordState>(
            listener: (context, state){
              if(state is PasswordEditDone){
                Scaffold.of(context).showSnackBar(SnackBar(content: Text(state.message!), backgroundColor: totpDarkGreen,duration: Duration(milliseconds: 500),));
              }else if(state is PasswordEditError){
                Scaffold.of(context).showSnackBar(SnackBar(content: Text(state.message!), backgroundColor: totpRed,duration: Duration(milliseconds: 500)));
              }
            },
            child: Card(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          // child: BlocBuilder<RetrieveIconBloc, RetrieveIconState>(
                          //   builder: (context, state){
                          //     if(state is RetrieveIconLoading){
                          //       return CupertinoActivityIndicator();
                          //     }else{
                          //       return Image.network(passwordTileModel.imgPath);
                          //     }
                          //   },
                          // ),
                        ),
                        //A BIT OF SPACE
                        SizedBox(width: 10),
                        //NAME AND CODE
                        Expanded(
                          flex:5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              //ORGANIZATION NAME
                              Text(passwordTileModel.passwordModel.domain,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: totpDarkGreen,
                                  fontSize: 18,
                                ),
                              ),
                              Text(passwordTileModel.passwordModel.username ?? "",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: totpGrey,
                                  fontSize: 16,
                                ),
                              ),
                              //CODE WITH POSSIBILITY TO LONG PRESS TO COPY
                              BlocBuilder<ShowPasswordBloc, ShowPasswordState>(
                                  builder: (context, state){
                                    if(state is PasswordShowDone){
                                      if(passwordTileModel.isPasswordVisible == true){
                                        return Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              child: Text(
                                                state.password!,
                                                style: TextStyle(
                                                  color: totpGrey,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }else{
                                        return Text(
                                          'password hidden',
                                          style: TextStyle(
                                            color: totpLightGrey,
                                            fontSize: 14,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        );
                                      }
                                    }else if(state is PasswordShowError){
                                      return Column(
                                        children: [
                                          Text(
                                            'password hidden',
                                            style: TextStyle(
                                              color: totpLightGrey,
                                              fontSize: 14,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ],
                                      );
                                    }else{
                                      return Column(
                                        children: [
                                          Text(
                                            'password hidden',
                                            style: TextStyle(
                                              color: totpLightGrey,
                                              fontSize: 14,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                  }
                              ),
                            ],
                          ),
                        ),
                        //MORE SPACE
                        Spacer(),
                        Expanded(
                          child: Column(
                            children: [
                              RawMaterialButton(
                                onPressed: () {
                                  if(passwordTileModel.isPasswordVisible == false){
                                    _showMyDialog().then((value) {
                                      print(passwordTileModel.isPasswordVisible);
                                      setState(() {

                                      });
                                    });
                                  }else{
                                    BlocProvider.of<ShowPasswordBloc>(context).add(HidePassword(passwordTileModel));
                                  }

                                },
                                elevation:0,
                                fillColor: Colors.white,
                                child: BlocBuilder<ShowPasswordBloc, ShowPasswordState>(
                                  builder: (context, state){
                                    if(state is PasswordShowDone && passwordTileModel.isPasswordVisible == true){
                                      return Icon(
                                        Icons.remove_red_eye_outlined,
                                        color:totpDarkGreen,
                                      );
                                    }else{
                                      return Icon(
                                        Icons.remove_red_eye_rounded,
                                        color:Colors.grey[100],
                                      );
                                    }
                                  }
                                ),
                                shape: CircleBorder(),
                              ),
                              RawMaterialButton(
                                onPressed: () {
                                  _showEditBottomSheet(context);
                                },
                                elevation:0,
                                fillColor: Colors.white,
                                child: Icon(
                                  Icons.edit,
                                  color:Colors.grey[100],
                                ),
                                shape: CircleBorder(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    //SOME SPACE
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter app pin'),
          content: SingleChildScrollView(
            child: PinPut(
              obscureText: '•',
              textStyle: TextStyle(
                color: totpDarkGreen,
              ),
              fieldsCount: 4,
              onSubmit: (String pin) {
                //print('CHCEMY WYŚWIETLIĆ HASŁO DLA ${passwordTileModel.passwordModel.domain}');
                BlocProvider.of<ShowPasswordBloc>(context).add(ShowPassword(passwordTileModel, pin));
                Navigator.of(context).pop();
                _pinPutController.clear();
                setState(() {});
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
                  color: totpDarkGreen,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showEditDialog(Map<String, String> map, BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter app pin'),
          content: SingleChildScrollView(
            child: PinPut(
              obscureText: '•',
              textStyle: TextStyle(
                color: totpDarkGreen,
              ),
              fieldsCount: 4,
              onSubmit: (String pin) {
                BlocProvider.of<PasswordBloc>(context).add(EditPassword(map, pin));
                _pinPutController.clear();
                Navigator.of(context).pop();
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
                  color: totpDarkGreen,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showEditBottomSheet(BuildContext context){
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(35.0)),
        ),
        context: context,
        builder: (context){
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setMyState){
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 20,),
                      //GREETING TEXT
                      Text('Edit password:',
                        style: TextStyle(
                          fontSize: 25,
                          color: totpDarkGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20,),
                      Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width - 110,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(context)
                                      .viewInsets
                                      .bottom
                              ),
                              child: TextFormField(
                                //EDIT TEXT CONTROLLER
                                decoration: InputDecoration(
                                  labelText: "Password",
                                  prefixIcon: Icon(Icons.lock, size: 24),
                                  contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                      color: totpGrey,
                                      width: 2.0,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                      color: totpDarkGreen,
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                                obscureText: isObscuredPassword ? true : false,
                                controller: _passwordEditingController,
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                                onFieldSubmitted: (String value){

                                },
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: (){
                              setMyState(() {
                                isObscuredPassword = !isObscuredPassword;
                              });
                            },
                            icon: Icon(isObscuredPassword ? Icons.remove_red_eye_outlined : Icons.remove_red_eye_rounded),
                            color: isObscuredPassword ? totpGrey : totpDarkGreen,
                          ),
                        ],
                      ),
                      SizedBox(height: 20,),
                      //CONTAINER WITH TEXT FIELD
                      Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width - 110,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(context)
                                      .viewInsets
                                      .bottom
                              ),
                              child: TextFormField(
                                //EDIT TEXT CONTROLLER
                                decoration: InputDecoration(
                                  labelText: "Confirm password",
                                  prefixIcon: Icon(Icons.lock_outlined, size: 24),
                                  contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                      color: totpGrey,
                                      width: 2.0,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                      color: totpDarkGreen,
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                                obscureText: isObscuredConfirm ? true : false,
                                controller: _confirmPasswordEditingController,
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                                onFieldSubmitted: (String value){

                                },
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: (){
                              setMyState(() {
                                isObscuredConfirm = !isObscuredConfirm;
                              });
                            },
                            icon: Icon(isObscuredConfirm ?  Icons.remove_red_eye_outlined : Icons.remove_red_eye_rounded),
                            color: isObscuredConfirm ? totpGrey : totpDarkGreen,
                          ),
                        ],
                      ),
                      Text(warningMessage,
                        style: TextStyle(
                          color: totpRed,
                        ),
                      ),
                      SizedBox(height: 10,),
                      Builder(
                        builder: (context) =>
                            RawMaterialButton(
                              onPressed: (){
                                if(_passwordEditingController.text == _confirmPasswordEditingController.text){
                                  Map<String, String> map = new Map();
                                  map = {'uniqueId': passwordTileModel.passwordModel.uniqueId.toString(), 'password': _passwordEditingController.text};
                                  setMyState((){
                                    warningMessage = '';
                                  });
                                  Navigator.of(context, rootNavigator: true).pop();
                                  _passwordEditingController.clear();
                                  _confirmPasswordEditingController.clear();
                                  _showEditDialog(map, context);
                                }else{
                                  setMyState((){
                                    warningMessage = 'Passwords don\'t match!';
                                  });
                                }
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              child: Text('save'),
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Montserrat',
                                fontSize: 17,
                              ),
                              elevation: 0,
                              fillColor: Color(0xff3c887e),
                            ),
                      ),
                    ],
                  ),
                );
              }
          );
        }
    );
  }

}