import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:abodes/screens/signin_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _agreeTerms = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _lastNameController.dispose();
    _firstNameController.dispose();
    _middleNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _buildNameField(String label, TextEditingController controller) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
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
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: label,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenUtilInit(
        builder: (context, child) => SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create Account',
                  style: TextStyle(
                    fontFamily: 'M PLUS 1p',
                    fontWeight: FontWeight.w700,
                    fontSize: 40.sp,
                    height: 59 / 40,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8.h),
                SizedBox(
                  width: 320.w,
                  child: Text(
                    'Hi new here, please fill your information below to create your account',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: 'M PLUS 1p',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      height: 21 / 14,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 24.h),

                // Blue box container
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(21, 9, 91, 0.9),
                    borderRadius: BorderRadius.circular(35.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.h),

                      _buildNameField('Last Name', _lastNameController),
                      _buildNameField('First Name', _firstNameController),
                      _buildNameField('Middle Name', _middleNameController),

                      SizedBox(height: 12.h),

                      Text(
                        'Email',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(90.r),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        alignment: Alignment.centerLeft,
                        child: TextField(
                          controller: _emailController,
                          style: TextStyle(fontSize: 14.sp, color: Colors.black),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter your email',
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),

                      SizedBox(height: 15.h),

                      Text(
                        'Password',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(90.r),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                style: TextStyle(fontSize: 14.sp, color: Colors.black),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Enter your password',
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              child: Icon(
                                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                color: Colors.grey,
                                size: 22.w,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 15.h),

                      Row(
                        children: [
                          Checkbox(
                            value: _agreeTerms,
                            onChanged: (bool? value) {
                              setState(() {
                                _agreeTerms = value ?? false;
                              });
                            },
                            activeColor: Colors.white,
                            checkColor: const Color.fromRGBO(21, 9, 91, 0.9),
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

                      Center(
                        child: SizedBox(
                          width: 275.w,
                          height: 45.h,
                          child: ElevatedButton(
                            onPressed: _agreeTerms
                                ? () {
                                    // Add your sign up logic here
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Sign Up pressed')),
                                    );
                                  }
                                : null, // disable button if terms not agreed
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _agreeTerms ? Colors.white : Colors.grey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.r),
                              ),
                            ),
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                fontFamily: 'M PLUS 1p',
                                fontWeight: FontWeight.w700,
                                fontSize: 24.sp,
                                color: _agreeTerms
                                    ? const Color.fromRGBO(21, 9, 91, 0.9)
                                    : Colors.black38,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // OR Divider
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(width: 40.w, height: 1, color: Colors.white),
                          SizedBox(width: 8.w),
                          Text(
                            'or sign up with',
                            style: TextStyle(color: Colors.white, fontSize: 14.sp),
                          ),
                          SizedBox(width: 8.w),
                          Container(width: 40.w, height: 1, color: Colors.white),
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
                            ),
                          ),
                          SizedBox(width: 20.w),
                          CircleAvatar(
                            radius: 24.r,
                            backgroundColor: Colors.white,
                            child: Image.asset(
                              'assets/icons/google.png',
                              width: 24.w,
                            ),
                          ),
                          SizedBox(width: 20.w),
                          CircleAvatar(
                            radius: 24.r,
                            backgroundColor: Colors.white,
                            child: Image.asset(
                              'assets/icons/apple.png',
                              width: 24.w,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 25.h),

                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SignInPage()),
                            );
                          },
                          child: Text(
                            'Already have an account? Sign In',
                            style: TextStyle(
                              fontFamily: 'M PLUS 1p',
                              fontWeight: FontWeight.w700,
                              fontSize: 14.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
        designSize: const Size(412, 917),
      ),
    );
  }
}
