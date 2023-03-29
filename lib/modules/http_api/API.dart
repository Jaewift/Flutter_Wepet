import 'dart:async';
import 'package:http/http.dart' as http;

const baseUrl = "3.38.97.0:3000";

class API {
  static Future getUsers() {
    var url = baseUrl + "/communities";
    return http.get(url as Uri);
  }
}