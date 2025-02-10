

import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:http/http.dart 'as http;
import 'package:http/http.dart ';

class ApiHelper{

  ApiHelper._();
  static ApiHelper apiHelper=ApiHelper._();
  final api = "https://api.imgur.com/3/image/";
  final clientId = "954428364df58d9";
  final secretId = "c735c2d607fa1dd1ee44988020f30d01c02e0c8b";
  final authorizationCode = "3a5bf3d7c48efc1408681a6b2aacd8ac01af1e2d";


  Future<String?> uploadImage(Uint8List image)
  async {
    try{
      Uri uri =Uri.parse(api);
      final header={
        'Authorization':'Client-ID $clientId'
      };
      final body=base64Encode(image);
      print('body:$image');
      Response response=await http.post(uri,headers: header,body: body);
      if(response.statusCode==200)
      {
        final data=response.body;
        final map=jsonDecode(data);
        final link=map['data']['link'];
        log("==================================================${link}=============================");
        return link;

      }
      return null;
    }catch(e)
    {
      log('Error: ${e.toString()}');
    }
  }
}