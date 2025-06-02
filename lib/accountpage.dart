import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:abodes/welcomepage.dart'; // Import the WelcomePage widget
import 'package:abodes/screens/owner_create_accountpage.dart'; // Import the OwnerCreateAccountPage widget
import 'package:abodes/screens/signup_page.dart'; // Import the SignupPage widget

enum UserRole { owner, seeker }

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  UserRole? selectedRole; // Global variable to store selected role

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: 412.w,
        height: 917.h,
        child: Stack(
          children: [
            // Background
            Container(color: Colors.white),

            // Top Container
            Positioned(
              left: 0.w,
              top: -31.h,
              width: 412.w,
              height: 123.h,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(21, 9, 91, 0.9),
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),

            // Rotated Image (Top)
            Positioned(
              left: 0.w,
              top: 40.h,
              width: 52.w,
              height: 52.h,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WelcomePage()),
                  );
                },
                child: Transform.rotate(
                  angle: 0,
                  child: Image.asset('assets/icons/backbutton.png'),
                ),
              ),
            ),

            // Create Account Title
            Positioned(
              left: 70.w,
              top: 141.h,
              width: 310.w,
              height: 59.h,
              child: const Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  decoration: TextDecoration.none,
                ),
              ),
            ),

            // Owner Container (whole tappable)
            Positioned(
              left: 62.w,
              top: 295.h,
              width: 281.w,
              height: 162.h,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedRole = (selectedRole == UserRole.owner)
                        ? null
                        : UserRole.owner;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: selectedRole == UserRole.owner
                          ? const Color.fromRGBO(21, 9, 91, 0.9)
                          : Colors.grey,
                      width: 4,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    children: [
                      // Check icon
                      Positioned(
                        left: 0,
                        top: 0,
                        width: 49.w,
                        height: 49.h,
                        child: IgnorePointer(
                          child: Opacity(
                            opacity: selectedRole == UserRole.owner ? 1.0 : 0.3,
                            child: Image.asset('assets/icons/checkbutton.png'),
                          ),
                        ),
                      ),

                      // Title
                      Positioned(
                        left: 57.w,
                        top: 5.h,
                        right: 0,
                        child: const Text(
                          'I Am a House Owner',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),

                      // Description
                      Positioned(
                        left: 15.w,
                        top: 50.h,
                        right: 0,
                        child: const Text(
                          'Owner of an apartment, boarding house, transient place, or a renting house and others.',
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: Colors.black,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Seeker Container (whole tappable)
            Positioned(
              left: 62.w,
              top: 563.h,
              width: 281.w,
              height: 162.h,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedRole = (selectedRole == UserRole.seeker)
                        ? null
                        : UserRole.seeker;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: selectedRole == UserRole.seeker
                          ? const Color.fromRGBO(21, 9, 91, 0.9)
                          : Colors.grey,
                      width: 4,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    children: [
                      // Check icon
                      Positioned(
                        left: 0,
                        top: 0,
                        width: 49.w,
                        height: 49.h,
                        child: IgnorePointer(
                          child: Opacity(
                            opacity: selectedRole == UserRole.seeker
                                ? 1.0
                                : 0.3,
                            child: Image.asset('assets/icons/checkbutton.png'),
                          ),
                        ),
                      ),

                      // Title
                      Positioned(
                        left: 53.w,
                        top: 5.h,
                        right: 0,
                        child: const Text(
                          'I Am looking for a place',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),

                      // Description
                      Positioned(
                        left: 20,
                        top: 50.h,
                        right: 0,
                        child: const Text(
                          'Searching for boarding houses, apartments, and renting places.',
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: Colors.black,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Bar Background
            Positioned(
              left: -6.w,
              top: 831.h,
              width: 418.w,
              height: 131.h,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(21, 9, 91, 0.9),
                  borderRadius: BorderRadius.circular(35),
                ),
              ),
            ),

            // Wrap your Continue button with GestureDetector
            Positioned(
              left: 68.w,
              top: 842.h,
              width: 275.w,
              height: 61.h,
              child: GestureDetector(
                onTap: () {
                  if (selectedRole == UserRole.owner) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OwnerCreateAccountPage(),
                      ),
                    );
                  } else if (selectedRole == UserRole.seeker) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignupPage(),
                      ),
                    );
                  } else {
                    // Optionally show a message if no role is selected
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select a role.')),
                    );
                  }
                },

                // Continue Button
                child: selectedRole != null
                    ? Positioned(
                        left: 68.w,
                        top: 842.h,
                        width: 275.w,
                        height: 61.h,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          alignment: Alignment.center, // center the text
                          child: const Text(
                            'Continue',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      )
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
