
import 'package:abodesv1/features/listings/apartments.dart';
import 'package:abodesv1/features/owner/presentation/pages/manage_properties.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:abodesv1/features/owner/presentation/pages/settings.dart';
import 'package:abodesv1/features/auth/presentation/pages/search_page.dart';
import 'package:abodesv1/config/routes/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:abodesv1/features/chat/messages_list.dart';
import 'package:abodesv1/core/constants/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../listings/boardinghouse.dart';

final auth = FirebaseAuth.instance;
final uid = auth.currentUser?.uid;


class OwnerHomePage extends StatefulWidget {
  final String? ownerId;
  final String? seekerId;
  const OwnerHomePage({super.key, this.ownerId, this.seekerId});

  @override
  State<OwnerHomePage> createState() => _OwnerHomePageState();
}

class _OwnerHomePageState extends State<OwnerHomePage> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref('properties');
  List<Map> _properties = [];
  bool _loading = true;
  String? _error;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchProperties();
    _dbRef.onValue.listen((event) {
      final data = event.snapshot.value;
      if (data != null && data is Map) {
        final properties = Map<String, dynamic>.from(data);
        setState(() {
          _properties = properties.entries.map((entry) {
            final item = Map<String, dynamic>.from(entry.value);
            item['id'] = entry.key;
            return item;
          }).toList();
          _loading = false;
        });
      } else {
        setState(() {
          _properties = [];
          _loading = false;
        });
      }
    });
  }


  Future<void> _fetchProperties() async {
    try {
      final snapshot = await _dbRef.get();
      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        setState(() {
          _properties = data.entries.map((entry) {
            final item = Map<String, dynamic>.from(entry.value);
            item['id'] = entry.key;
            return item;
          }).toList();
          _loading = false;
        });
      } else {
        setState(() {
          _properties = [];
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to fetch properties.';
        _loading = false;
      });
    }
  }
  Future<bool> _checkLocationPermission() async {
    var status = await Permission.location.status;

    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      final result = await Permission.location.request();
      return result.isGranted;
    } else if (status.isPermanentlyDenied) {
      openAppSettings(); // Optional: send user to app settings
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location permission is permanently denied. Please enable it in settings.'),
        ),
      );
      return false;
    }

    return false;
  }



  void _navigateToCategory(String label) {
    switch (label) {
      case 'Boarding House':
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BoardingHousePage()));
        break;
      case 'Apartment':
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ApartmentPage()));
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No page defined for $label')),
        );
    }
  }


  Widget _buildCategoryButton(IconData icon, String label) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () async {
        if (await _checkLocationPermission()) {
          _navigateToCategory(label);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        decoration: BoxDecoration(
          color: colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: colorScheme.primary),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: colorScheme.primary, size: 20.sp),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyCard(Map property) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4.r,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            child: Image.network(
              property['imageUrl'] ?? '',
              height: 250.h,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 120.h,
                color: Colors.grey[200],
                child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(property['title'] ?? 'No Title', style: textTheme.titleMedium),
                SizedBox(height: 4.h),
                Text(
                  '${property['description'] ?? ''} · ₱${property['price']} · ${property['location']}',
                  style: textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onBottomNavTapped(int index) async {
    setState(() => _currentIndex = index);
    switch (index) {
      case 1:
        if (await _checkLocationPermission()) {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchPage())
          );
        }
        break;
      case 2:
        if (await _checkLocationPermission()) {
         Navigator.push(
           context,
           MaterialPageRoute(builder: (context) => ManagePropertyPage())
         );
        }
        break;
      case 3:
        if (await _checkLocationPermission()) {
          Navigator.push(
            context,
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MessagesListPage(
                    currentUserId: auth.currentUser!.uid,
                    isOwner: true, // or false depending on role
                  ),
                ),
              ));

              }
        break;
      case 4:
        context.go('/owner/settings', extra: {
          'role': 'owner',
          'ownerId': widget.ownerId ?? '',
        });
        break;
    }
  }


  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hi ${widget.ownerId ?? "Owner"}', style: textTheme.titleSmall),
                      Text('Discover', style: textTheme.titleLarge),
                    ],
                  ),
                  Builder(
                    builder: (context) => IconButton(
                      icon: Icon(Icons.menu, size: 24.sp),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OwnerSettingsPage(
                              role: 'owner',
                              ownerId: widget.ownerId ?? '',
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              Text('Find a place to your liking', style: textTheme.headlineSmall),
              SizedBox(height: 10.h),
              Text('Explore categories', style: textTheme.titleMedium),
              SizedBox(height: 16.h),
              GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 12.h,
                childAspectRatio: 3,
                children: [
                  _buildCategoryButton(Icons.hotel, 'Boarding House'),
                  _buildCategoryButton(Icons.apartment, 'Apartment'),
                ],
              ),
              SizedBox(height: 24.h),
              GestureDetector(
                onTap: () async {
                  if (await _checkLocationPermission()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Map tapped')),
                    );
                  }
                },
                child: Container(
                  height: 150.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4.r)],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: FlutterMap(
                      mapController: MapController(),
                      options: MapOptions(
                        initialCenter: LatLng(14.5995, 120.9842),
                        initialZoom: 13,
                        interactionOptions: const InteractionOptions(flags: InteractiveFlag.all),
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.abodes',
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              width: 40,
                              height: 40,
                              point: LatLng(14.5995, 120.9842),
                              child: Icon(Icons.location_pin, size: 32, color: Colors.red),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              Text('Nearby Accommodations', style: textTheme.titleMedium),
              SizedBox(height: 12.h),
              _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                  ? Center(child: Text(_error!, style: TextStyle(color: Colors.red)))
                  : Column(children: _properties.map((p) => _buildPropertyCard(p)).toList()),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.settings_applications_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.message_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person_outlined), label: ''),
        ],
      ),
    );
  }
}
