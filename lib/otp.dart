import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:sms_otp_auto_verify/sms_otp_auto_verify.dart';
import 'package:twelve_x_bull/bottom_navbar.dart';
import 'package:twelve_x_bull/login_page.dart';


class OTPScreens extends StatefulWidget {
  final String phoneNo;
  final String userId;

  OTPScreens({required this.phoneNo, required this.userId,});

  @override
  _OTPScreensState createState() => _OTPScreensState();
}

class _OTPScreensState extends State<OTPScreens> {
  final int _otpCodeLength = 6;
  bool _isLoadingButton = false;
  bool _enableButton = false;
  String _otpCode = "";
  final intRegex = RegExp(r'\d+', multiLine: true);
  TextEditingController textEditingController = TextEditingController(text: "");
  String _verificationCode = "";

  @override
  void initState() {
    _sendOtp();
    _getSignatureCode();
    _startListeningSms();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    SmsVerification.stopListening();
  }

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Theme.of(context).primaryColor),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  /// get signature code
  _getSignatureCode() async {
    String? signature = await SmsVerification.getAppSignature();
    print("signature $signature");
  }

  /// listen sms
  _startListeningSms() {
    print("lllllllllll");
    SmsVerification.startListeningSms().then((message) {
      setState(() {
        _otpCode = SmsVerification.getCode(message, intRegex);
        textEditingController.text = _otpCode;
        _onOtpCallBack(_otpCode, true);
      });
    });
  }


  _onSubmitOtp() async {
    setState(() {
      _isLoadingButton = !_isLoadingButton;
      _verifyOtpCode();
    });
  }

  _onOtpCallBack(String otpCode, bool isAutofill) async {
    setState(() {
      _otpCode = otpCode;
      if (otpCode.length == _otpCodeLength && isAutofill) {
        _enableButton = false;
        _isLoadingButton = true;
        _verifyOtpCode();
      } else if (otpCode.length == _otpCodeLength && !isAutofill) {
        _enableButton = true;
        _isLoadingButton = false;
      } else {
        _enableButton = false;
      }
    });
  }
  _verifyOtpCode() async {
    FocusScope.of(context).requestFocus(FocusNode());
    Timer(const Duration(milliseconds: 8000), () async {
      setState(() {
        _isLoadingButton = false;
        _enableButton = false;
      });

      try {
        await FirebaseAuth.instance
            .signInWithCredential(PhoneAuthProvider.credential(
            verificationId: _verificationCode, smsCode: _otpCode))
            .then((value) async {
          if (value.user != null) {
            final prefs = await SharedPreferences.getInstance();
            final key = 'userId';
            final userId = widget.userId;
            prefs.setString(key, userId);
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => Bottom_Navbar()));

          }
        });
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff272139),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 100.0,left: 20,right: 20,bottom: 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 200,
                width: 200,
                child: Image.asset('assets/images/img.png'),
              ), // SizedBox(
              //   height: 20.h,
              // ),.
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('OTP Sent to your Phone'+" +91 "+"${widget.phoneNo}",
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold,color: Colors.white),
                  ),

                  IconButton(
                      color:Color(0XFF3b9fbe),
                      onPressed: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Login_Page()));
                      }, icon:Icon(Icons.edit)),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              TextFieldPin(
                  textController: textEditingController,
                  autoFocus: true,
                  codeLength: _otpCodeLength,
                  alignment: MainAxisAlignment.center,
                  defaultBoxSize: 40.0,
                  margin: 5,
                  selectedBoxSize: 40.0,
                  textStyle: const TextStyle(fontSize: 20,color: Colors.white),
                  defaultDecoration: _pinPutDecoration.copyWith(
                      border: Border.all(
                      color: Colors.white
                      )),
                  selectedDecoration: _pinPutDecoration,
                  onChange: (code) {
                    _onOtpCallBack(code, false);
                  }),
              const SizedBox(
                height: 20,
              ),
              Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 12,
                  child: InkWell(
                    onTap: _enableButton ? _onSubmitOtp : null,
                    child: Container(
                      height:45,
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Color(0XFF3b9fbe),
                      ),
                      child:_setUpButtonChild(),
                    ),
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }

  _sendOtp() async {
    print("ffffffffffffffddddddddd");
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91${widget.phoneNo}',
      verificationCompleted: (PhoneAuthCredential credential){},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationCode = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );

  }

  Widget _setUpButtonChild() {
    if (_isLoadingButton) {
      return const SizedBox(
        width: 19,
        height: 19,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    } else {
      return  Text(
        'Verify',
        style: TextStyle(color: Colors.white,
            fontSize: 20,fontWeight: FontWeight.bold),
      );
    }
  }
}


// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:otp_text_field/otp_field.dart';
// import 'package:otp_text_field/style.dart';
// import 'package:twelve_x_bull/bottom_navbar.dart';
// import 'package:twelve_x_bull/login_page.dart';
// import 'package:twelve_x_bull/register_page.dart';
// class Otp_Page extends StatefulWidget {
//   static String verify="";
//
//   const Otp_Page({Key? key}) : super(key: key);
//
//
//   @override
//   State<Otp_Page> createState() => _Otp_PageState();
// }
//
// class _Otp_PageState extends State<Otp_Page> {
//   final FirebaseAuth auth = FirebaseAuth.instance;
//   var phone = "";
//   @override
//   Widget build(BuildContext context) {
//     var code = "";
//     return Scaffold(
//       backgroundColor: Color(0xff272139),
//       body: ListView(
//         children: [
//           Center(
//               child: Column(
//                 children: [
//                   Image.asset('assets/images/img.png'),
//                   Text('Login',style: TextStyle(color: Colors.white,fontSize: 50),),
//                   Text('Please enter the details below to continue',
//                     style: TextStyle(color: Colors.grey,fontSize: 15),),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 10),
//                     child: Container(
//                       padding: const EdgeInsets.fromLTRB(20,30,0,0),
//                       height: 50,
//                       width: 250,
//                       // color: Colors.red,
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.white,width: 1),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: TextField (
//                         style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
//                         cursorColor: Colors.white,
//                         onChanged: (value){
//                           code=value;
//                         },
//                         maxLength: 6,
//                         keyboardType: TextInputType.number,
//                         decoration: InputDecoration(
//
//                           counter: Offstage(),
//                             border: InputBorder.none,
//                             hintText: 'Enter OTP',
//                           hintStyle: TextStyle(color: Colors.white),
//
//
//                         ),
//                       ),
//                     ),
//                   ),
//
//                   SizedBox(height: 25),
//
//                   Container(
//                     height: 50,
//                     width: 300,
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(colors: [Color(0xffd2b086), Color(0xff594f43)]),
//                       borderRadius: BorderRadius.circular(10),
//                       border: Border.all(width: 2,color: Colors.white),
//                     ),
//                     child: OutlinedButton(
//                         onPressed: () async{
//                           try{
//                             PhoneAuthCredential credential = PhoneAuthProvider.credential(
//                                 verificationId: Login_Page.verify, smsCode: code);
//                             // Sign the user in (or link) with the credential
//                             await auth.signInWithCredential(credential);
//                             Navigator.push(context, MaterialPageRoute(builder: (context)=>Bottom_Navbar()));
//                           }
//                           catch(e){
//                             print('wrong otp');
//                             final snackbar = SnackBar(content: Text('WRONG OTP'));
//                           }
//                         },
//                         style: OutlinedButton.styleFrom(
//                             side: BorderSide(color: Colors.white),
//                             backgroundColor: Colors.green,
//                             primary: Colors.white,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             )),
//                         child: Text(
//                           'Submit OTP',
//                           style: TextStyle(fontSize: 15,),
//                         )),
//                   ),
//                   SizedBox(height: 20),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text("Don't have an Accont ! ",style: TextStyle(color: Colors.white),),
//                       TextButton(onPressed: (){
//                         Navigator.push(context, MaterialPageRoute(builder: (context)=>Register_Page()));
//                       },
//                           child:Text('Register',
//                               style: TextStyle(
//                                   color: Colors.red,
//                                   fontWeight: FontWeight.bold))),
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Container(
//                         height: 60,
//                         width: 60,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           color: Colors.white,
//                         ),
//                         child: Image.asset('assets/images/phone.gif'),
//                       ),
//                       Container(
//                         height: 60,
//                         width: 60,
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             color: Colors.white
//                         ),
//                         child: Image.asset('assets/images/whatsapp.gif'),
//                       ),
//                       Container(
//                         height: 60,
//                         width: 60,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           color: Colors.white,
//                         ),
//                         child: Image.asset('assets/images/gmail.gif'),
//
//                       ),
//
//                     ],
//                   )
//
//                 ],
//               )
//           ),
//         ],
//       ),
//     );
//   }
// }
