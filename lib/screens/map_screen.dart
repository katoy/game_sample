// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(35.681236, 139.767125),
    zoom: 15.4746,
  );

  static const CameraPosition _kTokyo = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(35.681236, 139.767125),
      tilt: 59.440717697143555,
      zoom: 15.151926040649414);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(right: 48.0, bottom: 8),
        child: FloatingActionButton.extended(
          onPressed: _goToTokyo,
          label: const Text('To 東京'),
          icon: const Icon(Icons.directions_boat),
        ),
      ),
    );
  }

  Future<void> _goToTokyo() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kTokyo));
  }
}
