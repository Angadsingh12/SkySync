import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';

  class WeatherAnimation {
  String  getWeatherAnimation(double temp) {
  if (temp < 0) {
  return 'Lottie/snowy.json';
  } else if (temp < 10) {
  return 'Lottie/cold.json';
  } else if (temp < 20) {
  return 'Lottie/wind.json';
  } else if (temp < 30) {
  return 'Lottie/cloudy.json';
  } else if (temp < 40) {
  return 'Lottie/sunny.json';
  } else {
  return 'Lottie/night.json';
  }
  }
  }




