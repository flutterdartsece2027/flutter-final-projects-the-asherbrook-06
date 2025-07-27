// packages
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fixit/variables.dart';
import 'dart:developer';
import 'dart:convert';
import 'dart:async';

enum CameraFollowMode { none, focusOnce, autoFollowLocked }

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with WidgetsBindingObserver {
  final Completer<GoogleMapController> _mapController = Completer<GoogleMapController>();
  CameraFollowMode _cameraFollowMode = CameraFollowMode.none;
  GoogleMapController? _controller;

  Location locationController = Location();
  static LatLng? _currentLocation;

  Map<PolylineId, Polyline> polylines = {};
  List<Map<String, dynamic>> nearbyCenters = [];

  Future<void> getLocationUpdates() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await locationController.requestService();
      if (!serviceEnabled) return;
    }

    permissionGranted = await locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationController.onLocationChanged.listen((LocationData currentLocation) {
      if (currentLocation.latitude != null && currentLocation.longitude != null) {
        final newLocation = LatLng(currentLocation.latitude!, currentLocation.longitude!);

        setState(() {
          _currentLocation = newLocation;
        });

        if (_cameraFollowMode == CameraFollowMode.autoFollowLocked || _cameraFollowMode == CameraFollowMode.focusOnce) {
          cameraToPostion(newLocation);

          if (_cameraFollowMode == CameraFollowMode.focusOnce) {
            _cameraFollowMode = CameraFollowMode.none;
          }
        }
      }
    });
  }

  Future<void> cameraToPostion(LatLng pos) async {
    final controller = await _mapController.future;
    CameraPosition newCameraPosition = CameraPosition(target: pos, zoom: 16);
    await controller.animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
  }

  Future<void> addAutoServiceCenter(String name, LatLng location) async {
    await FirebaseFirestore.instance.collection('auto_service_centers').add({
      'name': name,
      'latitude': location.latitude,
      'longitude': location.longitude,
      'timestamp': Timestamp.now(),
    });
  }

  Future<void> fetchNearbyCenters() async {
    if (_currentLocation == null) return;

    final snapshot = await FirebaseFirestore.instance.collection('auto_service_centers').get();
    List<Map<String, dynamic>> temp = [];

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final LatLng centerPos = LatLng(data['latitude'], data['longitude']);
      double distance = Geolocator.distanceBetween(
        _currentLocation!.latitude,
        _currentLocation!.longitude,
        centerPos.latitude,
        centerPos.longitude,
      );

      if (distance <= 5000) {
        temp.add({...data, 'id': doc.id});
      }
    }

    setState(() {
      nearbyCenters = temp;
    });
  }

  Future<List<LatLng>> getPolyLinePoint(LatLng start, LatLng end) async {
    List<LatLng> polyLineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints(apiKey: GOOGLE_MAPS_API);
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      request: PolylineRequest(
        origin: PointLatLng(start.latitude, start.longitude),
        destination: PointLatLng(end.latitude, end.longitude),
        mode: TravelMode.driving,
      ),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polyLineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      log("Error generating Polyline");
    }

    return polyLineCoordinates;
  }

  void generatePolylineFromPoints(List<LatLng> polyLineCoordinates) async {
    PolylineId id = PolylineId("poly");
    Polyline polyLine = Polyline(
      polylineId: id,
      color: Theme.of(context).colorScheme.primary,
      points: polyLineCoordinates,
      width: 8,
    );

    setState(() {
      polylines[id] = polyLine;
    });
  }

  void drawPathToServiceCenter(LatLng destination) async {
    if (_currentLocation == null) return;

    final routePoints = await getPolyLinePoint(_currentLocation!, destination);
    generatePolylineFromPoints(routePoints);

    _cameraFollowMode = CameraFollowMode.autoFollowLocked;
    cameraToPostion(destination);
  }

  void _applyMapStyle() {
    if (_controller == null) return;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final style = isDarkMode ? jsonEncode(MAP_STYLE_DARK) : jsonEncode(MAP_STYLE_LIGHT);
    _controller!.setMapStyle(style);
  }

  Future<BitmapDescriptor> getCustomMarker() async {
    return await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(48, 48)), 'assets/circle_marker.png');
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getLocationUpdates().then((_) => fetchNearbyCenters());
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    _applyMapStyle();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () {
              if (_currentLocation != null) {
                setState(() {
                  _cameraFollowMode = CameraFollowMode.focusOnce;
                });
                cameraToPostion(_currentLocation!);
              }
            },
            onDoubleTap: () {
              if (_currentLocation != null) {
                setState(() {
                  _cameraFollowMode = CameraFollowMode.autoFollowLocked;
                });
                cameraToPostion(_currentLocation!);
              }
            },
            child: FloatingActionButton(
              mini: true,
              heroTag: "center_btn",
              backgroundColor: _cameraFollowMode == CameraFollowMode.autoFollowLocked
                  ? Theme.of(context).colorScheme.primary.withOpacity(0.9)
                  : Theme.of(context).colorScheme.primaryContainer.withOpacity(0.9),
              onPressed: null,
              child: Icon(
                _cameraFollowMode == CameraFollowMode.autoFollowLocked ? Icons.navigation : Icons.my_location,
                color: _cameraFollowMode == CameraFollowMode.autoFollowLocked
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ),

          FloatingActionButton.extended(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.9),
            onPressed: () async {
              if (_currentLocation == null) return;

              final TextEditingController nameController = TextEditingController();

              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Enter Garage Name'),
                    content: TextField(
                      controller: nameController,
                      decoration: InputDecoration(hintText: "e.g., John's Auto Repair"),
                    ),
                    actions: [
                      TextButton(child: Text("Cancel"), onPressed: () => Navigator.of(context).pop()),
                      TextButton(
                        child: Text("Add"),
                        onPressed: () async {
                          final name = nameController.text.trim();
                          if (name.isNotEmpty) {
                            Navigator.of(context).pop();
                            await addAutoServiceCenter(name, _currentLocation!);
                            await fetchNearbyCenters();
                          }
                        },
                      ),
                    ],
                  );
                },
              );
            },
            label: Text("Add Garage"),
            icon: Icon(Icons.add_home_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            _currentLocation == null
                ? Center(child: CupertinoActivityIndicator(color: Theme.of(context).colorScheme.primary, radius: 14))
                : GoogleMap(
                    zoomControlsEnabled: false,
                    onMapCreated: (GoogleMapController controller) {
                      _controller = controller;
                      _mapController.complete(controller);
                      _applyMapStyle();
                    },
                    onCameraMoveStarted: () {
                      if (_cameraFollowMode == CameraFollowMode.autoFollowLocked) return;

                      if (_cameraFollowMode != CameraFollowMode.none) {
                        setState(() {
                          _cameraFollowMode = CameraFollowMode.none;
                        });
                      }
                    },
                    initialCameraPosition: CameraPosition(target: _currentLocation!, zoom: 15),
                    markers: {
                      Marker(
                        markerId: MarkerId("_currentLocation"),
                        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                        infoWindow: InfoWindow(title: "You"),
                        position: _currentLocation!,
                      ),
                      ...nearbyCenters.map(
                        (center) => Marker(
                          markerId: MarkerId(center['id']),
                          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                          position: LatLng(center['latitude'], center['longitude']),
                          infoWindow: InfoWindow(title: center['name']),
                          onTap: () => drawPathToServiceCenter(LatLng(center['latitude'], center['longitude'])),
                        ),
                      ),
                    },
                    polylines: Set.from(polylines.values),
                  ),
            Padding(
              padding: EdgeInsets.all(8),
              child: SearchBar(
                hintText: "Search Auto Service",
                leading: Icon(Icons.search),
                onChanged: (query) {
                  setState(() {
                    nearbyCenters = nearbyCenters
                        .where((center) => center['name'].toLowerCase().contains(query.toLowerCase()))
                        .toList();
                  });
                },
                shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
