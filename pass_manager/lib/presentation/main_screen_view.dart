import 'package:flutter/material.dart';
import 'package:totp_new_version/config/themes/colors.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody(){
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildWaveHeader(),
          _buildButtonsTable(),
        ],
      ),
    );
  }

  Widget _buildWaveHeader(){
    return Stack(
      children: [
        RotatedBox(
          quarterTurns:2,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height:( MediaQuery.of(context).size.height)/4,
            color: Colors.transparent,
            child: WaveWidget( //user Stack() widget to overlap content and waves
              config: CustomConfig(
                colors: [
                  totpDarkGreen.withOpacity(0.3),
                  totpDarkGreen.withOpacity(0.3),
                  totpDarkGreen.withOpacity(0.3),
                  //the more colors here, the more wave will be
                ],
                durations: [4000, 5000, 7000],
                //durations of animations for each colors,
                // make numbers equal to numbers of colors
                heightPercentages: [0.01, 0.05, 0.03],
                //height percentage for each colors.
                blur: MaskFilter.blur(BlurStyle.solid, 5),
                //blur intensity for waves
              ),
              waveAmplitude: 35.00, //depth of curves
              waveFrequency: 2, //number of curves in waves
              backgroundColor: Colors.transparent, //background colors
              size: Size(
                double.infinity,
                double.infinity,
              ),
            ),
          ),
        ),
        Positioned(
          child: IconButton(
            onPressed: (){},
            icon: Icon(Icons.settings),
            color: totpWhite,
          ),
          top: 30,
          right: 7,
        ),
        Positioned(
          left: 7,
          top: (( MediaQuery.of(context).size.height)/4)-90,
          child: Text(
            'TDA',
            style: TextStyle(
              fontFamily: 'Montserrat',
              color: totpWhite,
              letterSpacing: 5,
              fontSize: 40,
            ),
          ),
        ),
      ]
    );
  }

  Widget _buildButtonsTable(){
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 50, 20, 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTOTPButton(),
              SizedBox(width: 10,),
              _buildSignButton(),
            ],
          ),
          SizedBox(height: 10,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPasswordButton(),
            ],
          )
        ],
      ),
    );
  }


  Widget _buildTOTPButton(){
    return InkWell(
      onTap: (){
        _onTOTPButtonPressed();
      },
      child: Container(
        width: ((MediaQuery.of(context).size.width)/2)-20,
        height: (MediaQuery.of(context).size.height)/5,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: totpDarkGreen ,
            width: 2.0 ,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 2.0,
              spreadRadius: 0.0,
              offset: Offset(2.0, 2.0), // shadow direction: bottom right
            )
          ],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.phonelink_lock,
                color: totpDarkGreen,
                size: 50,
              ),
              Text(
                'TOTP \n generator',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: totpDarkGreen,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignButton(){
    return InkWell(
      onTap: (){
        _onSignDocumentButtonPressed();
      },
      child: Container(
        width: ((MediaQuery.of(context).size.width)/2)-30,
        height: (MediaQuery.of(context).size.height)/7,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: totpDarkGreen ,
            width: 2.0 ,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 2.0,
              spreadRadius: 0.0,
              offset: Offset(2.0, 2.0), // shadow direction: bottom right
            )
          ],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 20, 10, 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.fingerprint_outlined,
                color: totpDarkGreen,
                size: 35,
              ),
              Text(
                'Document \n signing',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: totpDarkGreen,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordButton(){
    return InkWell(
      onTap: (){
        _onPasswordButtonPressed();
      },
      child: Container(
        width: ((MediaQuery.of(context).size.width)/2)+10,
        height: (MediaQuery.of(context).size.height)/5,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: totpDarkGreen ,
            width: 2.0 ,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 2.0,
              spreadRadius: 0.0,
              offset: Offset(2.0, 2.0), // shadow direction: bottom right
            )
          ],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 20, 10, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.lock_outlined,
                color: totpDarkGreen,
                size: 50,
              ),
              Text(
                'Password \n manager',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: totpDarkGreen,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTOTPButtonPressed(){
    Navigator.pushNamed(context, '/totp');
  }

  void _onSignDocumentButtonPressed(){
    Navigator.pushNamed(context, '/signing');
  }

  void _onPasswordButtonPressed(){
    Navigator.pushNamed(context, '/password');
  }

}
