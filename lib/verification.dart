import 'package:email_auth/email_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'auth.config.dart';
import 'homecreen.dart';
import 'login_page.dart';
import 'api.dart';

class Verificatoin extends StatefulWidget {
  final String email;
   final String password;
   final String username;
  Verificatoin({required this.username,required this.email,required this.password});

  @override
  _VerificatoinState createState() => _VerificatoinState();
}

class _VerificatoinState extends State<Verificatoin> {
  late EmailAuth emailAuth;
  bool _isResendAgain = false;
  int otpreq =3;
  bool _isVerified = false;
  bool _isLoading = false;
TextEditingController otp = TextEditingController();
                    sendOtp() async {

                await emailAuth.sendOtp(
                recipientMail: widget.email, otpLength: 4
                  );


  }
           
 verifyOTP() {
     bool result = emailAuth.validateOtp(
        recipientMail: widget.email,
        userOtp: otp.value.text);

        return result;
  }
_register()async{
 
var data ={
        "name":widget.username,
       "email":widget.email,
       "password":widget.password
     };  
      
var response = await CallApi().postData(data,'https://flutter-authenticate-app.herokuapp.com/addmember');
 if(response.statusCode == 200){
 
   setState(() {
      
        Navigator.push(context, MaterialPageRoute(builder: (_) {
              return loginpage();
            }));
  });
  Fluttertoast.showToast(
        msg: "User Added in  database",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
         timeInSecForIosWeb: 2,
        backgroundColor: Colors.grey.shade400,
        textColor: Colors.white,
        fontSize: 16.0
    );
}
  }


  // ignore: unused_field
  late Timer _timer;
  int _start = 10;
  int _currentIndex = 0;

  void resend() {
    setState(() {
      _isResendAgain = true;
    });

    const oneSec = Duration(milliseconds: 1000);
    _timer = new Timer.periodic(oneSec, (timer) { 
      setState(() {
        if (_start == 0) {
          _start = 10;
          _isResendAgain = false;
          timer.cancel();
        } else {
          _start--;
        }
      });
    });
  }

  verify() {
    setState(() {
      _isLoading = true;
    });

    const oneSec = Duration(milliseconds: 2000);
    _timer = new Timer.periodic(oneSec, (timer) { 
      setState(() {
        _isLoading = false;
        _isVerified = true;
      });
    });
  }

  @override
  void initState() {

    super.initState();
     // Initialize the package
  emailAuth =  new EmailAuth(
    sessionName: "AUTHENTICATE",
  );
  /// Configuring the remote server
  emailAuth.config(remoteServerConfiguration);
    Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {
        _currentIndex++;

        if (_currentIndex == 3)
          _currentIndex = 0;
      });
    });

    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 250,
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: AnimatedOpacity(
                        opacity: _currentIndex == 0 ? 1 : 0, 
                        duration: Duration(seconds: 1,),
                        curve: Curves.linear,
                        child: Image.network('https://ouch-cdn2.icons8.com/eza3-Rq5rqbcGs4EkHTolm43ZXQPGH_R4GugNLGJzuo/rs:fit:784:784/czM6Ly9pY29uczgu/b3VjaC1wcm9kLmFz/c2V0cy9zdmcvNjk3/L2YzMDAzMWUzLTcz/MjYtNDg0ZS05MzA3/LTNkYmQ0ZGQ0ODhj/MS5zdmc.png',),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: AnimatedOpacity(
                        opacity: _currentIndex == 1 ? 1 : 0, 
                        duration: Duration(seconds: 1),
                        curve: Curves.linear,
                        child: Image.network('https://ouch-cdn2.icons8.com/pi1hTsTcrgVklEBNOJe2TLKO2LhU6OlMoub6FCRCQ5M/rs:fit:784:666/czM6Ly9pY29uczgu/b3VjaC1wcm9kLmFz/c2V0cy9zdmcvMzAv/MzA3NzBlMGUtZTgx/YS00MTZkLWI0ZTYt/NDU1MWEzNjk4MTlh/LnN2Zw.png',),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: AnimatedOpacity(
                        opacity: _currentIndex == 2 ? 1 : 0, 
                        duration: Duration(seconds: 1),
                        curve: Curves.linear,
                        child: Image.network('https://ouch-cdn2.icons8.com/ElwUPINwMmnzk4s2_9O31AWJhH-eRHnP9z8rHUSS5JQ/rs:fit:784:784/czM6Ly9pY29uczgu/b3VjaC1wcm9kLmFz/c2V0cy9zdmcvNzkw/Lzg2NDVlNDllLTcx/ZDItNDM1NC04YjM5/LWI0MjZkZWI4M2Zk/MS5zdmc.png',),
                      ),
                    )
                  ]
                ),
              ),
              SizedBox(height: 30,),
               Text("Verification", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
              SizedBox(height: 30,),
               Text("Please enter the OTP", 
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade500, height: 1.5),
              ),
              SizedBox(height: 30,),

  
            TextField(
                              
                              controller: otp,
	                            decoration: InputDecoration(
                                labelText:  "          OTP",
	                              border: InputBorder.none,
	                              hintText:'Enter your OTP',
	                              hintStyle: TextStyle(color: Colors.grey[400])
	                            ),
	                          ),


              SizedBox(height: 20,),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't resive the OTP?", style: TextStyle(fontSize: 14, color: Colors.grey.shade500),),
                    TextButton(
                      onPressed: () {
                        if (_isResendAgain){return;} 
                        else if(otpreq!=0&& !_isResendAgain){
                        resend();
                        sendOtp();
                        setState(() {
                          otpreq--;
                        });
                   }
                   else{
                       Navigator.push(context, MaterialPageRoute(builder: (_) {
              return HomePage();
            }));
                      Fluttertoast.showToast(
        msg: "Session Closed",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
         timeInSecForIosWeb: 2,
        backgroundColor: Colors.grey.shade400,
        textColor: Colors.white,
        fontSize: 16.0
    );
                   }
                        
                      }, 
                      child: Text(_isResendAgain ? "Try again in " + _start.toString() : "Resend", style: TextStyle(color: Colors.blueAccent),)
                    )
                  ],
                ),
              
              SizedBox(height: 50,),
               MaterialButton(
                  elevation: 0,
                  onPressed: (){
                    if(verifyOTP()){
                     
                      _register();
                    
                    }
                    else{
                      Fluttertoast.showToast(
        msg: "Enter a valid OTP",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
         timeInSecForIosWeb: 2,
        backgroundColor: Colors.grey.shade400,
        textColor: Colors.white,
        fontSize: 16.0
    );
                    }
                  }
                  ,
                  color: Colors.orange.shade400,
                  minWidth: MediaQuery.of(context).size.width * 0.8,
                  height: 50,
                  child: _isLoading ? Container(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      strokeWidth: 3,
                      color: Colors.black,
                    ),
                  ) : _isVerified ? Icon(Icons.check_circle, color: Colors.white, size: 30,) : Text("Verify", style: TextStyle(color: Colors.white),),
                ),
              
          ],)
        ),
      )
    );
  }
}