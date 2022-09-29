import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'mainscreen.dart';
import 'pass_reset_verify.dart';
import 'secure_storage.dart';
import 'signup.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api.dart';

class loginpage extends StatefulWidget {
  const loginpage({ Key? key }) : super(key: key);

  @override
  _loginpageState createState() => _loginpageState();
}

class _loginpageState extends State<loginpage> {
final storage = new FlutterSecureStorage();

bool circular =false;
 
 _logins()async{
  
 var data ={
      
       "email":emailup.text,
       "password":passwordup.text
     };  
      
var response = await CallApi().login(data,'https://flutter-authenticate-app.herokuapp.com/login');
if(response.statusCode == 404){
   setState(() {
      circular =false;
  });
  Fluttertoast.showToast(
        msg: "No user found",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
}
else if(response.statusCode == 403){

  setState(() {
      circular =false;
  });

   Fluttertoast.showToast(
        msg: "Authentication Failed, Wrong Password",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
}
else if(response.statusCode == 200){
   setState(() {
      circular =false;
        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => mainscreen(),
                          ),
                          (route) => false);
                    
  });
await storage.write(key: "x-auth-token", value: response.body);
 var tok =  await token().gettoken();

 print("token:::::::"+tok);
  Fluttertoast.showToast(
        msg: "User logged in",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
}
}

 TextEditingController emailup = TextEditingController();
   TextEditingController passwordup = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 400,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: -40,
                    height: 400,
                    width: width,
                    child:  Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/background (1).png'),
                          fit: BoxFit.fill
                        )
                      ),
                    )),
                  
                  Positioned(
                    height: 400,
                    width: width+20,
                    child:  Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/background-2.png'),
                          fit: BoxFit.fill
                        )
                      ),
                    )
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                   Text("Login", style: TextStyle(color: Color.fromRGBO(49, 39, 79, 1), fontWeight: FontWeight.bold, fontSize: 30),),
                  SizedBox(height: 30,),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(196, 135, 198, .3),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        )
                      ]
                    ),
                    child: Column(
                      children: <Widget>[

                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(
                              color: Colors.grey.shade200
                            ))
                          ),
                          child: TextField(
                            controller: emailup,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Email",
                              hintStyle: TextStyle(color: Colors.grey)
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: TextField(
                             controller: passwordup,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Password",
                              hintStyle: TextStyle(color: Colors.grey)
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                   Center(child:TextButton(onPressed: (){
                     
       Navigator.push(context, MaterialPageRoute(builder: (_) {
              return Email_verify();
            }));
                   }, child: Text("FORGET PASSWORD"))),
                  SizedBox(height: 30,),
                   GestureDetector(
                     onTap: (){
                        setState(() {
                           circular = true;
                         });
                        _logins(); 
                        // _readtoken();
                     },
                     child: Container(
                      height: 50,
                      margin: EdgeInsets.symmetric(horizontal: 60),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Color.fromRGBO(49, 39, 79, 1),
                      ),
                      child: Center(
                        child:  circular ? CircularProgressIndicator() :Text("Login", style: TextStyle(color: Colors.white),),
                      ),
                                     ),
                   ),
                  SizedBox(height: 30,),
                  Center(child: TextButton(onPressed: (){
  Navigator.push(context, MaterialPageRoute(builder: (_) {
              return signup();
            }));
                  }, child: Text("Create Account"))),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}