import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:abodesv1/core/constants/app_colors.dart';
import 'package:go_router/go_router.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();
  final _mapController = MapController();
  bool _isLoading = false;
  LatLng? _currentLocation;
  final List<Marker> _markers = [];
  int _currentIndex = 2;

  @override
  void initState() {
    super.initState();
    _initLocationAndMarkers();
  }

  Future<void> _initLocationAndMarkers() async {
    setState(() => _isLoading = true);

    try {
      final position = await Geolocator.getCurrentPosition();
      _currentLocation = LatLng(position.latitude, position.longitude);

      _mapController.move(_currentLocation!, 14);
      _markers.add(_buildUserMarker(_currentLocation!));
      await _loadPropertyMarkers();
    } catch (e) {
      _showMessage("Location error: ${e.toString()}");
    }

    setState(() => _isLoading = false);
  }

  Marker _buildUserMarker(LatLng point) {
    return Marker(
      point: point,
      width: 40.w,
      height: 40.h,
      child: const Icon(Icons.my_location, color: Colors.blue, size: 30),
    );
  }
  void _onNavTap(int index) {
    setState(() => _currentIndex = index);
    switch (index) {
      case 0:
        context.go('/owner/home');
        break;
      case 1:
        context.go('/owner/search');
        break;
      case 2:
        context.go('/owner/manage');
        break;
      case 3:
        context.go('/owner/messages');
        break;
      case 4:
        context.go('/owner/profile');
        break;
    }
  }
  Future<void> _loadPropertyMarkers() async {
    final snapshot = await FirebaseDatabase.instance.ref('properties').get();

    if (snapshot.exists) {
      final data = snapshot.value as Map;
      for (var entry in data.entries) {
        final item = entry.value;
        if (item['latitude'] != null && item['longitude'] != null) {
          _markers.add(Marker(
            point: LatLng(item['latitude'], item['longitude']),
            width: 40.w,
            height: 40.h,
            child: Icon(
              Icons.location_on,
              color: AppColors.primary,
              size: 32.sp,
            ),
          ));
        }
      }
    }
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) return;

    setState(() => _isLoading = true);

    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=1');

    try {
      final response = await http.get(url, headers: {
        'User-Agent': 'Flutter App',
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.isNotEmpty) {
          final double lat = double.parse(data[0]['lat']);
          final double lon = double.parse(data[0]['lon']);
          _mapController.move(LatLng(lat, lon), 15);
        } else {
          _showMessage("No results found.");
        }
      } else {
        _showMessage("Failed to fetch location.");
      }
    } catch (e) {
      _showMessage("Search failed: ${e.toString()}");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }



  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text("Search Property", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.borderDefault),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: "Search places...",
                          border: InputBorder.none,
                        ),
                        style: TextStyle(fontSize: 14.sp),
                        onSubmitted: _performSearch,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _performSearch(_searchController.text),
                      child: Icon(Icons.search, color: AppColors.primary),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: _currentLocation ?? LatLng(14.5995, 120.9842),
                      initialZoom: 13,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.abodesv1',
                      ),
                      MarkerLayer(markers: _markers),
                    ],
                  ),
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator()),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.manage_accounts_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.message_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person_outlined), label: ''),
        ],
      ),
    );
  }
}
