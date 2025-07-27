// packages
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

// models
import 'package:fixit/models/AutoServiceCenter.dart';

// services
import 'package:fixit/service/AutoServiceCenterService.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<AutoServiceCenter> _nearbyCenters = [];

  @override
  void initState() {
    super.initState();
    _loadNearbyCenters();
  }

  Future<void> _loadNearbyCenters() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission = await Geolocator.requestPermission();

    if (serviceEnabled && (permission == LocationPermission.always || permission == LocationPermission.whileInUse)) {
      final position = await Geolocator.getCurrentPosition();
      final currentLocation = LatLng(position.latitude, position.longitude);

      final centers = await fetchNearbyCentersSorted(currentLocation);
      setState(() {
        _nearbyCenters = centers;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _loadNearbyCenters,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Text("Problem with your Car?", style: Theme.of(context).textTheme.headlineMedium),
                Text("Find a Specialist", style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 16),
                Container(
                  height: 310,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Near you", style: Theme.of(context).textTheme.headlineSmall),
                      const Divider(),
                      SizedBox(
                        height: 240,
                        child: _nearbyCenters.isEmpty
                            ? Center(child: CircularProgressIndicator())
                            : ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _nearbyCenters.length,
                                itemBuilder: (context, index) {
                                  final garage = _nearbyCenters[index];
                                  return SpecialistCard(
                                    garageName: garage.name,
                                    distance: double.parse((garage.distance! / 1000).toStringAsFixed(2)),
                                    imageURL: "",
                                  );
                                },
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

class SpecialistCard extends StatelessWidget {
  const SpecialistCard({super.key, required this.garageName, this.distance, this.imageURL});

  final String garageName;
  final String? imageURL;
  final double? distance;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 160,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                (imageURL != null && imageURL != "")
                    ? imageURL!
                    : "https://www.garageliving.com/hs-fs/hubfs/garage-remodels-garage-improvement-month.jpg",
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 16),
          Text("  $garageName", style: Theme.of(context).textTheme.bodyLarge, overflow: TextOverflow.ellipsis),
          if (distance != null) Text("   ${distance.toString()} km", style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
