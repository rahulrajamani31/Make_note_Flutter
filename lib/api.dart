import 'dart:convert' ;
import 'package:http/http.dart' as http;

import 'secure_storage.dart';


class CallApi{
 
postData(data,apiUrl)async {
    var response = await http.post(Uri.parse(apiUrl),
   body: jsonEncode(data),
   headers: _setHeaders(),
   );

   return response;
}
_setHeaders()=>{
  "content-type":"application/json",
  "Accept":"application/json",
};

login(data,apiUrl)async {
    var response = await http.post(Uri.parse(apiUrl),
   body: jsonEncode(data),
   headers: _setHeaders(),
   );

   return response;
}

getinfo(data,apiUrl)async {
    var response = await http.post(Uri.parse(apiUrl),
    body: jsonEncode(data),
    headers: _setHeaders(),
   );

   return response;
}


  getnotes(apiUrl)async {
   var tokens = await token().gettoken();
    final response = await http.get(Uri.parse(apiUrl),
    headers:  {
  "content-type":"application/json",
  "Accept":"application/json",
  "x-auth-token":tokens
},);
 return response ;
}

updatepass(data,apiUrl)async{
  var response =await http.put(Uri.parse(apiUrl),
  body: jsonEncode(data),
  headers: _setHeaders(),
  );
  return response;
}

addnotes(data,apiUrl)async{
  var tokens = await token().gettoken();
  var response = await http.put(Uri.parse(apiUrl),body: jsonEncode(data),
  headers: {
  "content-type":"application/json",
  "Accept":"application/json",
  "x-auth-token":tokens
},);
  return response;
}

delete(data,apiUrl)async{
  var tokens = await token().gettoken();
  var response = await http.delete(Uri.parse(apiUrl),body: jsonEncode(data),
  headers: {
  "content-type":"application/json",
  "Accept":"application/json",
  "x-auth-token":tokens
},);
  return response;
}
}