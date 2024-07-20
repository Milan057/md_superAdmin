import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:md_customer/commons/models/common_model.dart';
import 'package:md_customer/exceptions/general_exception.dart';
import 'package:md_customer/login/model/login_model.dart';
import 'package:http/http.dart' as http;
import 'package:md_customer/http/timeoutClient.dart';
import 'package:md_customer/login/views/login.dart';
import 'package:md_customer/values/values.dart';

class AddNewBusRepository {
  Future<CommonModel> addNewBusAdmin(
      String fullName, String shortName, String email, String phone) async {
    final body = jsonEncode({
      'fullName': fullName,
      'phoneNumber': phone,
      'email': email,
      "shortName": shortName
    });
    FlutterSecureStorage storage = FlutterSecureStorage();
    String tokenValue = await storage.read(key: "token") ?? "";

    final headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer $tokenValue",
    };

    const url = "http://$ip:8080/superAdmin/saveBusAdmin";
    TimeoutHttpClient client =
        TimeoutHttpClient(http.Client(), timeout: Duration(seconds: 10));

    try {
      final response =
          await client.post(Uri.parse(url), headers: headers, body: body);
      if (response.statusCode == 201) {
        return CommonModel(statusCode: 201);
      } else if (response.statusCode == 409) {
        Map decoded = jsonDecode(response.body);
        return CommonModel(
            statusCode: 409,
            message: decoded['message'],
            responseType: decoded['responseType']);
      } else {
        return CommonModel(statusCode: response.statusCode);
      }
    } on TimeoutException catch (e) {
      throw GeneralException("Request Time Out! Please Try Again!");
    } on SocketException catch (e) {
      throw GeneralException("Please Check your Internet Connection");
    } catch (e) {
      print(e);
      throw GeneralException("Client: Something Went Wrong!");
    }
  }
}
