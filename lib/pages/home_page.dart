import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:trackingapp/model/location_model.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage();

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {

  int refreshLocationSeconds = 2;
  bool stopSendingLocalization = false;
  Timer? _timer;
  LocationModel? currentLocation;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("TrackingApp")),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                startTracking();
              },
              child: Text('Start'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(26.0),
            child: ElevatedButton(
              onPressed: () {
                stopTracking();
              },
              child: Text('Stop'),
            ),
          ),
        ]
      ),
    );
  }

  void startTracking() {
    stopSendingLocalization = false;
    _timer = Timer.periodic(Duration(seconds: refreshLocationSeconds), (timer) {
    getCurrentLocation();
    if (stopSendingLocalization) {
      if (_timer != null) {
        _timer!.cancel();
      }
    }
    });
  }

  void stopTracking() {
    stopSendingLocalization = true;
  }

  void getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Location Service Disabled'),
          content: Text('Please enable location services.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Location Permission Denied'),
            content: Text('Please grant location permission.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
        );
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high,);
    setState(() {
      currentLocation = LocationModel(
        latitude: position.latitude,
        longitude: position.longitude,
      );
      print("Latitude: ${currentLocation!.latitude}");
      print("Longitude: ${currentLocation!.longitude}");
      // sendToApi(currentLocation); //TODO: Send to api
    });
  }
}
