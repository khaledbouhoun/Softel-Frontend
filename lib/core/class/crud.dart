import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:softel/core/functions/checkinternet.dart';
import 'package:http/http.dart' as http;
import 'package:softel/core/services/services.dart';

class Crud {
  MyServices myServices = Get.find<MyServices>();
  final storage = FlutterSecureStorage();

  Future<String?> getToken() async {
    return await storage.read(key: "token");
  }

  /// POST
  Future<Response> post(String linkurl, Map<String, dynamic> data) async {
    String? token = await getToken();

    if (await checkInternet()) {
      try {
        var response = await http.post(
          Uri.parse(linkurl),
          headers: {'Content-Type': 'application/json', 'Accept': 'application/json', 'X-Auth-Token': token ?? ''},
          body: jsonEncode(data),
        );

        print("[POST]Request URL: $linkurl");
        print("[POST]Request body: $data");
        print("[POST]Response: ${response.body}");

        return Response(statusCode: response.statusCode, body: jsonDecode(response.body));
      } catch (e) {
        throw Exception('[POST] Server exception: $e');
      }
    } else {
      throw Exception('[POST] No internet connection');
    }
  }

  /// GET
  Future<Response> get(String linkurl) async {
    String? token = await getToken();

    if (await checkInternet()) {
      try {
        var response = await http.get(Uri.parse(linkurl), headers: {'Accept': 'application/json', 'X-Auth-Token': token ?? ''});

        print("[GET]Request URL: $linkurl");
        print("[GET]Response: ${response.body}");

        return Response(statusCode: response.statusCode, body: jsonDecode(response.body));
      } catch (e) {
        throw Exception('[GET] Server exception: $e');
      }
    } else {
      throw Exception('[GET] No internet connection');
    }
  }

  /// DELETE
  Future<Response> delete(String linkurl, Map<String, dynamic> data) async {
    String? token = await getToken();

    if (await checkInternet()) {
      try {
        var response = await http.delete(
          Uri.parse(linkurl),
          headers: {'Content-Type': 'application/json', 'Accept': 'application/json', 'X-Auth-Token': token ?? ''},
          body: jsonEncode(data),
        );

        return Response(statusCode: response.statusCode, body: jsonDecode(response.body));
      } catch (e) {
        throw Exception('[DELETE] Server exception: $e');
      }
    } else {
      throw Exception('[DELETE] No internet connection');
    }
  }
}
