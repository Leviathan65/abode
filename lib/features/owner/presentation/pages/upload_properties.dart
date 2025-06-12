import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:abodesv1/core/constants/app_theme.dart';
import 'package:abodesv1/core/constants/app_colors.dart';
class UploadPropertyPage extends StatefulWidget {
  const UploadPropertyPage({super.key});

  @override
  State<UploadPropertyPage> createState() => _UploadPropertyPageState();
}

class _UploadPropertyPageState extends State<UploadPropertyPage> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _locationController = TextEditingController();
  final _priceController = TextEditingController();

  File? _imageFile;
  bool _isUploading = false;

  final String imgbbApiKey = 'f85d13d51f6b618220b916306471fa8d';

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
    }
  }

  Future<String?> _uploadToImgBB(File imageFile) async {
    try {
      final base64Image = base64Encode(await imageFile.readAsBytes());
      final url = Uri.parse('https://api.imgbb.com/1/upload?key=$imgbbApiKey');

      final response = await http.post(url, body: {
        'image': base64Image,
        'name': 'property_${DateTime.now().millisecondsSinceEpoch}'
      });

      final data = json.decode(response.body);
      return data['success'] ? data['data']['url'] : null;
    } catch (e) {
      debugPrint('Image upload error: $e');
      return null;
    }
  }

  Future<bool> _handleLocationPermission() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }


  Future<void> _uploadAndSave() async {
    if (_imageFile == null ||
        _titleController.text.isEmpty ||
        _descController.text.isEmpty ||
        _locationController.text.isEmpty ||
        _priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields')),
      );
      return;
    }

    setState(() => _isUploading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User not logged in");

      // 🔸 Get GPS Location
      final hasPermission = await _handleLocationPermission();
      if (!hasPermission) throw Exception("Location permission denied");

      final position = await Geolocator.getCurrentPosition();

      final imageUrl = await _uploadToImgBB(_imageFile!);
      if (imageUrl == null) throw Exception("Image upload failed");

      // 🔸 Save to Firebase with location
      await FirebaseDatabase.instance.ref('properties').push().set({
        'ownerId': user.uid,
        'title': _titleController.text.trim(),
        'description': _descController.text.trim(),
        'location': _locationController.text.trim(),
        'price': _priceController.text.trim(),
        'imageUrl': imageUrl,
        'latitude': position.latitude,
        'longitude': position.longitude,
        'timestamp': ServerValue.timestamp,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Property uploaded successfully!')),
      );

      _titleController.clear();
      _descController.clear();
      _locationController.clear();
      _priceController.clear();
      setState(() {
        _imageFile = null;
        _isUploading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed: ${e.toString()}')),
      );
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Property'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 180.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColors.borderDefault),
                  ),
                  child: _imageFile == null
                      ? const Center(child: Text('Tap to select image'))
                      : ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image.file(_imageFile!, fit: BoxFit.cover),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              _buildTextField(_titleController, 'Property Title'),
              SizedBox(height: 10.h),
              _buildTextField(_descController, 'Description', maxLines: 3),
              SizedBox(height: 10.h),
              _buildTextField(_locationController, 'Location'),
              SizedBox(height: 10.h),
              _buildTextField(_priceController, 'Monthly Price',
                  keyboardType: TextInputType.number),
              SizedBox(height: 20.h),
              _isUploading
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _uploadAndSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                  ),
                  child: const Text('Upload Property'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label, {
        int maxLines = 1,
        TextInputType keyboardType = TextInputType.text,
      }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }
}
