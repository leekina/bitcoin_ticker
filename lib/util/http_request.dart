// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:bitcoin_ticker/model/dummy.dart';
import 'package:http/http.dart' as http;

class HttpRequest {
  String url;
  HttpRequest({
    required this.url,
  });

  Future<dynamic> getData(String crypto) async {
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      String data = response.body;
      print(data);
      return jsonDecode(data);
    } else {
      print('fail${response.statusCode}');
    }
  }

  Future<dynamic> getDataFromDummy(String crypto) async {
    Future.delayed(Duration(milliseconds: 50));
    for (int i = 0; i < dummy.length; i++) {
      if (dummy[i]['asset_id_base'] == crypto) {
        return dummy[i];
      }
    }
  }
}
