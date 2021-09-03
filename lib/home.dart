import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/bloc/weather_cubit.dart';
import 'package:weather_app/bloc/weather_state.dart';
import 'package:weather_app/models/weather.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _cityName = TextEditingController();
  Weather _weather = Weather();
  var _enteredCity = "";

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('tr');
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Center(
          child: Text(
            "WeatherApp",
            style: TextStyle(color: Colors.white),
          ),
        ),
        leading: Icon(
          Icons.list_rounded,
          color: Colors.white,
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (_) => new AlertDialog(
                          title: new Text("Şehir giriniz"),
                          content: new TextField(
                            autofocus: true,
                            controller: _cityName,
                            onSubmitted: (_) async {
                              _enteredCity = _cityName.text;
                              print(_enteredCity);
                            },
                          ),
                          actions: <Widget>[
                            ElevatedButton(
                              child: Text('Onayla'),
                              onPressed: () {
                                context
                                    .read<WeatherCubit>()
                                    .getWeather(_enteredCity);
                                Navigator.pop(context);
                                _cityName.clear();
                              },
                            )
                          ],
                        ));
              })
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                    Colors.blue.shade100,
                    Colors.blue.shade700,
                  ])),
            ),
            BlocConsumer<WeatherCubit, WeatherState>(builder: (context, state) {
              if (state is WeatherInitial) {
                return Center(
                  child: Text(
                    "Lütfen şehir adı giriniz.",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                );
              } else if (state is WeatherLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is WeatherLoaded) {
                _weather = state.weather;
                return Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.07),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.05),
                        child: Container(
                          child: Column(
                            children: [
                              Text(
                                _weather.title.toString(),
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.06,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Text(
                                _weather.consolidatedWeather[0].applicableDate
                                        .day
                                        .toString() +
                                    "/" +
                                    _weather.consolidatedWeather[0]
                                        .applicableDate.month
                                        .toString() +
                                    "/" +
                                    _weather.consolidatedWeather[0]
                                        .applicableDate.year
                                        .toString(),
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.03,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.02),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: Column(
                            children: [
                              Text(
                                _weather.consolidatedWeather[0].theTemp
                                        .toInt()
                                        .toString() +
                                    " °C",
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.12,
                                    color: Colors.white),
                              ),
                              Image.network(
                                "https://www.metaweather.com//static/img/weather/png/" +
                                    _weather.consolidatedWeather[0]
                                        .weatherStateAbbr +
                                    ".png",
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
                                width:
                                    MediaQuery.of(context).size.height * 0.15,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.02),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.06,
                          child: Column(
                            children: [
                              Text(
                                _weather.consolidatedWeather[0].maxTemp
                                        .toInt()
                                        .toString() +
                                    "°C" +
                                    " / " +
                                    _weather.consolidatedWeather[0].minTemp
                                        .toInt()
                                        .toString() +
                                    "°C",
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.04,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.05),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              " Nem : %" +
                                  _weather.consolidatedWeather[0].humidity
                                      .toInt()
                                      .toString(),
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.03,
                                  color: Colors.white),
                            ),
                            Text(
                              " Basınç : " +
                                  _weather.consolidatedWeather[0].airPressure
                                      .toInt()
                                      .toString() +
                                  " hPa",
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.03,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.08),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.2,
                          color: Colors.transparent,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _weather.consolidatedWeather.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      right: MediaQuery.of(context).size.width *
                                          0.06,
                                      left: MediaQuery.of(context).size.width *
                                          0.06),
                                  child: Card(
                                    color: Colors.transparent,
                                    elevation: 0,
                                    child: Column(
                                      children: [
                                        Image.network(
                                          "https://www.metaweather.com//static/img/weather/png/" +
                                              _weather
                                                  .consolidatedWeather[index]
                                                  .weatherStateAbbr +
                                              ".png",
                                          height: 40,
                                          width: 40,
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01,
                                        ),
                                        Text(
                                            _weather.consolidatedWeather[index]
                                                    .maxTemp
                                                    .toInt()
                                                    .toString() +
                                                "°C" +
                                                " / " +
                                                _weather
                                                    .consolidatedWeather[index]
                                                    .minTemp
                                                    .toInt()
                                                    .toString() +
                                                "°C",
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.025,
                                                color: Colors.white)),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01,
                                        ),
                                        Text(
                                            DateFormat('EEEE', 'tr_TR').format(
                                                _weather
                                                    .consolidatedWeather[index]
                                                    .applicableDate),
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.025,
                                                color: Colors.white)),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Container();
              }
            }, listener: (context, state) {
              if (state is WeatherError) {
                return Center(
                  child: Text(state.message),
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}
