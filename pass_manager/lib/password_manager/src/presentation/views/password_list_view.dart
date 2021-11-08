import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:totp_new_version/config/themes/colors.dart';
import 'package:totp_new_version/password_manager/src/domain/entities/password_tile_model.dart';
import 'package:totp_new_version/password_manager/src/presentation/blocs/add_password_bloc/add_password_bloc.dart';
import 'package:totp_new_version/password_manager/src/presentation/blocs/add_password_bloc/add_password_event.dart';
import 'package:totp_new_version/password_manager/src/presentation/blocs/add_password_bloc/add_password_state.dart';
import 'package:totp_new_version/password_manager/src/presentation/blocs/password_bloc/password_bloc.dart';
import 'package:totp_new_version/password_manager/src/presentation/blocs/password_bloc/password_event.dart';
import 'package:totp_new_version/password_manager/src/presentation/blocs/password_bloc/password_state.dart';
import 'package:totp_new_version/password_manager/src/presentation/blocs/pin_bloc/pin_bloc.dart';
import 'package:totp_new_version/password_manager/src/presentation/blocs/pin_bloc/pin_state.dart';
import 'package:totp_new_version/password_manager/src/presentation/blocs/search_password_bloc/search_password_bloc.dart';
import 'package:totp_new_version/password_manager/src/presentation/blocs/search_password_bloc/search_password_event.dart';
import 'package:totp_new_version/password_manager/src/presentation/blocs/search_password_bloc/search_password_state.dart';
import 'package:totp_new_version/password_manager/src/presentation/blocs/show_password_bloc/show_password_bloc.dart';
import 'package:totp_new_version/password_manager/src/presentation/blocs/show_password_bloc/show_password_state.dart';
import 'package:totp_new_version/password_manager/src/presentation/widgets/password_tile.dart';

class PasswordListView extends StatefulWidget {
  const PasswordListView({Key? key}) : super(key: key);

  @override
  _PasswordListViewState createState() => _PasswordListViewState();
}

class _PasswordListViewState extends State<PasswordListView> {
  bool isSearching = false;
  bool isObscuredPassword = true;
  bool isObscuredConfirm = true;
  String warningMessage = '';

  //TEXT EDITING CONTROLLER FOR SEARCH TEXT FIELD
  TextEditingController textEditingController = TextEditingController();

  //TEXT EDITING CONTROLLER FOR DOMAIN NAME
  TextEditingController _domainEditingController = TextEditingController();

  //TEXT EDITING CONTROLLER FOR PASSWORD
  TextEditingController _passwordEditingController = TextEditingController();

  //TEXT EDITING CONTROLLER FOR CONFIRM PASSWORD
  TextEditingController _confirmPasswordEditingController = TextEditingController();

