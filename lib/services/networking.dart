import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:climia/models/weather_model.dart';

class Networking {
  Networking({required this.url});

  String? url;

  Future<WeatherModel?> getLocationData() async {

    try {
      http.Response response = await http.get(Uri.parse(url!));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        final decodedData = WeatherModel.fromJson(data);
        return decodedData;
      }
      return null;
    } catch (e) {
      print(e);
    }
  }
}
