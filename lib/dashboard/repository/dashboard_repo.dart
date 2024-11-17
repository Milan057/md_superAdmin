import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../exceptions/general_exception.dart';
import '../../http/timeoutClient.dart';
import '../model/DashboardModel.dart';
import 'package:http/http.dart' as http;
import 'package:md_customer/values/values.dart';

class DashboardRepo {
  Future<DashboardModel> fetchOperatorStatus() async {
    FlutterSecureStorage storage = FlutterSecureStorage();
    String tokenValue = await storage.read(key: "token") ?? "";
    String id = await storage.read(key: "id") ?? "";
    final headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer $tokenValue",
    };
    String url = "http://$ip:8080/superAdmin/fetchBusAdminStatus";
    print(url);

    TimeoutHttpClient client =
        TimeoutHttpClient(http.Client(), timeout: Duration(seconds: 10));

    try {
      final response = await client.get(Uri.parse(url), headers: headers);
      print(response.statusCode);
      if (response.statusCode == 200) {
        var decoded = jsonDecode(response.body);
        return DashboardModel(
          statusCode: response.statusCode,
          total: decoded['total'].toString(),
          active: decoded['active'].toString(),
          inactive: decoded['inactive'].toString(),
        );
      } else if (response.statusCode == 403) {
        throw GeneralException(
            "Client: Please Relogin to Continue the Service!");
      } else {
        throw GeneralException(response.body);
      }
    } on TimeoutException catch (e) {
      client.close();
      throw GeneralException("Request Time Out! Please Try Again!");
    } on SocketException catch (e) {
      client.close();
      throw GeneralException("Please Check your Internet Connection");
    } catch (e) {
      client.close();
      throw GeneralException("Client: Something Went Wrong!");
    }
  }
}
