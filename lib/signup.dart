import 'package:email_auth/email_auth.dart';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:email_validator/email_validator.dart';
import 'auth.config.dart';
import 'login_page.dart';
import 'verification.dart';

import 'api.dart';



class signup extends StatefulWidget {
  const signup({ Key? key }) : super(key: key);

  @override
  _signupState createState() => _signupState();
}


class _signupState extends State<signup> {
bool circular =false;
late EmailAuth emailAuth;
 final _formKey = GlobalKey<FormState>();
bool validate =false;

   TextEditingController namein = TextEditingController();
   TextEditingController emailin = TextEditingController();
   TextEditingController passwordin = TextEditingController();
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
}

 void sendOtp() async {

await emailAuth.sendOtp(
      recipientMail: emailin.value.text, otpLength: 4
      );

  }

   _register()async{
  if(await _main()&&_formKey.currentState!.validate()){
var data ={
       "email":emailin.text,
     };  
      
var response = await CallApi().getinfo(data,'https://flutter-authenticate-app.herokuapp.com/user');
if(response.statusCode == 400){
   setState(() {
      circular =false;
  });
  Fluttertoast.showToast(
        msg: "User Already Registered",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0
    );
}

else if(response.statusCode == 200){
  sendOtp();
   setState(() {
      circular =false;
        Navigator.push(context, MaterialPageRoute(builder: (_) {
              return Verificatoin(email: emailin.text, password: passwordin.text, username: namein.text,);
            }));
  });
  

  Fluttertoast.showToast(
        msg: "OTP sent ",
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
	              height: 400,
	              decoration: BoxDecoration(
	                image: DecorationImage(
	                  image: AssetImage('assets/background.png'),
	                  fit: BoxFit.fill
	                )
	              ),
	              child: Stack(
	                children: <Widget>[
	                  Positioned(
	                    left: 30,
	                    width: 80,
	                    height: 200,
	                    child: Container(
	                      decoration: BoxDecoration(
	                        image: DecorationImage(
	                          image: AssetImage('assets/light-1.png')
	                        )
	                      ),
	                    ),
	                  ),
	                  Positioned(
	                    left: 140,
	                    width: 80,
	                    height: 150,
	                    child: Container(
	                      decoration: BoxDecoration(
	                        image: DecorationImage(
	                          image: AssetImage('assets/light-2.png')
	                        )
	                      ),
	                    ),
	                  ),
	                  Positioned(
	                    right: 40,
	                    top: 40,
	                    width: 80,
	                    height: 150,
	                    child:  Container(
	                      decoration: BoxDecoration(
	                        image: DecorationImage(
	                          image: AssetImage('assets/clock.png')
	                        )
	                      ),
	                    ),
	                  ),
	                  Positioned(
	                    child:  Container(
	                      margin: EdgeInsets.only(top: 50),
	                      child: Center(
	                        child: Text("SIGN UP", style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),),
	                      ),
	                    )),
	                  
	                ],
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
                                                      
                               maxLength: 20,
                               controller: namein,
                               validator: (value) {
    if (value == null || value.isEmpty) 
      return 'Please enter username';
    
     if(value.length < 5) return "Username should be minimum 6letters";

    return null;
  },
                                                      decoration: InputDecoration(
                                 labelText:  "USERNAME",
                                                        border: InputBorder.none,
                                                        hintText:'Enter your username',
                                                        hintStyle: TextStyle(color: Colors.grey[400])
                                                      ),
                                      
                            //  onSubmitted: (_) {
                            //            namein.clear();
                            //           },
                                                    ),
                      
                                                  ),
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
                                      //     onChanged: (val) {
                                      //   email = val;
                                      // },
                                    //  onSubmitted: (_) {
                                    //    emailin.clear();
                                    //   },
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.all(8.0),
                                                    child: TextFormField(
                              
                               maxLength: 80,
                               controller: passwordin,
                                 validator: (value) {
    if (value == null || value.isEmpty) 
      return 'Please enter password';
    
     if(value.length < 6) return "password should be minimum 6letters";
     
    return null;
  },
                                                      decoration: InputDecoration(
                                  labelText:"PASSWORD" ,
                                                        border: InputBorder.none,
                                                        hintText: 'Enter your password',
                                                        hintStyle: TextStyle(color: Colors.grey[400])
                                                      ),
                                    // onChanged: (val) {
                                    //     password = val;
                                    //   },
                                      //  onSubmitted: (_) {
                                      //  passwordin.clear();
                                      // },
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
                          if (_formKey.currentState!.validate()) {
                setState(() {
                  circular =true;
                });
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Processing Data')),
        
      // );
      _register();
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
                               Color.fromRGBO(143, 148, 251, 1),
                               Color.fromRGBO(143, 148, 251, .6),
                                 ]
                           )
                      ),
                           child: Center(

           child: circular ? CircularProgressIndicator() : Text("Sign up", style: 
           TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                             ),
                                         ),
                                          ),
	                  SizedBox(height: 30,),
	                  Center(child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
	                    children: [
                      
	                      Text("Already have an account?", style: TextStyle(color: Colors.black),),
                        TextButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return loginpage();
            }));

                        }, child: Text("LOGIN"))
	                    ],
	                  )),
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
