import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:abodes/screens/signin_page.dart';

final TextEditingController _lastNameController = TextEditingController();
final TextEditingController _firstNameController = TextEditingController();
final TextEditingController _middleNameController = TextEditingController();
final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();

class CustomNameField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const CustomNameField({
    required this.label,
    required this.controller,
    super.key,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h), // spacing between fields
      height: 40.h,

      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(90.r),
      ),
      alignment: Alignment.centerLeft,
      child: TextField(
        controller: controller,
        style: TextStyle(fontSize: 14.sp, color: Colors.black),
        decoration: InputDecoration(border: InputBorder.none, hintText: label),
      ),
    );
  }
}

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

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
                top: 50.h,
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
                top: 100.h,
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
                top: 135.h,
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
                      Text(
                        'Name',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Container(
                        decoration: BoxDecoration(),
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 0.w),
                            child: Column(
                              children: [
                                CustomNameField(
                                  label: 'Last Name',
                                  controller: _lastNameController,
                                ),
                                CustomNameField(
                                  label: 'First Name',
                                  controller: _firstNameController,
                                ),
                                CustomNameField(
                                  label: 'Middle Name',
                                  controller: _middleNameController,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 5.h),

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
                        child: CustomNameField(
                          label: 'Enter your email',
                          controller: _emailController,
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
                            CustomNameField(
                              label: 'Enter your password',
                              controller: _passwordController,
                            ),
                            Image.asset(
                              'assets/icons/hidden.png',
                              width: 22.w,
                              height: 22.h,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 15.h),

                      // Terms
                      Row(
                        children: [
                          Image.asset(
                            'assets/icons/check-agree.png',
                            width: 19.w,
                            height: 19.h,
                          ),
                          SizedBox(width: 5.w),
                          Expanded(
                            child: Text(
                              'Agree with Terms and Conditions',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),

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
                            'Sign Up',
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
                            'or sign up with',
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
                                    builder: (context) => const SigninPage(),
                                  ),
                                ); // Handle navigation to Sign In page
                              },
                              child: Text(
                                'Sign in',
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
