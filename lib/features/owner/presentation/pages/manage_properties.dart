import 'package:abodesv1/features/owner/presentation/pages/homepage.dart';
import 'package:abodesv1/features/owner/presentation/pages/upload_properties.dart';
import 'package:abodesv1/features/auth/presentation/pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:go_router/go_router.dart';

class ManagePropertyPage extends StatefulWidget {
  const ManagePropertyPage({super.key});

  @override
  State<ManagePropertyPage> createState() => _ManagePropertyPageState();
}

class _ManagePropertyPageState extends State<ManagePropertyPage> {
  final user = FirebaseAuth.instance.currentUser;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref('properties');

  List<Map<String, dynamic>> _ownerProperties = [];
  bool _loading = true;
  String? _error;
  int _currentIndex = 2;

  @override
  void initState() {
    super.initState();
    _fetchOwnerProperties();
    
  }

  Future<void> _fetchOwnerProperties() async {
    try {
      final snapshot = await _dbRef.get();
      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        final filtered = data.entries
            .where((entry) => entry.value['ownerId'] == user?.uid)
            .map((entry) {
          final property = Map<String, dynamic>.from(entry.value);
          property['id'] = entry.key;
          return property;
        })
            .toList();

        setState(() {
          _ownerProperties = filtered;
          _loading = false;
        });
      } else {
        setState(() {
          _ownerProperties = [];
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to load properties';
        _loading = false;
      });
    }
  }

  Future<void> _deleteProperty(String id) async {
    try {
      await _dbRef.child(id).remove();
      setState(() {
        _ownerProperties.removeWhere((prop) => prop['id'] == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Property deleted')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete: $e')),
      );
    }
  }

  void _showDeleteConfirmation(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Property'),
        content: const Text('Are you sure you want to delete this property?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteProperty(id);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _onNavTap(int index) {
    setState(() => _currentIndex = index);
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OwnerHomePage(
            ),
          ),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchPage(
            ),
          ),
        );
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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Properties'),
        backgroundColor: colorScheme.primary,
        centerTitle: true,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.add, size: 24.sp),
              tooltip: 'Add Property',
              onPressed: () {
                // context.push('upload');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UploadPropertyPage(
                    ),
                  ),
                );
              },
            ),
          ),

        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _ownerProperties.isEmpty
          ? const Center(child: Text('No properties uploaded yet.'))
          : ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: _ownerProperties.length,
        itemBuilder: (context, index) {
          final prop = _ownerProperties[index];
          return Card(
            margin: EdgeInsets.only(bottom: 12.h),
            child: ListTile(
              contentPadding: EdgeInsets.all(12.w),
              leading: prop['imageUrl'] != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.network(
                  prop['imageUrl'],
                  width: 60.w,
                  height: 60.h,
                  fit: BoxFit.cover,
                ),
              )
                  : const Icon(Icons.image_not_supported),
              title: Text(prop['title'] ?? 'No Title'),
              subtitle: Text('${prop['location']} • ₱${prop['price']}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _showDeleteConfirmation(prop['id']),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: colorScheme.primary,
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
