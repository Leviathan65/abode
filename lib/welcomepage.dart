import 'package:abodes/accountpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const WelcomePage());
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen size

    return MaterialApp(
      // Root widget
      home: SizedBox(
        width: 412.w,
        height: 917.h,
        child: Stack(
          children: [
            // Background white
            Container(color: Colors.white),

            // Rectangle 1 - blue rounded container
            Positioned(
              left: 0.w,
              top: 437.h,
              width: 418.w,
              height: 523.h,
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(21, 9, 91, 0.9),
                  borderRadius: BorderRadius.circular(35),
                ),
              ),
            ),

            // Title Text
            Positioned(
              left: (412 - 389) / 2 + 0.5.w, // centering logic from CSS
              top: 479.h,
              width: 389.w,
              height: 96.h,
              child: Text(
                'Find or Manage Verified Accommodation Easily',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily:
                      'M PLUS 1p', // you'd need to import this font or use default
                  fontWeight: FontWeight.w700,
                  fontSize: 32,
                  height: 48 / 32, // line height
                  color: Colors.white,
                  decoration: TextDecoration.none,
                ),
              ),
            ),

            // Group 1 - the button background
            Positioned(
              left: 35.w,
              top: 701.h,
              width: 339.w,
              height: 62.h,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateAccountPage(),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Find Your New Place',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'M PLUS 1p',
                      fontWeight: FontWeight.w400,
                      fontSize: 22,
                      height: 33 / 22,
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ),
            ),

            // Description text
            Positioned(
              left: 13.w,
              top: 605.h,
              width: 384.w,
              height: 66.h,
              child: Text(
                'ABoDES can make your searching for verified housing (apartment, boarding houses, transient, and others) more accessible and easy in the tap of your hand.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'M PLUS 1p',
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                  height: 22 / 15,
                  color: Colors.white,
                  decoration: TextDecoration.none,
                ),
              ),
            ),

            // Sign in text
            Positioned(
              left: 33.w,
              top: 793.h,
              width: 350.w,
              height: 33.h,
              child: Text(
                'Already have an account? Sign In',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'M PLUS 1p',
                  fontWeight: FontWeight.w400,
                  fontSize: 22,
                  height: 33 / 22,
                  color: Colors.white,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
