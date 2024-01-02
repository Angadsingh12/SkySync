import 'package:climia/models/weather_model.dart';
import 'package:climia/services/constants.dart';
import 'package:climia/services/location.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:climia/services/networking.dart';
import 'package:climia/services/weather.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;
  WeatherModel? weatherModel;
  String? data;
  String? cityName;
  int? temprature;
  String? weatherSeason;

  @override
  void initState() {
    super.initState();
    fetchData(); // No need to await here
  }

  Future<void> fetchData() async {
    try {
      setState(() {
        isLoading = true; // Set loading to true before fetching data
      });

      Location location = Location();
      await location.getLocation();
      double? longitude = location.longitude;
      double? latitude = location.latitude;
      print(latitude);
      print(longitude);

      Networking networking = Networking(
        url:
            'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apikey&units=metric',
      );

      final receivedData = await networking.getLocationData();
      if (receivedData != null) {
        setState(() {
          weatherModel = receivedData;
          cityName = receivedData.name;
          data = WeatherAnimation()
              .getWeatherAnimation(weatherModel?.main?.temp ?? 0.0);
          temprature = receivedData.main?.temp?.toInt();
          weatherSeason = receivedData.weather?[0].description;
        });
        print(receivedData);
      }
    } on Exception catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false; // Set loading to false after fetching data
      });
    }
  }

  void updateData() {
    Networking networking = Networking(
      url:
      'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apikey&units=metric'
    );
    setState(() async{
      final receivedData = await networking.getLocationData();
      if (receivedData != null) {
        setState(() {
          weatherModel = receivedData;
          cityName = receivedData.name;
          data = WeatherAnimation()
              .getWeatherAnimation(weatherModel?.main?.temp ?? 0.0);
          temprature = receivedData.main?.temp?.toInt();
          weatherSeason = receivedData.weather?[0].description;
        });
    }

    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: SpinKitChasingDots(
                size: 30,
                color: Colors.white,
              ),
            )
          : SafeArea(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(25),
                child: Column(
                  children: [
                    TextField(
                      onChanged: (value){
                        cityName = value;
                        updateData();
                      },
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        hintText: 'Enter your Text here',
                        hintStyle: const TextStyle(
                          color: Colors.black,
                        ),
                        prefixIcon: const Icon(Icons.search),
                        prefixIconColor: Colors.black87,
                      ),
                    ),
              
                    Container(
                      padding: const EdgeInsets.only(top: 30),
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Today's report in",
                          style: GoogleFonts.roboto(
                              fontSize: 22,
                              color: Colors.white70,
                              fontWeight: FontWeight.w900),
                        )),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Text(cityName ?? 'no data found',
                              style: GoogleFonts.roboto(
                                  color: Colors.white70,
                                  fontSize: 20,
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.w700)),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async{
                             await fetchData();
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(left: 100),
                              child: Icon(
                                CupertinoIcons.location_solid,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        '\n(${DateFormat('KK:mm').format(DateTime.now())})',
                        style: GoogleFonts.roboto(
                            color: Colors.white70,
                            fontSize: 15,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    SizedBox(height: 40,),
                    Container(
                      padding: const EdgeInsets.only(top: 20),
                      child: Center(child: Lottie.asset(data!)),
                    ),
                    Text(
                      "It's $weatherSeason\n",
                      style: GoogleFonts.getFont('Montserrat',
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white70),
                    ),
              
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.getFont(
                          'Montserrat',
                          fontSize: 50.0,
                          fontWeight: FontWeight.w600,
                        ),
                        children: [
                          TextSpan(
                            text: temprature.toString(),
                          ),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Transform.translate(
                              offset: const Offset(0.0,
                                  -8.0), // Adjust the offset for proper alignment
                              child: const Text(
                                '°',
                                style: TextStyle(
                                  fontSize: 35.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],

                ),
              ),

            ),
          ),
    );
  }
}
