// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class MeteoService {
  fetchMeteo() async {
      final reponse= await http.get(
        Uri.parse("https://api.openweathermap.org/data/2.5/weather?lat=17.5797575&lon=-3.998823000000016&appid=898a3574452872735b5f14546efa0cc3")
        );
        try {
          if(reponse.statusCode == 200) {
            jsonDecode(reponse.body);
            // return WeatherData.fromJson(json);
          }
        }
        catch (error) {
          if (kDebugMode) {
            print('Error: $error');
          }
        }
      return reponse.body;
  }
}