  //TEXT EDITING CONTROLLER FOR USERNAME
  TextEditingController _usernameEditingController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
    _domainEditingController.dispose();
    _passwordEditingController.dispose();
    _confirmPasswordEditingController.dispose();
    _usernameEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("BUDUJE SIE");
    return BlocProvider.value(
      value: BlocProvider.of<PasswordBloc>(context)..add(GetPasswordsList()),
      child: BlocListener<AddPasswordBloc, AddPasswordState>(
        listener: (context, state){
          if(state is PasswordAddDone){
            BlocProvider.of<PasswordBloc>(context).add(GetPasswordsList());
          }
        },
        child: Scaffold(
          appBar: _buildAppBar(),
          floatingActionButton: _buildFloatingActionButton(),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          body: WillPopScope(
            onWillPop: _onWillPop,
            child: BlocListener<ShowPasswordBloc,ShowPasswordState>(
              child: _buildBody(),
              listener: (context, state){
                if(state is PasswordShowError){
                  Scaffold.of(context).showSnackBar(SnackBar(content: Text('Pin incorrect, try again!'), backgroundColor: totpRed,));
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(){
    return AppBar(
      actions: [
        isSearching ?
        IconButton(
          onPressed: (){
            setState(() {
              isSearching = false;
              textEditingController.clear();
            });
          },
          icon: Icon(
            Icons.close,
            color: Colors.white,
          ),
        ) :

        //ELSE ENABLE TO OPEN THE SEARCH BAR
        IconButton(
          onPressed: (){
            setState(() {
              isSearching = true;
            });
          },
          icon: Icon(
            Icons.search,
            color: Colors.white,
          ),
        ),
      ],
      centerTitle: true,
      title: isSearching ?

      //IF IS SEARCHING, SHOW SEARCH BOX
      Container(
        decoration: BoxDecoration(
          color: Color(0xff679289),
          borderRadius: BorderRadius.circular(5),
        ),
        child: TextField(
          autofocus: true,
          onChanged: (value){
            setState(() {
              BlocProvider.of<SearchPasswordBloc>(context).add(SearchForPassword(value));
            });
          },
          style: TextStyle(
              color: Colors.white
          ),
          cursorColor: Colors.white,
          controller: textEditingController,
          decoration: InputDecoration(
            hintStyle: TextStyle(
              color: Colors.grey[200],
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                  color: Colors.white,
                )
            ),
            contentPadding: EdgeInsets.all(10),
            hintText: 'Search',
          ),
        ),
      ) :

      //ELSE SHOW THE APP TITLE
      Text(
        'Password manager',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton(){
    return FloatingActionButton(
      elevation: 0,
      child: Icon(
        Icons.add,
        color: Colors.white,
      ),
      onPressed: (){
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
                        //SOME SPACE
                        SizedBox(height: 20,),
                      //GREETING TEXT
                        Text('Add entry:',
                          style: TextStyle(
                            fontSize: 25,
                            color: totpDarkGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20,),
                        //CONTAINER WITH TEXT FIELD
                        Container(
                          width: MediaQuery.of(context).size.width - 20,
                          child: Padding(
                            padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context)
                                    .viewInsets
                                    .bottom
                            ),
                            child: TextFormField(
                              //EDIT TEXT CONTROLLER
                              decoration: InputDecoration(
                                labelText: "Domain name",
                                prefixIcon: Icon(Icons.add_link_outlined, size: 24),
                                focusColor: totpDarkGreen,
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
                              controller: _domainEditingController,
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                              onFieldSubmitted: (String value){

                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        TextFormField(
                          //EDIT TEXT CONTROLLER
                          decoration: InputDecoration(
                            labelText: "Username (optional)",
                            prefixIcon: Icon(Icons.account_circle_outlined, size: 24),
                            focusColor: totpDarkGreen,
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
                          controller: _usernameEditingController,
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                          onFieldSubmitted: (String value){

                          },
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
                              if(_passwordEditingController.text == _confirmPasswordEditingController.text && _domainEditingController.text.isNotEmpty){
                                Map<String, String> map = new Map();
                                if(_usernameEditingController.text.isEmpty){
                                  map = {'domain': _domainEditingController.text, 'password': _passwordEditingController.text, 'username' : ''};
                                }else{
                                  map = {'domain': _domainEditingController.text, 'password': _passwordEditingController.text, 'username': _usernameEditingController.text};
                                }
                                BlocProvider.of<AddPasswordBloc>(context).add(AddPassword(map));
                                setMyState((){
                                  warningMessage = '';
                                });
                                Navigator.of(context).pop();
                                _passwordEditingController.clear();
                                _confirmPasswordEditingController.clear();
                                _domainEditingController.clear();
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
                        SizedBox(height: 10,),
                      ]
                    ),
                  );
                }
              );
            }
        );
      }
    );
  }

  Widget _buildBody(){
    if(isSearching){
      return Column(
        children: [
          SizedBox(height: 5),
          Expanded(
            flex: 15,
            child: BlocBuilder<SearchPasswordBloc, SearchPasswordState>(
              builder: (_, state){
                if(state is SearchListLoading){
                  return Center(
                    child: CupertinoActivityIndicator(),
                  );
                }if(state is SearchListDone){
                  return _buildPasswordsList(state.passwordList!);
                }
                else{
                  return Center();
                }
              },
            ),
          ),
        ],
      );
    }else{
      print("BUILDINGBODY");
      return Column(
        children: [
          SizedBox(height: 5),
          Expanded(
            flex: 15,
            child: BlocBuilder<PasswordBloc, PasswordState>(
              builder: (_, state){
                print(state);
                if(state is PasswordListLoading){
                  return Center(
                    child: CupertinoActivityIndicator(),
                  );
                }if(state is PasswordListDone){
                  return _buildPasswordsList(state.passwordList!);
                }
                else{
                  return Center();
                }
              },
            ),
          ),
        ],
      );
    }
  }

  Widget _buildPasswordsList(List<PasswordTileModel> models){
    print("LISTA");
    return ListView.builder(
        itemCount: models.length,
        itemBuilder: (context, index){
          return Dismissible(
            // confirmDismiss: (DismissDirection direction) async{
            //   // return await showDialog(
            //   //     context: context,
            //   //     builder: (BuildContext context){
            //   //       return DeleteCodeDialog(tileModel: models[index]);
            //   //     }
            //   // );
            // },
            direction: DismissDirection.endToStart,
            key: UniqueKey(),
            background: Container(
              color: Color(0xffb36a5e),
              child: Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text('Swipe to delete',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            onDismissed: (direction){
              BlocProvider.of<PasswordBloc>(context).add(DeletePassword(models[index].passwordModel));
              ScaffoldMessenger.of(context)
                  .showSnackBar(
                  SnackBar(
                    content: Text('Code deleted!'),
                    duration: Duration(milliseconds: 750),
                  ));
            },
            child: PasswordTile(
                model: models[index]
            ),
          );
        }
    );
  }

  Future<bool> _onWillPop() async {
    if(1==1){
      BlocProvider.of<PasswordBloc>(context).add(CloseList());
      return true;
    }else{
      return false;
    }
  }


}
