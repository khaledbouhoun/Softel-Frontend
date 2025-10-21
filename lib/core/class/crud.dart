import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:softel/core/functions/checkinternet.dart';
import 'package:http/http.dart' as http;
import 'package:softel/core/services/services.dart';

class Crud {
  MyServices myServices = Get.find<MyServices>();
  final storage = FlutterSecureStorage();

  /// POST request for Laravel API (application/json)
  Future<Response> post(String linkurl, Map<String, dynamic> data) async {
    // String token = myServices.sharedPreferences.getString("token") ?? "ydKqvkG5pVzUzptKYZ13WyWBqvBP3DHzTIUYVzwXc7eeb61a";
    String? token = await storage.read(key: "token");

    if (await checkInternet()) {
      try {
        var response = await http.post(
          Uri.parse(linkurl),
          headers: {'Content-Type': 'application/json', 'Accept': 'application/json', 'Authorization': 'Bearer $token'},
          body: jsonEncode(data),
        );
        print("Response status code: ${response.statusCode}");
        print("Response body: ${response.body}");
        print("Request URL: $linkurl");

        return Response(statusCode: response.statusCode, body: jsonDecode(response.body));
      } catch (e) {
        print("Error in POST request: $e");
        throw Exception('Server exception: $e');
      }
    } else {
      print("No internet connection");
      throw Exception('No internet connection');
    }
  }

  /// GET request for Laravel API (application/json)
  Future<Response> get(String linkurl) async {
    // String token = myServices.sharedPreferences.getString("token") ?? "ydKqvkG5pVzUzptKYZ13WyWBqvBP3DHzTIUYVzwXc7eeb61a";
    String? token = await storage.read(key: "token");

    if (await checkInternet()) {
      try {
        // Convert data map to query parameters
        var response = await http.get(
          Uri.parse(linkurl),
          headers: {'Content-Type': 'application/json', 'Accept': 'application/json', 'Authorization': 'Bearer $token'},
        );
        print("Response status code: ${response.statusCode}");
        print("Response body: ${response.body}");
        print("Request URL: $linkurl");

        return Response(statusCode: response.statusCode, body: jsonDecode(response.body));
      } catch (e) {
        print("Error in POST request: $e");
        throw Exception('Server exception: $e');
      }
    } else {
      print("No internet connection");
      throw Exception('No internet connection');
    }
  }

  Future<Response> delete(String linkurl, Map<String, dynamic> data) async {
    String? token = await storage.read(key: "token");

    if (await checkInternet()) {
      try {
        var response = await http.delete(
          Uri.parse(linkurl),
          headers: {'Content-Type': 'application/json', 'Accept': 'application/json', 'Authorization': 'Bearer $token'},
          body: jsonEncode(data),
        );
        print("Response status code: ${response.statusCode}");
        print("Response body: ${response.body}");
        print("Request URL: $linkurl");

        return Response(statusCode: response.statusCode, body: jsonDecode(response.body));
      } catch (e) {
        print("Error in DELETE request: $e");
        throw Exception('Server exception: $e');
      }
    } else {
      print("No internet connection");
      throw Exception('No internet connection');
    }
  }

  Future<Map<String, dynamic>> postDatasimple(String linkurl, Map data) async {
    if (await checkInternet()) {
      try {
        var response = await http.post(Uri.parse(linkurl), body: data);
        if (response.statusCode == 200 || response.statusCode == 201) {
          Map responsebody = jsonDecode(response.body);
          return Map<String, dynamic>.from(responsebody);
        } else {
          throw Exception('Failed to load data');
        }
      } catch (e) {
        throw Exception('Server exception: $e');
      }
    } else {
      throw Exception('No internet connection');
    }
  }
}
