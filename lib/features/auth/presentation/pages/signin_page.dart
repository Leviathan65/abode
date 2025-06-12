import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:go_router/go_router.dart';

class SigninPage extends StatefulWidget {
  final String role;

  const SigninPage({super.key, required this.role});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    setState(() => _isLoading = true);

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final roleSnapshot = await FirebaseDatabase.instance
            .ref("users/${user.uid}/role")
            .get();

        final role = roleSnapshot.value?.toString();

        if (role == "owner") {
          context.go('/owner'); // You could also use '/owner/${user.uid}' if needed
        } else if (role == "seeker") {
          context.go('/seeker');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Unknown user role.")),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Sign-in failed")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenUtilInit(
        designSize: const Size(412, 917),
        builder: (context, child) => SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 200.h),
                Text(
                  'Welcome Back',
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
                    'Sign in to continue to your account',
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
                SizedBox(height: 24.h),
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
                      Text('Email',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          )),
                      SizedBox(height: 8.h),
                      Container(
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(90.r),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
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
                      Text('Password',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          )),
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
                              onTap: () => setState(() {
                                _obscurePassword = !_obscurePassword;
                              }),
                              child: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey,
                                size: 22.w,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 25.h),
                      Center(
                        child: SizedBox(
                          width: 275.w,
                          height: 45.h,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleSignIn,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isLoading ? Colors.grey : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.r),
                              ),
                            ),
                            child: _isLoading
                                ? CircularProgressIndicator(
                              color: const Color.fromRGBO(21, 9, 91, 0.9),
                            )
                                : Text(
                              'Sign In',
                              style: TextStyle(
                                fontFamily: 'M PLUS 1p',
                                fontWeight: FontWeight.w700,
                                fontSize: 24.sp,
                                color: const Color.fromRGBO(21, 9, 91, 0.9),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            context.push('/create-account');
                          },
                          child: Text(
                            "Don't have an account? Sign Up",
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
      ),
    );
  }
}
