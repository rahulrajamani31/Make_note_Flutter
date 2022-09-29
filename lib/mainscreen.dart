
import 'dart:async';
import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'api.dart';



class mainscreen extends StatefulWidget {
  const mainscreen({ Key? key }) : super(key: key);

  @override
  _mainscreenState createState() => _mainscreenState();
}
 


class _mainscreenState extends State<mainscreen> {


 Stream getnote()=> Stream.periodic(Duration(seconds: 1)).asyncMap((event) => _stream);

late StreamController _streamController;
late Stream  _stream;

final _formKey = GlobalKey<FormState>();
   TextEditingController title = TextEditingController();
   TextEditingController notes = TextEditingController();


_delnote(var deletenote )async{
dynamic data ={
        "unique":deletenote.toString(),
     };  
var response = await CallApi().delete(data,'https://flutter-authenticate-app.herokuapp.com/delete');
if(response.statusCode == 200){
  
   Fluttertoast.showToast(
        msg: "Note Deleted",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0
    );
}
}


  _notify()async{
    if(_formKey.currentState!.validate()){
   // _addnotes()async{

dynamic data ={
      "bodys":{
        "title":title.text,
        "des": notes.text
      }
     };  
      
var response = await CallApi().addnotes(data,'https://flutter-authenticate-app.herokuapp.com/add_notes');
if(response.statusCode == 200){
  //  setState(() {
  //             _fetchdata();
  //                         });
  //  Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //           builder: (BuildContext context) => super.widget));
  Fluttertoast.showToast(
        msg: "Notes Added",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0
    );
   }


else if(response.statusCode == 400){
  

  Fluttertoast.showToast(
        msg: "ERROR",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
         timeInSecForIosWeb: 2,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0
    );
}
  // }
    }
    else{
 Fluttertoast.showToast(
        msg: "Empty Fields",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0
    );
    }
  }


// var body =[];

 _fetchdata()async{
var response = await CallApi().getnotes('https://flutter-authenticate-app.herokuapp.com/get_Notes');
_streamController.add(json.decode(response.body));
}

@override
  void initState() {
  
    super.initState();

    _fetchdata();

    _streamController = StreamController();
    _stream = _streamController.stream;
  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notify',
      style: GoogleFonts.shizuru(fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.grey,
      elevation: 30,
      actions: [
       
IconButton(
  icon: Icon(Icons.add,size: 40,),
  onPressed: () async {
  //  setState(() {
  //                           _fetchdata();
  //                         });
    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      transitionDuration: Duration(milliseconds: 500),
      barrierLabel: MaterialLocalizations.of(context).dialogLabel,
      barrierColor: Colors.black.withOpacity(0.5),
      pageBuilder: (context, _, __) {
        return
         Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Card(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                     TextFormField(
                       controller: title,
                         validator: (value) {
    if (value == null || value.isEmpty) 
      return 'Enter any Title';
       return null;
  },
                        decoration: InputDecoration(
                           labelStyle: GoogleFonts.shizuru(fontWeight: FontWeight.bold),
                                   labelText:  "TITLE", 
                                 border: InputBorder.none,
                                 hintText:'ENTER TITLE',
                                hintStyle:GoogleFonts.shizuru(fontWeight: FontWeight.bold),
                                ),
                     ),
                     TextFormField(
                        controller: notes,
                        keyboardType: TextInputType.multiline,
                         maxLines: null,
                          validator: (value) {
    if (value == null || value.isEmpty) 
      return 'Enter any Notes';
       return null;
  },
                        decoration: InputDecoration(
                           labelStyle: GoogleFonts.shizuru(fontWeight: FontWeight.bold),
                                   labelText:  "NOTES",
                                    border: InputBorder.none,
                                    hintText:'ADD YOUR NOTES',
                                  hintStyle:GoogleFonts.shizuru(fontWeight: FontWeight.bold),
                                 ),
                     ),
                      Row(mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                       
                        ElevatedButton(onPressed: () {
                          // setState(() {
                          //   _fetchdata();
                          // });
                           
                            _notify();
                          setState(() {
                             if(_formKey.currentState!.validate()){ title.clear();
                            notes.clear();}
                           
                          });
                           
        //               await Navigator.pushReplacement(
        // context,
        // MaterialPageRoute(
        //     builder: (BuildContext context) => super.widget));
                        
                      }, child: Text('ADD ',style: GoogleFonts.shizuru(fontWeight: FontWeight.bold),))],)
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ).drive(Tween<Offset>(
            begin: Offset(0, -1.0),
            end: Offset.zero,
          )),
          child: child,
        );
      },
    );
  }
),

    ],
    ),
    body: StreamBuilder(
    stream: _stream,
    builder: (BuildContext ctx, AsyncSnapshot snapshot){
if(snapshot.data == null){
  return Center(child: Text('No notes '),);
}


return ListView.builder(
      
        itemCount:snapshot.data["body"].length,
        itemBuilder: (BuildContext context,int index){
         
          return ListTile(
           
            leading: Icon(Icons.list),
            trailing:IconButton(onPressed: (){ 
             setState(() {
               _delnote(snapshot.data["body"][index]["unique"]);
                          snapshot.data["body"].removeAt(index);
                          
                        });
              
            }, icon: Icon(Icons.delete)),
            title:Text(snapshot.data["body"][index]["title"]),
            isThreeLine: true,
            subtitle: Column(children: [
              Text(snapshot.data["body"][index]["des"]),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                
                children: [
                  Text(snapshot.data["body"][index]["date"]),
                  Text(snapshot.data["body"][index]["time"]),
                   Text(snapshot.data["body"][index]["unique"]),
                ],)
            ],
            ),
        
            );
        }
        );




    },)
    );
  }
}


