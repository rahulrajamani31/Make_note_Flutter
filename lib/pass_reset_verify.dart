import 'dart:async';

import 'package:email_auth/email_auth.dart';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:email_validator/email_validator.dart';
import 'auth.config.dart';
import 'login_page.dart';
import 'pass_reset.dart';
import 'api.dart';



class Email_verify extends StatefulWidget {
  const Email_verify({ Key? key }) : super(key: key);

  @override
  _Email_verifyState createState() => _Email_verifyState();
}


class _Email_verifyState extends State<Email_verify> {
bool circular =false;
late EmailAuth emailAuth;
 final _formKey = GlobalKey<FormState>();
bool validate =false;
 bool _isResendAgain = false;
  int otpreq =3;
  bool _isVerified = false;
  bool _isLoading = false;

   TextEditingController emailin = TextEditingController();
   TextEditingController OTP = TextEditingController();


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

 _main()  {

    String email = emailin.text;
     late  bool isValid = EmailValidator.validate(email);
     return isValid;
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

 void sendOtp() async {

await emailAuth.sendOtp(
      recipientMail: emailin.value.text, otpLength: 4
      );

  }
verifyOTP() {
     bool result = emailAuth.validateOtp(
        recipientMail: emailin.text,
        userOtp: OTP.value.text);

        return result;
  }
   _register()async{
  if(await _main()&&_formKey.currentState!.validate()){
var data ={
       "email":emailin.text,
     };  
      
var response = await CallApi().getinfo(data,'https://flutter-authenticate-app.herokuapp.com/user');
if(response.statusCode == 400){
  sendOtp();
   setState(() {
      circular =false;
  });
  Fluttertoast.showToast(
        msg: "VALID USER...OTP SENT",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0
    );
}

else if(response.statusCode == 200){
  
   setState(() {
      circular =false;
       
  });
  

  Fluttertoast.showToast(
        msg: "USER NOT FOUND ",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
         timeInSecForIosWeb: 2,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0
    );
}
  }
 else{
   setState(() {
     circular=false;
   });
    Fluttertoast.showToast(
        msg: "Enter  Valid Details",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0
    );
 }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
      	child: Container(
	        child: Column(
	          children: <Widget>[
	            Container(
	              height: 300,
	              decoration: BoxDecoration(
	                image: DecorationImage(
	                  image: AssetImage('assets/email.png'),
	                  fit: BoxFit.contain
	                )
	              ),
	              
	            ),
	            Padding(
	              padding: EdgeInsets.all(30.0),
	              child: Column(
	                children: <Widget>[
	                  Container(
	                    padding: EdgeInsets.all(5),
	                    decoration: BoxDecoration(
	                      color: Colors.white,
	                      borderRadius: BorderRadius.circular(10),
	                      boxShadow: [
	                        BoxShadow(
	                          color: Color.fromRGBO(143, 148, 251, .2),
	                          blurRadius: 20.0,
	                          offset: Offset(0, 10)
	                        )
	                      ]
	                    ),
	                    child: Form(
                        key: _formKey,
                                              child: Column(
                                                children: <Widget>[
                             
                                                  Container(
                                                    padding: EdgeInsets.all(8.0),
                                                    decoration: BoxDecoration(
                                                      border: Border(bottom: BorderSide(color: Colors.grey.shade100))
                                                    ),
                                                    child: TextFormField(   
                               maxLength: 80,
                              controller: emailin,     
                                validator: (value) {
    if (value == null || value.isEmpty) 
      return 'Please enter email';
    
     if(value.length < 5) return "email should be minimum 6 letters";
     
    return null;
  },                      
                                                      decoration: InputDecoration(
                                 labelText: "EMAIL-ID" ,
                                                        border: InputBorder.none,
                                                        hintText:'Enter your email',
                                                        hintStyle: TextStyle(color: Colors.grey[400])
                                                      ),
                                      
                                                    ),
                                                  ),
                                                  TextButton(onPressed: (){
                                                    if(otpreq!=0&& !_isResendAgain){
                                                      resend();
                                                      _register();
                                                      setState(() {
                          otpreq--;
                        });
                        
                                                    }
                                   
else{
   Navigator.push(context, MaterialPageRoute(builder: (_) {
              return loginpage();
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


                                                  }, child: Text(_isResendAgain ? "Try again in " + _start.toString() : "send OTP")),
                                                  Container(
                                                    padding: EdgeInsets.all(8.0),
                                                    child:   TextField(
                              
                              controller: OTP,
	                            decoration: InputDecoration(
                                labelText:  "          OTP",
	                              border: InputBorder.none,
	                              hintText:'Enter your OTP',
	                              hintStyle: TextStyle(color: Colors.grey[400])
	                            ),
	                          ),

                                                  )
                                                ],
                                              ),
                                            ),
	                  ),
	                  SizedBox(height: 30,),
	                   GestureDetector(
                       onTap:(){
                         setState(() {
                           circular = true;
                         });
                          if (verifyOTP()) {
                setState(() {
                  circular =true;
                });
      
       Navigator.push(context, MaterialPageRoute(builder: (_) {
              return pass_verify(email:emailin.text ,);
            }));
    }
    else{
setState(() {
  circular=false;
});
    }
                      
                        

                       },
                              child: Container(
                              height: 50,
                             decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(
                           colors: [
                               Color.fromRGBO(133, 133, 140, 4),
                               Color.fromRGBO(143, 148, 251, .6),
                                 ]
                           )
                      ),
                           child: Center(

           child: circular ? CircularProgressIndicator() : Text("VERIFY", style: 
           TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                             ),
                                         ),
                                          ),
	                  SizedBox(height: 30,),
	                 
	                ],
	              ),
	            )
	          ],
	        ),
	      ),
      )
    );
  }
}
