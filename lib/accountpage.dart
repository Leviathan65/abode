import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:abodes/welcomepage.dart';
import 'package:abodes/screens/owner_create_accountpage.dart';
import 'package:abodes/screens/signup_page.dart';

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
              // Top Bar with back button
              Stack(
                children: [
                  Container(
                    height: 100.h,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(21, 9, 91, 0.9),
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  Positioned(
                    left: 8.w,
                    top: 20.h,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const WelcomePage()),
                        );
                      },
                      child: Image.asset(
                        'assets/icons/backbutton.png',
                        width: 40.w,
                        height: 40.h,
                      ),
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

              // Owner Role Card
              RoleCard(
                title: 'I Am a House Owner',
                description:
                    'Owner of an apartment, boarding house, transient place, or a renting house and others.',
                selected: selectedRole == UserRole.owner,
                onTap: () {
                  setState(() {
                    selectedRole = selectedRole == UserRole.owner ? null : UserRole.owner;
                  });
                },
              ),

              SizedBox(height: 24.h),

              // Seeker Role Card
              RoleCard(
                title: 'I Am looking for a place',
                description: 'Searching for boarding houses, apartments, and renting places.',
                selected: selectedRole == UserRole.seeker,
                onTap: () {
                  setState(() {
                    selectedRole = selectedRole == UserRole.seeker ? null : UserRole.seeker;
                  });
                },
              ),

              SizedBox(height: 48.h),

              // Continue Button
              ElevatedButton(
                onPressed: () {
                  if (selectedRole == UserRole.owner) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const OwnerCreateAccountPage()),
                    );
                  } else if (selectedRole == UserRole.seeker) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignupPage()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select a role.')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedRole != null ? Colors.deepPurple : Colors.grey,
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

// Separate reusable RoleCard widget for cleaner code
class RoleCard extends StatelessWidget {
  final String title;
  final String description;
  final bool selected;
  final VoidCallback onTap;

  const RoleCard({
    Key? key,
    required this.title,
    required this.description,
    required this.selected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          border: Border.all(
            color: selected ? const Color.fromRGBO(21, 9, 91, 0.9) : Colors.grey,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(10),
          color: selected ? Colors.deepPurple.shade50 : Colors.white,
          boxShadow: [
            if (selected)
              BoxShadow(
                color: Colors.deepPurple.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Opacity(
              opacity: selected ? 1 : 0.3,
              child: Image.asset(
                'assets/icons/checkbutton.png',
                width: 40.w,
                height: 40.h,
              ),
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
