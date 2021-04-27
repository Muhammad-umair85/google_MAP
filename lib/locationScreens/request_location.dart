import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class RequestAddress{
  static Future<dynamic> getRequest(String url) async{
    http.Response response=await http.get(url);
    try{
      if(response.statusCode == 200){
        String jData=response.body;
        var decodeData=jsonDecode(jData);
        return decodeData;

      }else{
        return "failed";
      }
    }catch(ex){
      return "failed";

    }
  }
}