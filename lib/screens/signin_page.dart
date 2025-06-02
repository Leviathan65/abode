import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:abodes/screens/signup_page.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _signIn() {
    if (_formKey.currentState!.validate()) {
      // Here you would call your sign in logic with _emailController.text and _passwordController.text
      print('Email: ${_emailController.text}');
      print('Password: ${_passwordController.text}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signing in...')),
      );
    }
  }

  void _showForgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Forgot Password'),
        content: Text('Password recovery is not implemented yet.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenUtilInit(
        builder: (context, child) => SingleChildScrollView(
          child: Container(
            width: 412.w,
            height: 917.h,
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 80.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sign In',
                  style: TextStyle(
                    fontFamily: 'M PLUS 1p',
                    fontWeight: FontWeight.w700,
                    fontSize: 40.sp,
                    height: 59 / 40,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  'Welcome back! Please sign in to continue.',
                  style: TextStyle(
                    fontFamily: 'M PLUS 1p',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    height: 21 / 14,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 40.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(21, 9, 91, 0.9),
                    borderRadius: BorderRadius.circular(35.r),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Email Field
                        Text(
                          'Email',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(fontSize: 14.sp, color: Colors.black),
                          decoration: InputDecoration(
                            hintText: 'example@gmail.com',
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(90.r),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                            if (!emailRegex.hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20.h),

                        // Password Field
                        Text(
                          'Password',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          style: TextStyle(fontSize: 14.sp, color: Colors.black),
                          decoration: InputDecoration(
                            hintText: 'Enter your password',
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(90.r),
                              borderSide: BorderSide.none,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: _togglePasswordVisibility,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10.h),

                        // Forgot Password
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: _showForgotPasswordDialog,
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.white,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 30.h),

                        // Sign In Button
                        Center(
                          child: GestureDetector(
                            onTap: _signIn,
                            child: Container(
                              width: 275.w,
                              height: 45.h,
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
                        ),

                        SizedBox(height: 25.h),

                        // OR Divider
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(width: 40.w, height: 1, color: Colors.white),
                            SizedBox(width: 8.w),
                            Text(
                              'or sign in with',
                              style: TextStyle(color: Colors.white, fontSize: 14.sp),
                            ),
                            SizedBox(width: 8.w),
                            Container(width: 40.w, height: 1, color: Colors.white),
                          ],
                        ),

                        SizedBox(height: 20.h),

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
                          ],
                        ),

                        SizedBox(height: 25.h),

                        // Sign Up Prompt
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account? ",
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
                                  );
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
      ),
    );
  }
}
