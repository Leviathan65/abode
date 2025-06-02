import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:abodes/screens/signup_page.dart';

class SigninPage extends StatelessWidget {
  const SigninPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenUtilInit(
        builder: (context, child) => SizedBox(
          width: 412.w,
          height: 917.h,
          child: Stack(
            children: [
              Container(color: Colors.white),

              // Create Account title
              Positioned(
                left: 55.w,
                top: 103.h,
                child: Text(
                  'Create Account',
                  style: TextStyle(
                    fontFamily: 'M PLUS 1p',
                    fontWeight: FontWeight.w700,
                    fontSize: 40.sp,
                    height: 59 / 40,
                    color: Colors.black,
                  ),
                ),
              ),

              // Subtitle
              Positioned(
                left: 35.w,
                top: 183.h,
                child: SizedBox(
                  width: 293.w,
                  child: Text(
                    'Hi new here, Pls fill your information below to create your account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'M PLUS 1p',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      height: 21 / 14,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),

              // Blue rounded rectangle
              Positioned(
                left: 10.w,
                top: 230.h,
                child: Container(
                  width: 340.w,
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 20.h,
                  ),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(21, 9, 91, 0.9),
                    borderRadius: BorderRadius.circular(35.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name
                      SizedBox(height: 15.h),

                      // Email
                      Text(
                        'Email',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Container(
                        height: 35.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(90.r),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'example@gmail.com',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.black,
                          ),
                        ),
                      ),

                      SizedBox(height: 15.h),

                      // Password
                      Text(
                        'Password',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Container(
                        height: 35.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(90.r),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '************',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.black,
                              ),
                            ),
                            Image.asset(
                              'assets/icons/hidden.png',
                              width: 22.w,
                              height: 22.h,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.h),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignupPage(),
                            ),
                          ); // Handle forgot password action
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),

                      // Terms
                      SizedBox(height: 15.h),

                      // Sign Up Button
                      Center(
                        child: Container(
                          width: 275.w,
                          height: 40.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              fontFamily: 'M PLUS 1p',
                              fontWeight: FontWeight.w700,
                              fontSize: 24.sp,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // OR Divider
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 40.w,
                            height: 1,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'or sign in with',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Container(
                            width: 40.w,
                            height: 1,
                            color: Colors.white,
                          ),
                        ],
                      ),

                      SizedBox(height: 15.h),

                      // Social Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 24.r,
                            backgroundColor: Colors.white,
                            child: Image.asset(
                              'assets/icons/facebook.png',
                              width: 24.w,
                            ), // Replace with real asset
                          ),
                          SizedBox(width: 20.w),
                          CircleAvatar(
                            radius: 24.r,
                            backgroundColor: Colors.white,
                            child: Image.asset(
                              'assets/icons/google.png',
                              width: 24.w,
                            ), // Replace with real asset
                          ),
                        ],
                      ),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account? ',
                              style: TextStyle(
                                fontFamily: 'M PLUS 1p',
                                fontWeight: FontWeight.w700,
                                fontSize: 14.sp,
                                color: Colors.white,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignupPage(),
                                  ),
                                ); // Handle navigation to Sign In page
                              },
                              child: Text(
                                'Sign up',
                                style: TextStyle(
                                  fontFamily: 'M PLUS 1p',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14.sp,
                                  color: Colors.blueAccent,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
