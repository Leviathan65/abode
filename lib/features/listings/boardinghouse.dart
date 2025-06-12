import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:abodesv1/features/chat/messages.dart';
import 'package:firebase_auth/firebase_auth.dart';


class BoardingHousePage extends StatefulWidget {
  const BoardingHousePage({super.key});

  @override
  State<BoardingHousePage> createState() => _BoardingHousePage();
}

class _BoardingHousePage extends State<BoardingHousePage> {
  final DatabaseReference _propertiesRef = FirebaseDatabase.instance.ref('properties');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Boarding Houses", style: TextStyle(fontSize: 18.sp)),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(12.w),
        child: StreamBuilder(
          stream: _propertiesRef.onValue,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
              return const Center(child: Text("No Boarding Houses found."));
            }

            final data = Map<String, dynamic>.from(
              (snapshot.data! as DatabaseEvent).snapshot.value as Map,
            );

            final apartments = data.entries
                .map((entry) => Map<String, dynamic>.from(entry.value))
                .where((item) =>
            item['title']?.toString().toLowerCase().contains('boarding') ?? false)
                .toList();

            if (apartments.isEmpty) {
              return const Center(child: Text("No Boarding Houses found."));
            }

            return SizedBox(
              height: 700.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: apartments.length,
                separatorBuilder: (_, __) => SizedBox(width: 16.w),
                itemBuilder: (context, index) {
                  final property = apartments[index];
                  final imageUrl = property['imageUrl'] ?? '';
                  final title = property['title'] ?? 'Untitled';
                  final price = property['price'] ?? 'N/A';
                  final location = property['location'] ?? 'Unknown';
                  final description = property['description'] ?? '';
                  final shortDesc = description.length > 80
                      ? '${description.substring(0, 80)}... See more'
                      : description;

                  return Container(
                    width: 300.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                            imageUrl,
                            height: 250.h,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              height: 150.h,
                              color: Colors.grey[300],
                              child: const Center(child: Icon(Icons.broken_image)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(12.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      title,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '₱$price',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.green.shade700,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                location,
                                style: TextStyle(fontSize: 12.sp, color: Colors.grey[700]),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                shortDesc,
                                style: TextStyle(fontSize: 12.sp, color: Colors.black87),
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                children: [
                                  Icon(Icons.star, color: Colors.orange, size: 18.sp),
                                  SizedBox(width: 4.w),
                                  Text(
                                    '4.5 (12 reviews)',
                                    style: TextStyle(fontSize: 12.sp, color: Colors.grey[700]),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12.h),
                              ElevatedButton(
                                onPressed: () {

                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(double.infinity, 36.h),
                                  backgroundColor: Colors.blueAccent,
                                ),
                                child: const Text('See Full Details'),
                              ),
                              SizedBox(height: 6.h),
                              OutlinedButton(
                                onPressed: () {
                                  // Add to favorite logic
                                },
                                style: OutlinedButton.styleFrom(
                                  minimumSize: Size(double.infinity, 36.h),
                                  side: const BorderSide(color: Colors.redAccent),
                                ),
                                child: Text(
                                  'Add to Favorite',
                                  style: TextStyle(color: Colors.redAccent),
                                ),
                              ),
                              SizedBox(height: 6.h),
                              ElevatedButton(
                                onPressed: () {
                                  final currentUserId = FirebaseAuth.instance.currentUser?.uid;
                                  final ownerId = property['ownerId'];

                                  if (currentUserId == null || ownerId == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Missing user information')),
                                    );
                                    return;
                                  }
                                  if (currentUserId == ownerId) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('You cannot message yourself')),
                                    );
                                    return;
                                  }

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EncryptedChatScreen(
                                        ownerId: ownerId,
                                        seekerId: currentUserId,
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(double.infinity, 36.h),
                                  backgroundColor: Colors.green,
                                ),
                                child: Text('Contact Owner'),
                              ),

                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
