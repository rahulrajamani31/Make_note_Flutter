import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'api.dart';
import 'login_page.dart';

class pass_verify extends StatefulWidget {
 final String email;
 pass_verify({required this.email});

  @override
  _pass_verifyState createState() => _pass_verifyState();
}

class _pass_verifyState extends State<pass_verify> {

  bool circular =false;

 final _formKey = GlobalKey<FormState>();
bool validate =false;
 

   TextEditingController password = TextEditingController();
   TextEditingController repassword = TextEditingController();


   _changepass()async{
  if(password.text == repassword.text){
var data ={
  "email":widget.email,
       "password":repassword.text,
     };  
      
var response = await CallApi().updatepass(data,'https://flutter-authenticate-app.herokuapp.com/update_password');
if(response.statusCode == 200){
  
   setState(() {
      circular =false;
  });
    Navigator.push(context, MaterialPageRoute(builder: (_) {
              return loginpage();
            }));
  Fluttertoast.showToast(
        msg: "Password Sucessfully Changed",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0
    );
}

else if(response.statusCode == 404){
  
   setState(() {
      circular =false;
       
  });
  

  Fluttertoast.showToast(
        msg: "VALIDATIONS FAILED",
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
        msg: "Enter  same value in both fields",
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
	                  image: NetworkImage('https://ouch-cdn2.icons8.com/ElwUPINwMmnzk4s2_9O31AWJhH-eRHnP9z8rHUSS5JQ/rs:fit:784:784/czM6Ly9pY29uczgu/b3VjaC1wcm9kLmFz/c2V0cy9zdmcvNzkw/Lzg2NDVlNDllLTcx/ZDItNDM1NC04YjM5/LWI0MjZkZWI4M2Zk/MS5zdmc.png'),
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
                               maxLength: 30,
                              controller: password,     
                                validator: (value) {
    if (value == null || value.isEmpty) 
      return 'Please enter password';
    
     if(value.length < 5) return "password should be minimum 6 letters";
     
    return null;
  },                      
                                                      decoration: InputDecoration(
                                 labelText: "PASSWORD" ,
                                                        border: InputBorder.none,
                                                        hintText:'Enter your Password',
                                                        hintStyle: TextStyle(color: Colors.grey[400])
                                                      ),
                                      
                                                    ),
                                                  ),
                                                 
                                                  Container(
                                                    padding: EdgeInsets.all(8.0),
                                                    child:   TextFormField(
                                validator: (value) {
    if (value == null || value.isEmpty) 
      return 'Please enter password';
    
     if(value.length < 5) return "password should be minimum 6 letters";
     
    return null;
  },                      
                              controller: repassword,
	                            decoration: InputDecoration(
                                labelText:  "CONFIRM PASSWORD",
	                              border: InputBorder.none,
	                              hintText:'Re-Enter Password',
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

                                   if (_formKey.currentState!.validate()) {
                setState(() {
                  circular =true;
                });
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Processing Data')),
        
      // );
     _changepass();    
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

           child: circular ? CircularProgressIndicator() : Text("Update Password", style: 
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