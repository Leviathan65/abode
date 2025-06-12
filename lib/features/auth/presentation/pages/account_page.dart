import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:abodesv1/core/constants/app_colors.dart';

enum UserRole { owner, seeker }

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  UserRole? selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  Container(
                    height: 100.h,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  Positioned(
                    left: 8.w,
                    top: 20.h,
                    child: IconButton(
                      icon: const Icon(CupertinoIcons.back, color: Colors.white),
                      onPressed: () => context.go('/'),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 16.h,
                    child: Center(
                      child: Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 36.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32.h),

              RoleCard(
                title: 'I Am a House Owner',
                description:
                'Owner of an apartment, boarding house, transient place, or a renting house and others.',
                selected: selectedRole == UserRole.owner,
                onTap: () {
                  setState(() => selectedRole = UserRole.owner);
                },
              ),

              SizedBox(height: 24.h),

              RoleCard(
                title: 'I Am looking for a place',
                description:
                'Searching for boarding houses, apartments, and renting places.',
                selected: selectedRole == UserRole.seeker,
                onTap: () {
                  setState(() => selectedRole = UserRole.seeker);
                },
              ),

              SizedBox(height: 48.h),

              ElevatedButton(
                onPressed: () {
                  if (selectedRole != null) {
                    final role = selectedRole!.name;
                    final ownerId = selectedRole == UserRole.owner ? 'ownerId' : null;
                    context.push(
                      '/signup',
                      extra: {
                        'role': role,

                      },
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select a role.')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  selectedRole != null ? AppColors.primary : Colors.grey,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),

              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}

class RoleCard extends StatelessWidget {
  final String title;
  final String description;
  final bool selected;
  final VoidCallback onTap;

  const RoleCard({
    super.key,
    required this.title,
    required this.description,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          border: Border.all(
            color: selected ? AppColors.primary : Colors.grey,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(10),
          color: selected ? Colors.deepPurple.shade50 : Colors.white,
          boxShadow: [
            if (selected)
              const BoxShadow(
                color: Colors.deepPurple,
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              CupertinoIcons.checkmark_seal_fill,
              size: 40.w,
              color: selected ? AppColors.primary : Colors.grey.shade400,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14.sp,
                      height: 1.5,
                      color: Colors.black87,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
